//
//  RouteDataClass.h
//  atlantademo
//
//  Created by Melinda Frost on 11/10/17.
//  Copyright © 2017 gisi. All rights reserved.
//
@import AtriusCore;
@import AtriusRoute;
@import ArcGIS;

#ifndef RouteDataClass_h
#define RouteDataClass_h
@interface RouteDataClass: NSObject <ATRIRouteManagerDelegate>

@property (strong, nonatomic) NSArray<ATRRouteSegment *> *routeSegments;

- (void) requestRoute:(NSArray*) route;

- (void) requestRouteWithStop:(NSArray*) stop;
@end

#endif /* RouteDataClass_h */
