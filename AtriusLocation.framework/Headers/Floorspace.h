//
//  Floorspace.h
//  AtriusLocation
//
//  Created by Stan Hughes on 2/8/17.
//  Copyright © 2017 Acuity Brands. All rights reserved.
//

@import AtriusCore;
#import <Foundation/Foundation.h>
#import "ATRConvertedLocalProjection.h"

/*
    @brief This class define a floorspace.
*/
@interface Floorspace : NSObject

/*
 The floorspace ID
 */
@property (nonatomic) int floorspaceId;

/*
 The floor ID
 */
@property (nonatomic) int floorId;

/*
 The floorspace name
 */
@property (nonatomic) NSString *name;

@property BOOL hasBeacons;

@property id<ATRIProjection> geotransformProjection;
@property id<ATRICoordinateConversion> convertedProjection;
@property float geotransformHeadingOffsetRadians;
@property float convertedHeadingOffsetRadians;

- (id) initWithName:(NSString *) name andId: (int) floorspaceId andFloorId:(int) floorId andConvertedProjection:(id<ATRICoordinateConversion>)convertedProjection andConvertedHeadingOffsetRadians:(float)convertedHeadingOffsetRadians andGeotransformProjection:(id<ATRIProjection>)geotransformProjection andGeotransformHeadingOffsetRadians:(float)geotransformHeadingOffsetRadians andHasBeacons:(BOOL)hasBeacons;


@end
