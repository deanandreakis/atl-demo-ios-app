//
//  ATRICoordinateConversion.h
//  AtriusLocation
//
//  Created by Christopher Bupp on 9/27/17.
//  Copyright © 2017 Acuity Brands. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ATRICoordinateConversion <NSObject>

- (ATRPoint *) computePointFromX:(double)x y:(double)y;

@end
