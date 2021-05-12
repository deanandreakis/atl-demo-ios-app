//
//  ATRRouteLine.h
//  AtriusRoute
//
//  Created by Satya Mukkavilli on 4/5/17.
//  Copyright © 2017 Acuity Brands. All rights reserved.
//

#import <Foundation/Foundation.h>
@import AtriusCore;

/**
 @brief The class which defines a route line used in the route segment.
 */
@interface ATRRouteLine : NSObject

/**
 The array of coordinates that define a route line.
 */
@property (readonly, nonnull) NSArray<ATRCoordinate *> *coordinates;

/**
 The floor ID associated with the route line.
 */
@property (readonly) int floorId;

/**
 Initializes the route line.
 @param coordinates the coordinates of the route line
 @param floorId the floor ID of the route line
 @return an initalized route line
 */
- (nullable id) initWith:(NSArray<ATRCoordinate*>*_Nonnull) coordinates andWith:(int) floorId;

@end
