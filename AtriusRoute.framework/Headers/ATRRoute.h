//
//  ATRRoute.h
//  AtriusRoute
//
//  Created by Satya Mukkavilli on 3/29/17.
//  Copyright © 2017 Acuity Brands. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SimpleRouteRequest.h"
#import "ATRRouteRequest.h"
#import "ATRRouteSegment.h"



/**
 @brief A class the defines a route.
 
 The following code snippet gives an example of how to build and setup a route.
 
 @code {.cpp}
 ATRRouteRequest *routeRequest = [ATRRouteRequest routeRequestWithBlock:^(ATRRouteRequestBuilder *builder)
 {
 
 builder.stops =
 [
 NSArray arrayWithObjects:
 [[ATRPoint alloc] initWithX:-84.04237296491853 y:33.68021986182641 floor:0],
 [[ATRPoint alloc] initWithX:-84.04227110213574 y:33.68023413575345 floor:0],
 [[ATRPoint alloc] initWithX:-84.04234997960756 y:33.68023348017049 floor:0],
 [[ATRPoint alloc] initWithX:-84.04237794595898 y:33.68018996724327 floor:0],
 [[ATRPoint alloc] initWithX:-84.04228833541613 y:33.68019078728302 floor:0],
 [[ATRPoint alloc] initWithX:-84.04231127928682 y:33.68021242003309 floor:0],
 [[ATRPoint alloc] initWithX:-84.04093086719513 y:33.67986187914394 floor:10],
 nil
 ];
 
 // Setup the route
 TODO: Remove optimizations and add in priority.
 builder.stopOrderOptimized = TRUE;
 builder.preference = ATRRoute_WALKING;
 }];
 
 
 routeMgr = [ATRRouteManager sharedInstance];
 
 [routeMgr addDelegate:self];

 TODO: Change the sitename
 [routeMgr loadWithSite:@"BLS - ABS9"];
 
 @endcode
 
 When the load is complete the following delegate method will be called.
 
 @code {.cpp}
 -(void)onRouteSiteLoaded {
 [self generateRouteForRequest:routeRequest];
 } @endcode
 
 When the generate route is complete the following delegate method will be called.
 
 @code {.cpp}
 -(void)onRouteGenerated:(ATRRoute *)route {
 }
 @endcode
 */
@interface ATRRoute : NSObject

/**
 The segments of the route.
 */
@property (readonly, nonnull) NSArray<ATRRouteSegment*> * segments;

/**
 The list of points that define the stops of the route.
 */
@property (readonly, nonnull) NSArray<ATRPoint*> * orderedStops;

/**
 Milliseconds taken to travel a route
 */
@property (readonly) long totalTravelMs;

/**
 Distance in meters for a route
 */
@property (readonly) double totalTravelMeters;

/**
 Initialized the ATRRoute
 @param segments one or more of the segments of the route.
 @param orderedStops two or more ordered stops that the define the course of the route.
 @return the initialized route.
 */
- (nullable id) initWith:(NSArray<ATRRouteSegment*>*_Nonnull) segments andWith:(NSArray<ATRPoint*>*_Nonnull) orderedStops;

@end
