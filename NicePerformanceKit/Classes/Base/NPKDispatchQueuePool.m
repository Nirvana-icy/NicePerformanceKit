//
//  NPKDispatchQueuePool.m
//  NicePerformanceKit
//
//  Created by JinglongBi on 2021/9/10.
//

#import "NPKDispatchQueuePool.h"
#import <UIKit/UIKit.h>
#import <stdatomic.h>

#define MAX_QUEUE_COUNT 32

static inline qos_class_t NSQualityOfServiceToQOSClass(NSQualityOfService qos) {
    switch (qos) {
        case NSQualityOfServiceUserInteractive: return QOS_CLASS_USER_INTERACTIVE;
        case NSQualityOfServiceUserInitiated: return QOS_CLASS_USER_INITIATED;
        case NSQualityOfServiceUtility: return QOS_CLASS_UTILITY;
        case NSQualityOfServiceBackground: return QOS_CLASS_BACKGROUND;
        case NSQualityOfServiceDefault: return QOS_CLASS_DEFAULT;
        default: return QOS_CLASS_UNSPECIFIED;
    }
}

typedef struct {
    const char *name;
    void **queues;
    uint32_t queueCount;
    atomic_int counter;
} NPKDispatchContext;

static NPKDispatchContext *NPKDispatchContextCreate(const char *name,
                                                    uint32_t queueCount,
                                                    NSQualityOfService qos) {
    NPKDispatchContext *context = calloc(1, sizeof(NPKDispatchContext));
    if (!context) return NULL;
    context->queues = calloc(queueCount, sizeof(void *));
    if (!context->queues) {
        free(context);
        return NULL;
    }
    dispatch_qos_class_t qosClass = NSQualityOfServiceToQOSClass(qos);
    for (NSUInteger i = 0; i < queueCount; i++) {
        dispatch_queue_attr_t attr = dispatch_queue_attr_make_with_qos_class(DISPATCH_QUEUE_SERIAL, qosClass, 0);
        dispatch_queue_t queue = dispatch_queue_create(name, attr);
        context->queues[i] = (__bridge_retained void *)(queue);
    }
    context->queueCount = queueCount;
    if (name) {
        context->name = strdup(name);
    }
    return context;
}

static void NPKDispatchContextRelease(NPKDispatchContext *context) {
    if (!context) return;
    if (context->queues) {
        for (NSUInteger i = 0; i < context->queueCount; i++) {
            void *queuePointer = context->queues[i];
            dispatch_queue_t queue = (__bridge_transfer dispatch_queue_t)(queuePointer);
            const char *name = dispatch_queue_get_label(queue);
            if (name) strlen(name);
            queue = nil;
        }
        free(context->queues);
        context->queues = NULL;
    }
    if (context->name) free((void *)context->name);
}

static dispatch_queue_t NPKDispatchContextGetQueue(NPKDispatchContext *context) {
    uint32_t counter = (uint32_t)atomic_fetch_add_explicit(&context->counter, 1, memory_order_relaxed);
    void *queue = context->queues[counter % context->queueCount];
    return (__bridge dispatch_queue_t)(queue);
}

static NPKDispatchContext *NPKGetDispatchContextForQoS(NSQualityOfService qos) {
    static NPKDispatchContext *context[5] = {0};
    switch (qos) {
        case NSQualityOfServiceUserInteractive: {
            static dispatch_once_t onceToken;
            dispatch_once(&onceToken, ^{
                int count = (int)[NSProcessInfo processInfo].activeProcessorCount;
                count = count < 1 ? 1 : (count > MAX_QUEUE_COUNT ? MAX_QUEUE_COUNT : count);
                context[0] = NPKDispatchContextCreate("com.niceperformancekit.user-interactive", count, qos);
            });
            return context[0];
        } break;
        case NSQualityOfServiceUserInitiated: {
            static dispatch_once_t onceToken;
            dispatch_once(&onceToken, ^{
                int count = (int)[NSProcessInfo processInfo].activeProcessorCount;
                count = count < 1 ? 1 : (count > MAX_QUEUE_COUNT ? MAX_QUEUE_COUNT : count);
                context[1] = NPKDispatchContextCreate("com.niceperformancekit.user-initiated", count, qos);
            });
            return context[1];
        } break;
        case NSQualityOfServiceUtility: {
            static dispatch_once_t onceToken;
            dispatch_once(&onceToken, ^{
                int count = (int)[NSProcessInfo processInfo].activeProcessorCount;
                count = count < 1 ? 1 : (count > MAX_QUEUE_COUNT ? MAX_QUEUE_COUNT : count);
                context[2] = NPKDispatchContextCreate("com.niceperformancekit.utility", count, qos);
            });
            return context[2];
        } break;
        case NSQualityOfServiceBackground: {
            static dispatch_once_t onceToken;
            dispatch_once(&onceToken, ^{
                int count = (int)[NSProcessInfo processInfo].activeProcessorCount;
                count = count < 1 ? 1 : (count > MAX_QUEUE_COUNT ? MAX_QUEUE_COUNT : count);
                context[3] = NPKDispatchContextCreate("com.niceperformancekit.background", count, qos);
            });
            return context[3];
        } break;
        case NSQualityOfServiceDefault:
        default: {
            static dispatch_once_t onceToken;
            dispatch_once(&onceToken, ^{
                int count = (int)[NSProcessInfo processInfo].activeProcessorCount;
                count = count < 1 ? 1 : count > MAX_QUEUE_COUNT ? MAX_QUEUE_COUNT : count;
                context[4] = NPKDispatchContextCreate("com.niceperformancekit.default", count, qos);
            });
            return context[4];
        } break;
    }
}

@implementation NPKDispatchQueuePool {
    @public
    NPKDispatchContext *_context;
}

- (void)dealloc {
    if (_context) {
        NPKDispatchContextRelease(_context);
        _context = NULL;
    }
}

- (instancetype)initWithContext:(NPKDispatchContext *)context {
    self = [super init];
    if (!context) return nil;
    self->_context = context;
    _name = context->name ? [NSString stringWithUTF8String:context->name] : nil;
    return self;
}

- (instancetype)initWithName:(nullable NSString *)name queueCount:(NSUInteger)queueCount qos:(NSQualityOfService)qos {
    if (0 == queueCount || queueCount > MAX_QUEUE_COUNT) return nil;
    self = [super init];
    _context = NPKDispatchContextCreate(name.UTF8String, (uint32_t)queueCount, qos);
    if (!_context) return nil;
    _name = name;
    return self;
}

- (dispatch_queue_t)queue {
    return NPKDispatchContextGetQueue(_context);
}

+ (instancetype)defaultPoolForQOS:(NSQualityOfService)qos {
    switch (qos) {
        case NSQualityOfServiceUserInteractive: {
            static NPKDispatchQueuePool *pool;
            static dispatch_once_t onceToken;
            dispatch_once(&onceToken, ^{
                pool = [[NPKDispatchQueuePool alloc] initWithContext:NPKGetDispatchContextForQoS(qos)];
            });
            return pool;
        } break;
        case NSQualityOfServiceUserInitiated: {
            static NPKDispatchQueuePool *pool;
            static dispatch_once_t onceToken;
            dispatch_once(&onceToken, ^{
                pool = [[NPKDispatchQueuePool alloc] initWithContext:NPKGetDispatchContextForQoS(qos)];
            });
            return pool;
        } break;
        case NSQualityOfServiceUtility: {
            static NPKDispatchQueuePool *pool;
            static dispatch_once_t onceToken;
            dispatch_once(&onceToken, ^{
                pool = [[NPKDispatchQueuePool alloc] initWithContext:NPKGetDispatchContextForQoS(qos)];
            });
            return pool;
        } break;
        case NSQualityOfServiceBackground: {
            static NPKDispatchQueuePool *pool;
            static dispatch_once_t onceToken;
            dispatch_once(&onceToken, ^{
                pool = [[NPKDispatchQueuePool alloc] initWithContext:NPKGetDispatchContextForQoS(qos)];
            });
            return pool;
        } break;
        case NSQualityOfServiceDefault:
        default: {
            static NPKDispatchQueuePool *pool;
            static dispatch_once_t onceToken;
            dispatch_once(&onceToken, ^{
                pool = [[NPKDispatchQueuePool alloc] initWithContext:NPKGetDispatchContextForQoS(NSQualityOfServiceDefault)];
            });
            return pool;
        } break;
    }
}

@end

dispatch_queue_t NPKDispatchQueueGetForQoS(NSQualityOfService qos) {
    return NPKDispatchContextGetQueue(NPKGetDispatchContextForQoS(qos));
}
