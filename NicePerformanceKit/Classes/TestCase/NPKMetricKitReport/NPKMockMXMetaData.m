//
//  NPKMockMXMetaData.m
//  NicePerformanceKit
//
//  Created by JinglongBi on 2021/10/13.
//

#import "NPKMockMXMetaData.h"

#if NPK_METRICKIT_SUPPORTED

@interface NPKMockMXMetaData ()

@property(readwrite, strong, nonnull) NSString *regionFormat;
@property(readwrite, strong, nonnull) NSString *osVersion;
@property(readwrite, strong, nonnull) NSString *deviceType;
@property(readwrite, strong, nonnull) NSString *applicationBuildVersion;
@property(readwrite, strong, nonnull) NSString *platformArchitecture;

@end

@implementation NPKMockMXMetaData

@synthesize regionFormat = _regionFormat;
@synthesize osVersion = _osVersion;
@synthesize deviceType = _deviceType;
@synthesize applicationBuildVersion = _applicationBuildVersion;
@synthesize platformArchitecture = _platformArchitecture;

- (instancetype)initWithRegionFormat:(NSString *)regionFormat
                           osVersion:(NSString *)osVersion
                          deviceType:(NSString *)deviceType
             applicationBuildVersion:(NSString *)applicationBuildVersion
                platformArchitecture:(NSString *)platformArchitecture {
  self = [super init];
  _regionFormat = regionFormat;
  _osVersion = osVersion;
  _deviceType = deviceType;
  _applicationBuildVersion = applicationBuildVersion;
  _platformArchitecture = platformArchitecture;
  return self;
}

- (NSData *)JSONRepresentation {
  NSDictionary *metadata = @{
    @"appBuildVersion" : self.applicationBuildVersion,
    @"osVersion" : self.osVersion,
    @"regionFormat" : self.regionFormat,
    @"platformArchitecture" : self.platformArchitecture,
    @"deviceType" : self.deviceType
  };
  return [NSJSONSerialization dataWithJSONObject:metadata options:0 error:nil];
}

@end

#endif
