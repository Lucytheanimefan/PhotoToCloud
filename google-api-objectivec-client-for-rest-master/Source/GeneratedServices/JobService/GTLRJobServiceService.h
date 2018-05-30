// NOTE: This file was generated by the ServiceGenerator.

// ----------------------------------------------------------------------------
// API:
//   Cloud Job Discovery (jobs/v2)
// Description:
//   Cloud Job Discovery provides the capability to create, read, update, and
//   delete job postings, as well as search jobs based on keywords and filters.
// Documentation:
//   https://cloud.google.com/job-discovery/docs

#if GTLR_BUILT_AS_FRAMEWORK
  #import "GTLR/GTLRService.h"
#else
  #import "GTLRService.h"
#endif

#if GTLR_RUNTIME_VERSION != 3000
#error This file was generated by a different version of ServiceGenerator which is incompatible with this GTLR library source.
#endif

// Generated comments include content from the discovery document; avoid them
// causing warnings since clang's checks are some what arbitrary.
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdocumentation"

NS_ASSUME_NONNULL_BEGIN

// ----------------------------------------------------------------------------
// Authorization scopes

/**
 *  Authorization scope: Manage job postings
 *
 *  Value "https://www.googleapis.com/auth/jobs"
 */
GTLR_EXTERN NSString * const kGTLRAuthScopeJobService;
/**
 *  Authorization scope: View and manage your data across Google Cloud Platform
 *  services
 *
 *  Value "https://www.googleapis.com/auth/cloud-platform"
 */
GTLR_EXTERN NSString * const kGTLRAuthScopeJobServiceCloudPlatform;

// ----------------------------------------------------------------------------
//   GTLRJobServiceService
//

/**
 *  Service for executing Cloud Job Discovery queries.
 *
 *  Cloud Job Discovery provides the capability to create, read, update, and
 *  delete job postings, as well as search jobs based on keywords and filters.
 */
@interface GTLRJobServiceService : GTLRService

// No new methods

// Clients should create a standard query with any of the class methods in
// GTLRJobServiceQuery.h. The query can the be sent with GTLRService's execute
// methods,
//
//   - (GTLRServiceTicket *)executeQuery:(GTLRQuery *)query
//                     completionHandler:(void (^)(GTLRServiceTicket *ticket,
//                                                 id object, NSError *error))handler;
// or
//   - (GTLRServiceTicket *)executeQuery:(GTLRQuery *)query
//                              delegate:(id)delegate
//                     didFinishSelector:(SEL)finishedSelector;
//
// where finishedSelector has a signature of:
//
//   - (void)serviceTicket:(GTLRServiceTicket *)ticket
//      finishedWithObject:(id)object
//                   error:(NSError *)error;
//
// The object passed to the completion handler or delegate method
// is a subclass of GTLRObject, determined by the query method executed.

@end

NS_ASSUME_NONNULL_END

#pragma clang diagnostic pop
