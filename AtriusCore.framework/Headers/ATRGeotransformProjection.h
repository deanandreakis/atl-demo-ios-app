//
//  ATRGeotransformProjection.h
//  GeoMetriNavigatorSDK
//
//  Created by Christopher Bupp on 4/22/16.
//  Copyright © 2016 Acuity Brands. All rights reserved.
//

#import "ATRIProjection.h"

@interface ATRGeotransformProjection : NSObject<ATRIProjection>

@property double yRotation;
@property double xRotation;
@property double width;
@property double x;
@property double y;
@property double height;
@property int floor;

- (nullable id) initWithX:(double)x y:(double)y xRotation:(double)xRotation yRotation:(double)yRotation width:(double)width height:(double)height floor:(int)floor;

@end
