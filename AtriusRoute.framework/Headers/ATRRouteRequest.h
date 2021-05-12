//
//  ATRRouteRequest.h
//  AtriusRoute
//
//  Created by Satya Mukkavilli on 4/5/17.
//  Copyright © 2017 Acuity Brands. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ATRRoutePriority.h"
#import "ATRPreference.h"

@import AtriusCore;

/**
 @brief The ATRRouteRequest class is used to request an optimized route
 from a route manager.
 */
@interface ATRRouteRequest : NSObject

/**
 The preferences of the route.  This information is used by the route manager to 
 optimize the route.
 */
@property (readonly) ATRPreference preference;

/**
 This is the start of the route.
 If this is nil, no start is provided and the start of the route is not preserved.
 */
@property (readonly, nullable) ATRPoint *start;

/**
 This is the end of the route.
 If this is nil, no end is provided and the end of the route is not preserved.
 */
@property (readonly, nullable) ATRPoint *end;

/**
 The stops of the route request.
 */
@property (readonly, nullable) NSArray<NSArray<ATRPoint*>*> *stops;

/**
 Return an array of stops based upon the priority provided.
 @param priority the array of stops for a given priority.
 @returns The array of stops for the given priority. Nil if there is an error.
 */
- (NSArray<ATRPoint*>* _Nullable)getStopsWith:(ATRRoutePriority)priority;



- (nullable id) init __attribute__((unavailable("init not available. use static class methods")));

@end

@protocol ATRIRouteRequestBuilder <NSObject>
/**
 The preferences of the route.  This information is used by the route manager to
 optimize the route.
 */
@property (setter=hiddenSetPreference:) ATRPreference preference;

/**
 This is the start of the route.
 If this is nil, no start is provided and the start of the route is not preserved.
 */
@property (setter=hiddenStart:) ATRPoint * _Nullable start;

/**
 This is the end of the route.
 If this is nil, no end is provided and the end of the route is not preserved.
 */
@property (setter=hiddenEnd:) ATRPoint * _Nullable end;

/**
 The stops of the route request.
 */
@property (setter=hiddenStops:) NSArray<NSArray<ATRPoint*>*> * _Nullable stops;

@end

/**
 @brief A block that can be used to initialize a route request.
 */
typedef void(^RouteRequestBuilderBlock)(id<ATRIRouteRequestBuilder> _Nonnull);

/**
 @brief This class is used to build a priority route request.
 */
@interface ATRRouteRequestBuilder : NSObject<ATRIRouteRequestBuilder>

/**
 The preferences of the route.  This information is used by the route manager to
 optimize the route.
 */
- (ATRRouteRequestBuilder*_Nonnull) setPreference:(ATRPreference) preference;

/**
 This is the start of the route.
 If this is nil, no start is provided and the start of the route is not preserved.
 */
- (ATRRouteRequestBuilder*_Nonnull) setStart:(ATRPoint *_Nonnull) start;

/**
 This is the end of the route.
 If this is nil, no end is provided and the end of the route is not preserved.
 */
- (ATRRouteRequestBuilder*_Nonnull) setEnd:(ATRPoint *_Nonnull) end;

/**
 The stops of the route request.
 */
- (ATRRouteRequestBuilder*_Nonnull) setStops:(NSArray<NSArray<ATRPoint*>*>*_Nonnull) stops;


/**
 Adds a stop according to the priority.
 @param stop a point that is add according to its priority
 @param priority the priority of the point
 */
- (void)addStop:(ATRPoint* _Nonnull) stop withPriority:(ATRRoutePriority)priority;

/**
 Adds an array of stops with a given priority.
 @param stops an array of stops
 @param priority the preference of the stops
 */
- (void)addStops:(NSArray<ATRPoint*>* _Nonnull)stops withPriority:(ATRRoutePriority)priority;

/**
 Returns an ATR route request or nil.
 @returns a ATR route request.
 */
- (ATRRouteRequest* _Nullable)build;

/**
 Defines a route request based on the block provided.
 @param block the block used to define the route request.
 @returns an instance of the route request.
 */
+ (ATRRouteRequest * _Nullable) makeWithBuilderBlock: (RouteRequestBuilderBlock _Nonnull )block;

@end
