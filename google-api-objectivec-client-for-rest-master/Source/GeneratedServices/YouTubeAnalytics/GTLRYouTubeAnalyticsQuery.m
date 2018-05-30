// NOTE: This file was generated by the ServiceGenerator.

// ----------------------------------------------------------------------------
// API:
//   YouTube Analytics API (youtubeAnalytics/v2)
// Description:
//   Retrieves your YouTube Analytics data.
// Documentation:
//   http://developers.google.com/youtube/analytics

#import "GTLRYouTubeAnalyticsQuery.h"

#import "GTLRYouTubeAnalyticsObjects.h"

@implementation GTLRYouTubeAnalyticsQuery

@dynamic fields;

@end

@implementation GTLRYouTubeAnalyticsQuery_GroupItemsDelete

@dynamic identifier, onBehalfOfContentOwner;

+ (NSDictionary<NSString *, NSString *> *)parameterNameMap {
  return @{ @"identifier" : @"id" };
}

+ (instancetype)query {
  NSString *pathURITemplate = @"v2/groupItems";
  GTLRYouTubeAnalyticsQuery_GroupItemsDelete *query =
    [[self alloc] initWithPathURITemplate:pathURITemplate
                               HTTPMethod:@"DELETE"
                       pathParameterNames:nil];
  query.expectedObjectClass = [GTLRYouTubeAnalytics_EmptyResponse class];
  query.loggingName = @"youtubeAnalytics.groupItems.delete";
  return query;
}

@end

@implementation GTLRYouTubeAnalyticsQuery_GroupItemsInsert

@dynamic onBehalfOfContentOwner;

+ (instancetype)queryWithObject:(GTLRYouTubeAnalytics_GroupItem *)object {
  if (object == nil) {
    GTLR_DEBUG_ASSERT(object != nil, @"Got a nil object");
    return nil;
  }
  NSString *pathURITemplate = @"v2/groupItems";
  GTLRYouTubeAnalyticsQuery_GroupItemsInsert *query =
    [[self alloc] initWithPathURITemplate:pathURITemplate
                               HTTPMethod:@"POST"
                       pathParameterNames:nil];
  query.bodyObject = object;
  query.expectedObjectClass = [GTLRYouTubeAnalytics_GroupItem class];
  query.loggingName = @"youtubeAnalytics.groupItems.insert";
  return query;
}

@end

@implementation GTLRYouTubeAnalyticsQuery_GroupItemsList

@dynamic groupId, onBehalfOfContentOwner;

+ (instancetype)query {
  NSString *pathURITemplate = @"v2/groupItems";
  GTLRYouTubeAnalyticsQuery_GroupItemsList *query =
    [[self alloc] initWithPathURITemplate:pathURITemplate
                               HTTPMethod:nil
                       pathParameterNames:nil];
  query.expectedObjectClass = [GTLRYouTubeAnalytics_ListGroupItemsResponse class];
  query.loggingName = @"youtubeAnalytics.groupItems.list";
  return query;
}

@end

@implementation GTLRYouTubeAnalyticsQuery_GroupsDelete

@dynamic identifier, onBehalfOfContentOwner;

+ (NSDictionary<NSString *, NSString *> *)parameterNameMap {
  return @{ @"identifier" : @"id" };
}

+ (instancetype)query {
  NSString *pathURITemplate = @"v2/groups";
  GTLRYouTubeAnalyticsQuery_GroupsDelete *query =
    [[self alloc] initWithPathURITemplate:pathURITemplate
                               HTTPMethod:@"DELETE"
                       pathParameterNames:nil];
  query.expectedObjectClass = [GTLRYouTubeAnalytics_EmptyResponse class];
  query.loggingName = @"youtubeAnalytics.groups.delete";
  return query;
}

@end

@implementation GTLRYouTubeAnalyticsQuery_GroupsInsert

@dynamic onBehalfOfContentOwner;

+ (instancetype)queryWithObject:(GTLRYouTubeAnalytics_Group *)object {
  if (object == nil) {
    GTLR_DEBUG_ASSERT(object != nil, @"Got a nil object");
    return nil;
  }
  NSString *pathURITemplate = @"v2/groups";
  GTLRYouTubeAnalyticsQuery_GroupsInsert *query =
    [[self alloc] initWithPathURITemplate:pathURITemplate
                               HTTPMethod:@"POST"
                       pathParameterNames:nil];
  query.bodyObject = object;
  query.expectedObjectClass = [GTLRYouTubeAnalytics_Group class];
  query.loggingName = @"youtubeAnalytics.groups.insert";
  return query;
}

@end

@implementation GTLRYouTubeAnalyticsQuery_GroupsList

@dynamic identifier, mine, onBehalfOfContentOwner, pageToken;

+ (NSDictionary<NSString *, NSString *> *)parameterNameMap {
  return @{ @"identifier" : @"id" };
}

+ (instancetype)query {
  NSString *pathURITemplate = @"v2/groups";
  GTLRYouTubeAnalyticsQuery_GroupsList *query =
    [[self alloc] initWithPathURITemplate:pathURITemplate
                               HTTPMethod:nil
                       pathParameterNames:nil];
  query.expectedObjectClass = [GTLRYouTubeAnalytics_ListGroupsResponse class];
  query.loggingName = @"youtubeAnalytics.groups.list";
  return query;
}

@end

@implementation GTLRYouTubeAnalyticsQuery_GroupsUpdate

@dynamic onBehalfOfContentOwner;

+ (instancetype)queryWithObject:(GTLRYouTubeAnalytics_Group *)object {
  if (object == nil) {
    GTLR_DEBUG_ASSERT(object != nil, @"Got a nil object");
    return nil;
  }
  NSString *pathURITemplate = @"v2/groups";
  GTLRYouTubeAnalyticsQuery_GroupsUpdate *query =
    [[self alloc] initWithPathURITemplate:pathURITemplate
                               HTTPMethod:@"PUT"
                       pathParameterNames:nil];
  query.bodyObject = object;
  query.expectedObjectClass = [GTLRYouTubeAnalytics_Group class];
  query.loggingName = @"youtubeAnalytics.groups.update";
  return query;
}

@end

@implementation GTLRYouTubeAnalyticsQuery_ReportsQuery

@dynamic currency, dimensions, endDate, filters, ids,
         includeHistoricalChannelData, maxResults, metrics, sort, startDate,
         startIndex;

+ (instancetype)query {
  NSString *pathURITemplate = @"v2/reports";
  GTLRYouTubeAnalyticsQuery_ReportsQuery *query =
    [[self alloc] initWithPathURITemplate:pathURITemplate
                               HTTPMethod:nil
                       pathParameterNames:nil];
  query.expectedObjectClass = [GTLRYouTubeAnalytics_QueryResponse class];
  query.loggingName = @"youtubeAnalytics.reports.query";
  return query;
}

@end
