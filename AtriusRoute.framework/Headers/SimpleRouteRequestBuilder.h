//
//  SimpleRouteRequestBuilder.h
//  AtriusRoute
//
//  Created by Satya Mukkavilli on 3/29/17.
//  Copyright © 2017 Acuity Brands. All rights reserved.
//

@import AtriusCore;
#import <Foundation/Foundation.h>
#import "ATRPreference.h"

@class SimpleRouteRequest;

/**
 @brief This class is used to build an route request.
 */
@interface SimpleRouteRequestBuilder : NSObject

/**
 The preference to be used in defining the route request.
 */
@property ATRPreference preference;

/**
 Specifies if the order of the stops will be optimized in the route request.
 */
@property BOOL stopOrderOptimized;

/**
 Specifies the start of a route.
 */
@property ATRPoint *start;

/**
 Specifies the end of a priority route.
 */
@property ATRPoint *end;

/**
 Specifies the set of stops for the request.
 */
@property NSArray<ATRPoint*> *stops;

/**
 Adds a stop to the end of the current stops.
 @param stop a point that is add to the list of stops
 */
- (void)addStop:(ATRPoint*)stop;

/**
 Add stops to the end of the current stops.
 @param stops and array of stops
 */
- (void)addStops:(NSArray<ATRPoint*>*)stops;

/**
 This methods instructs the builder to construct a route request.
 @returns an route request according to the state of the builder.
 */
- (SimpleRouteRequest *)build;

@end
