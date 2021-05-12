//
//  ATRRouteSegment.h
//  AtriusRoute
//
//  Created by Satya Mukkavilli on 4/5/17.
//  Copyright © 2017 Acuity Brands. All rights reserved.
//

@import AtriusCore;
#import <Foundation/Foundation.h>
#import "ATRRouteLine.h"

/**
 @brief The class define a route segement.  Route segments define the path of a route in segments.
 */
@interface ATRRouteSegment : NSObject

/**
 A set of route lines that define the segments.
 */
@property (readonly, nonnull) NSArray<ATRRouteLine*> *lines;

/**
 A point which define the start of the segment.
 */
@property (readonly, nonnull) ATRPoint *start;

/**
 A point which defines the last stop point of a route segment
 */
@property (readonly, nonnull) ATRPoint* stop;

/**
 Milliseconds taken to travel a route segment
 */
@property (readonly) long travelMs;

/**
 Distance in meters for a route segment
 */
@property (readonly) double travelMeters;

/**
 Initializes the ATR route segment.
 @param start the start of the segment
 @param stop the stop or end of the segment
 @param lines an array of ATR route lines for the segment
 @param travelMs the milliseconds taken to travel a segment
 @param travelMeters the distance in meters for a route segment
 @returns a route segment defined by the parameters
 */
- (nullable id) initWith:(ATRPoint* _Nonnull)start withStop:(ATRPoint* _Nonnull)stop withLines:(NSArray<ATRRouteLine*>* _Nonnull)lines withTravelMs:(long)travelMs withTravelMeters:(double)travelMeters;

@end
