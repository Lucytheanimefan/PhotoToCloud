// NOTE: This file was generated by the ServiceGenerator.

// ----------------------------------------------------------------------------
// API:
//   Cloud Video Intelligence API (videointelligence/v1)
// Description:
//   Cloud Video Intelligence API.
// Documentation:
//   https://cloud.google.com/video-intelligence/docs/

#import "GTLRCloudVideoIntelligence.h"

// ----------------------------------------------------------------------------
// Authorization scope

NSString * const kGTLRAuthScopeCloudVideoIntelligenceCloudPlatform = @"https://www.googleapis.com/auth/cloud-platform";

// ----------------------------------------------------------------------------
//   GTLRCloudVideoIntelligenceService
//

@implementation GTLRCloudVideoIntelligenceService

- (instancetype)init {
  self = [super init];
  if (self) {
    // From discovery.
    self.rootURLString = @"https://videointelligence.googleapis.com/";
    self.batchPath = @"batch";
    self.prettyPrintQueryParameterNames = @[ @"prettyPrint", @"pp" ];
  }
  return self;
}

@end