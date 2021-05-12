//
//  SimpleRouteRequest.h
//  AtriusRoute
//
//  Created by Satya Mukkavilli on 4/5/17.
//  Copyright © 2017 Acuity Brands. All rights reserved.
//

@import AtriusCore;
#import "ATRPreference.h"
#import "SimpleRouteRequestBuilder.h"

@interface SimpleRouteRequest : NSObject

typedef void(^SimpleRouteRequestBuilderBlock)(SimpleRouteRequestBuilder* _Nonnull);

@property ATRPreference preference;

@property BOOL stopOrderOptimized;

@property (readonly) ATRPoint * _Nullable start;

@property (readonly) ATRPoint * _Nullable end;

@property (readonly) NSArray<ATRPoint*> * _Nullable stops;

+ (instancetype _Nonnull )routeRequestWithBlock:(SimpleRouteRequestBuilderBlock _Nonnull )block;

- (id _Nonnull )initWithBuilder:(SimpleRouteRequestBuilder*_Nonnull)builder;

@end
