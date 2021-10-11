//
//  NPKCallStackTree.m
//  NicePerformanceKit
//
//  Created by JinglongBi on 2021/10/11.
//

#import "NPKCallStackTree.h"

#if NPK_METRICKIT_SUPPORTED

@interface NPKFrame : NSObject

@property long address;
@property long sampleCount;
@property long offsetIntoBinaryTextSegment;
@property NSString *binaryName;
@property NSUUID *binaryUUID;

@end

@implementation NPKFrame
@end

@interface NPKThread : NSObject

@property NSString *threadName;
@property BOOL threadBlamed;
@property NSArray<NPKFrame *> *frames;

@end

@implementation NPKThread
@end

@interface NPKCallStackTree ()

@property NSArray<NPKThread *> *threads;
@property(nonatomic) BOOL callStackPerThread;

@end

@implementation NPKCallStackTree

- (instancetype)initWithMXCallStackTree:(MXCallStackTree *)callStackTree {
    NSData *jsonCallStackTree = callStackTree.JSONRepresentation;
    if ([jsonCallStackTree length] == 0) return nil;
    
    NSError *error = nil;
    NSDictionary *jsonDictionary = [NSJSONSerialization JSONObjectWithData:jsonCallStackTree
                                                                   options:0
                                                                     error:&error];
    if (error) {
        NPKLog(@"Error creating json.");
        return nil;
    }
    
    self = [super init];
    if (!self) {
        return nil;
    }
    _callStackPerThread = [[jsonDictionary objectForKey:@"callStackPerThread"] boolValue];
    
    // Recurse through the frames in the callStackTree and add them all to an array
    NSMutableArray<NPKThread *> *threads = [[NSMutableArray alloc] init];
    NSArray *callStacks = jsonDictionary[@"callStacks"];
    for (id object in callStacks) {
        NSMutableArray<NPKFrame *> *frames = [[NSMutableArray alloc] init];
        [self flattenSubFrames:object[@"callStackRootFrames"] intoFrames:frames];
        NPKThread *thread = [[NPKThread alloc] init];
        thread.threadBlamed = [[object objectForKey:@"threadAttributed"] boolValue];
        thread.frames = frames;
        [threads addObject:thread];
    }
    _threads = threads;
    return self;
}

// Flattens the nested structure we receive from MetricKit into an array of frames.
- (void)flattenSubFrames:(NSArray *)callStacks intoFrames:(NSMutableArray *)frames {
    NSDictionary *rootFrames = [callStacks firstObject];
    NPKFrame *frame = [[NPKFrame alloc] init];
    frame.offsetIntoBinaryTextSegment =
    [[rootFrames valueForKey:@"offsetIntoBinaryTextSegment"] longValue];
    frame.address = [[rootFrames valueForKey:@"address"] longValue];
    frame.sampleCount = [[rootFrames valueForKey:@"sampleCount"] longValue];
    frame.binaryUUID = [rootFrames valueForKey:@"binaryUUID"];
    frame.binaryName = [rootFrames valueForKey:@"binaryName"];
    
    [frames addObject:frame];
    
    // Recurse through any subframes and add them to the array.
    if ([rootFrames objectForKey:@"subFrames"]) {
        [self flattenSubFrames:[rootFrames objectForKey:@"subFrames"] intoFrames:frames];
    }
}

- (NSArray *)getArrayRepresentation {
    NSMutableArray *threadArray = [[NSMutableArray alloc] init];
    for (NPKThread *thread in self.threads) {
        [threadArray addObject:[self getDictionaryRepresentation:thread]];
    }
    return threadArray;
}

- (NSDictionary *)getDictionaryRepresentation:(NPKThread *)thread {
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
    [dictionary setObject:@{} forKey:@"registers"];
    NSMutableArray *frameArray = [[NSMutableArray alloc] init];
    for (NPKFrame *frame in thread.frames) {
        [frameArray addObject:[NSNumber numberWithLong:frame.address]];
    }
    [dictionary setObject:frameArray forKey:@"stacktrace"];
    [dictionary setObject:[NSNumber numberWithBool:thread.threadBlamed] forKey:@"crashed"];
    return dictionary;
}

- (NSArray *)getFramesOfBlamedThread {
    for (NPKThread *thread in self.threads) {
        if (thread.threadBlamed) {
            return [self convertFramesFor:thread];
        }
    }
    if ([self.threads count] > 0) {
        return [self convertFramesFor:self.threads.firstObject];
    }
    return [NSArray array];
}

- (NSArray *)convertFramesFor:(NPKThread *)thread {
    NSMutableArray *frames = [[NSMutableArray alloc] init];
    for (NPKFrame *frame in thread.frames) {
        [frames addObject:@{
            @"pc" : [NSNumber numberWithLong:frame.address],
            @"offset" : [NSNumber numberWithLong:frame.offsetIntoBinaryTextSegment],
            @"line" : @0
        }];
    }
    return frames;
}

@end

#endif
