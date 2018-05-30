// NOTE: This file was generated by the ServiceGenerator.

// ----------------------------------------------------------------------------
// API:
//   Cloud Text-to-Speech API (texttospeech/v1beta1)
// Description:
//   Synthesizes natural-sounding speech by applying powerful neural network
//   models.
// Documentation:
//   http://cloud.google.com/text-to-speech/

#import "GTLRTexttospeech.h"

// ----------------------------------------------------------------------------
// Authorization scope

NSString * const kGTLRAuthScopeTexttospeechCloudPlatform = @"https://www.googleapis.com/auth/cloud-platform";

// ----------------------------------------------------------------------------
//   GTLRTexttospeechService
//

@implementation GTLRTexttospeechService

- (instancetype)init {
  self = [super init];
  if (self) {
    // From discovery.
    self.rootURLString = @"https://texttospeech.googleapis.com/";
    self.batchPath = @"batch";
    self.prettyPrintQueryParameterNames = @[ @"prettyPrint", @"pp" ];
  }
  return self;
}

@end
