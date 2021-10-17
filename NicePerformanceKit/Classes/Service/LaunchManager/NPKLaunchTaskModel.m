//
//  NPKLaunchTaskModel.m
//  NicePerformanceKit
//
//  Created by JinglongBi on 2021/9/20.
//

#import "NPKLaunchTaskModel.h"

@implementation NPKLaunchTaskModel

- (instancetype)initWithDict:(NSDictionary *)dict {
    self = [super init];
    if (self) {
        _name = dict[@"name"];
        _type = [dict[@"type"] integerValue];
        _taskClassList = dict[@"taskClassList"];
    }
    return self;
}

@end
