//
//  ATRFloorCoordinate.h
//  ATRNavigatorCore
//
//  Created by Christopher Bupp on 5/11/16.
//  Copyright © 2016 Christopher Bupp. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 @brief The ATRPoint class defines a point and the method associated with it.
 */
@interface ATRPoint : NSObject

/**
The x portion of the coordinate.
*/
@property (nonatomic) double x;

/**
 The y portion of the coordinate.
 */
@property (nonatomic) double y;
/**
 A given floorspace within a site.
 */
@property (nonatomic) int floor;

/**
    Initializes a point with a given x, y, floor, accuracy and source.
    @param x The x portion of the coordinate.
    @param y The y portion of the coordinate.
    @param floor The floor related to the coordinate.
    @returns ATRPoint A point object based on the parameters provided.
 */
- (nullable id) initWithX:(double)x y:(double)y floor:(int)floor;

@end
