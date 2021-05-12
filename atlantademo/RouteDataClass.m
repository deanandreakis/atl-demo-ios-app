//
//  RouteDataClass.m
//  atlantademo
//
//  Created by Melinda Frost on 11/10/17.
//  Copyright © 2017 gisi. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "retailerdef.h"
#import "RouteDataClass.h"
#import "GateLocations.h"

@implementation RouteDataClass
    ATRRouteManager *routeMgr;
    ATRRouteRequest *routeRequest;
    double startX;
    double startY;
    double endX;
    double endY;

-(id) init{
    self = [super init];
    
    return self;
}

- (void) requestRoute: (NSArray*)route {
    [ATRCore setApiUrl:ATRIUS_BASE_URL_PREFIX];
    [ATRCore configureWithApiToken:ATRIUS_RETAILER_API_KEY andPartnerId:ATRIUS_PARTNER_ID andEnvironmentId:ATRIUS_ENVIRONMENT_ID];
    routeMgr = [ATRRouteManager sharedInstance];
    [routeMgr addDelegate:self];
    [routeMgr loadWithSite:ATRIUS_SITENAME];
    startX = [[route objectAtIndex:0]doubleValue];
    startY = [[route objectAtIndex:1]doubleValue];
    endX = [[route objectAtIndex:2]doubleValue];
    endY = [[route objectAtIndex:3]doubleValue];
}

- (void) requestRouteWithStop:(NSArray*)stops {
    if (routeMgr != nil){
        [routeMgr generateRoute:[self getRouteWithStops:stops]];
    }
}

- (void)onRouteGenerated:(ATRRoute * _Nullable)route {
        [self getRouteSegmentsAsString:route];
        self.routeSegments = route.segments;
        
        NSMutableDictionary* locInfo = [NSMutableDictionary dictionary];
        [locInfo setObject:[NSArray arrayWithArray:self.routeSegments] forKey:@"segments"];
        [locInfo setObject:[NSArray arrayWithArray:route.orderedStops] forKey:@"stops"];
        [locInfo setObject:[[NSNumber alloc] initWithLong:route.totalTravelMs] forKey:@"timeLeft"];
        [[NSNotificationCenter defaultCenter]
         postNotificationName:@"RouteGenerated"
         object: nil userInfo:locInfo];
    }

- (void) onRouteSiteLoaded {
     //todo: this callback is going to need some way to determine what route we want...where is
    // the user and where do they want to go? Right now its just hard coded to a route from T8 to T2
    [routeMgr generateRoute:[self getStaticRoute]];
}

- (void)onRouteError:(NSError *)error{
    NSLog(@"Error: %@", error);
}

#pragma mark Misc
- (NSString*) getRouteSegmentsAsString:(ATRRoute*) route {
    int expectedSegmentLineCount = 0;
    for (ATRRouteSegment *segment in route.segments){
        for (ATRRouteLine *line in segment.lines){
            if (line){
                expectedSegmentLineCount++;
            }
        }
    }
    
    NSLog(@"Expected Lines %d", expectedSegmentLineCount);
    int segmentTally = 1;
    
    NSMutableString* output = [NSMutableString string];
    for (ATRRouteSegment *segment in route.segments){
        
        for (int j = 0; j < [segment.lines count]; j++, segmentTally++){
            [output appendString:[NSString stringWithFormat:@"Segment Line %d/%d\nFloor ID: %d\nStart: x:%f - y:%f\nEnd :x:%f - y:%f\nDistance: %f\nTime (ms): %ld\n", segmentTally, expectedSegmentLineCount, [segment.lines objectAtIndex:j].floorId, segment.start.y, segment.start.x, segment.stop.y, segment.start.x, segment.travelMeters, segment.travelMs]];
        }
    }
    
    return output;
}

- (ATRRouteRequest*) getStaticRoute {
    ATRRouteRequest *route = [ATRRouteRequestBuilder makeWithBuilderBlock:^(ATRRouteRequestBuilder *builder)
                              {
                                  //Updated Method to set priority low for static route
                                  //[builder addStops:
                                   //[
                                    //NSArray arrayWithObjects:
                                    // This first point is in the builder start
                                    //[[ATRPoint alloc] initWithX:-84.442325 y:33.637687 floor:2],
                                    //[[ATRPoint alloc] initWithX:-84.442325 y:33.637687 floor:2],                                    // The end point is in the builder end.
                                    //nil
                                    //] withPriority:ATRRoute_LOW];
                                  
                                  // Setup the route
                                  //builder.start = [[ATRPoint alloc] initWithX:-84.442386 y:33.637312 floor:2];
                                  builder.start = [[ATRPoint alloc] initWithX:startX y:startY floor:2];
                                  builder.end = [[ATRPoint alloc] initWithX:endX y:endY floor:2];
                                  
                                  builder.preference = ATRRoute_WALKING;
                              }];
    return route;
}

- (ATRRouteRequest*) getRouteWithStops:(NSArray*) stops {
    if ([stops count] < 2) {
        return nil;
    }
    ATRRouteRequest *route = [ATRRouteRequestBuilder makeWithBuilderBlock:^(ATRRouteRequestBuilder *builder)
                              {
                                  NSRange stopRange = NSMakeRange(1, ([stops count]-2));
                                  NSArray *middleStops = [NSArray arrayWithArray:[stops subarrayWithRange:stopRange]];
                                  NSMutableArray *atrMiddleStops = [[NSMutableArray alloc] init];
                                  for(AGSPoint *stop in middleStops) {
                                      [atrMiddleStops addObject:[[ATRPoint alloc] initWithX:[stop x] y:[stop y] floor:2]];
                                  }
                                  if ([atrMiddleStops count] > 0) {
                                  //Updated Method to set priority low for static route
                                      [builder addStops:atrMiddleStops withPriority:ATRRoute_LOW];
                                  }
                                  
                                  // Setup the route
                                  //builder.start = [[ATRPoint alloc] initWithX:-84.442386 y:33.637312 floor:2];
                                  AGSPoint* start = [stops firstObject];
                                  builder.start = [[ATRPoint alloc] initWithX:[start x] y:[start y] floor:2];
                                  AGSPoint* end = [stops lastObject];
                                  builder.end = [[ATRPoint alloc] initWithX:[end x] y:[end y] floor:2];
                                  
                                  builder.preference = ATRRoute_WALKING;
                              }];
    return route;
}

@end


