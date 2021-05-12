//
//  ATRIProjection.h
//  GeoMetriNavigatorSDK
//
//  Created by Christopher Bupp on 4/22/16.
//  Copyright © 2016 Acuity Brands. All rights reserved.
//

#import "ATRPoint.h"

@protocol ATRIProjection

- (ATRPoint * _Nullable) computePointFromX:(double)x y:(double)y;

- (ATRPoint * _Nullable) reverseGeoTransformFromX:(double)x y:(double)y;

@end
