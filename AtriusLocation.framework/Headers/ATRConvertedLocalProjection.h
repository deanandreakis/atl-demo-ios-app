//
//  ATRConvertedLocalProjection.h
//  GeoMetriNavigatorSDK
//
//  Created by Christopher Bupp on 4/22/16.
//  Copyright © 2016 Acuity Brands. All rights reserved.
//

@import AtriusCore;
#import "ATRICoordinateConversion.h"

@interface ATRConvertedLocalProjection : NSObject<ATRICoordinateConversion>

@property float mapOffsetX;
@property float mapOffsetY;
@property float mapAngleOffsetRadians;
@property NSUInteger coordinateConversion;
@property int floor;

- (nullable id) initWithMapOffsetX:(float)mapOffsetX mapOffsetY:(double)mapOffsetY mapAngleOffsetRadians:(float)mapAngleOffsetRadians coordinateConversion:(NSUInteger)coordinateConversion floor:(int)floor;

@end
