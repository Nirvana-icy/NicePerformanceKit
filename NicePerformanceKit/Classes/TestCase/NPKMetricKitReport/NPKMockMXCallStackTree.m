//
//  NPKMockMXCallStackTree.m
//  NicePerformanceKit
//
//  Created by JinglongBi on 2021/10/13.
//

#import "NPKMockMXCallStackTree.h"

#if NPK_METRICKIT_SUPPORTED

@interface NPKMockMXCallStackTree ()

@property(readwrite, strong, nonnull) NSData *jsonData;

@end

@implementation NPKMockMXCallStackTree

- (instancetype)initWithStringData:(NSString *)stringData {
  self = [super init];
  _jsonData = [stringData dataUsingEncoding:NSUTF8StringEncoding];
  return self;
}

- (NSData *)JSONRepresentation {
  return self.jsonData;
}

@end

#endif
