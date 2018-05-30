// NOTE: This file was generated by the ServiceGenerator.

// ----------------------------------------------------------------------------
// API:
//   Service Broker API (servicebroker/v1)
// Description:
//   The Google Cloud Platform Service Broker API provides Google hosted
//   implementation of the Open Service Broker API
//   (https://www.openservicebrokerapi.org/).
// Documentation:
//   https://cloud.google.com/kubernetes-engine/docs/concepts/add-on/service-broker

#import "GTLRServiceBroker.h"

// ----------------------------------------------------------------------------
// Authorization scope

NSString * const kGTLRAuthScopeServiceBrokerCloudPlatform = @"https://www.googleapis.com/auth/cloud-platform";

// ----------------------------------------------------------------------------
//   GTLRServiceBrokerService
//

@implementation GTLRServiceBrokerService

- (instancetype)init {
  self = [super init];
  if (self) {
    // From discovery.
    self.rootURLString = @"https://servicebroker.googleapis.com/";
    self.batchPath = @"batch";
    self.prettyPrintQueryParameterNames = @[ @"prettyPrint", @"pp" ];
  }
  return self;
}

@end
