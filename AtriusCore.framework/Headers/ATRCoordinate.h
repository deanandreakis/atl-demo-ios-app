//
//  ATRCoordinate.h
//  ATRNavigatorCore
//
//  Created by Christopher Bupp on 5/11/16.
//  Copyright © 2016 Christopher Bupp. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ATRPoint.h"

@interface ATRCoordinate : NSObject

/**
 The x portion of the coordinate.
 */
@property (nonatomic) double x;

/**
 The y portion of the coordinate.
 */
@property (nonatomic) double y;

- (nullable id) initWithX:(double)x y:(double)y;

@end
