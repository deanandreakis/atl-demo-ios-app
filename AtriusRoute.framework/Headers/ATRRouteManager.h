//
//  ATRRouteManager.h
//  AtriusRoute
//
//  Created by Satya Mukkavilli on 3/29/17.
//  Copyright © 2017 Acuity Brands. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ATRRoute.h"
#import "ATRRouteRequest.h"

@protocol ATRIRouteManagerDelegate;

/**
 @brief The ATRRouteManager class represents a construct that manages the creation
 and optimization of routes.
 */
@interface ATRRouteManager : NSObject

- (nullable id) init __attribute__((unavailable("init not available. use static class methods")));
/**
 A class method that returns the instance of the ATR route manager.
 @returns The current ATRRouteManager object.
 */
+ (ATRRouteManager * _Nonnull)sharedInstance;

/**
 Load the site into the route manager.
 @param siteName The site name to be used in route generation.
 */
-(void)loadWithSite:(NSString * _Nonnull)siteName;

/**
 Generates a route when a priority is set given a valid priority route request and valid site.
 The route is generated asynchronously and returns through the onRouteGenerated
 call back. If route cannot be generated the route returned will be null and
 an error provided through the onRouteError call back.
 @param routeRequest The priority route request to be used in the route generation.
 */
-(void)generateRoute:(ATRRouteRequest * _Nonnull)routeRequest;

/**
 Adds an route manager interface delegate to the route manager.
 @param delegate The route manager delegate.
 */
-(void) addDelegate:(id <ATRIRouteManagerDelegate> _Nullable)delegate;

/**
 Removes an route manager interface delegate from the route manager.
 @param delegate The route manager delegate.
 */
-(void) removeDelegate:(id <ATRIRouteManagerDelegate> _Nullable)delegate;

@end

/**
 @brief The ATRIRouteManagerDelegate represents the methods need to receive communication from the Route manager.
 */
@protocol ATRIRouteManagerDelegate <NSObject>

/**
 Notifies the delegator when a route has been generated.
 @param route A route returned by the ATR Route Manager
 */
-(void)onRouteGenerated:(ATRRoute * _Nullable)route;

/**
 Notifies the delegator that a route error has occurred.
 @param error A error being returned to the ATR Route Manager.
 */
@optional
-(void)onRouteError:(NSError * _Nullable)error;

/**
 Notifies the delegator when a route config has been loaded.
 */
@optional
-(void)onRouteSiteLoaded;

@end
