//
//  ATRBuilding.h
//  AtriusCore
//
//  Created by Stan Hughes on 2/7/17.
//  Copyright © 2017 Acuity Brands. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 @brief The ATRBuilding class define a building.
 */
@interface ATRBuilding : NSObject

/**
 The ID of the building.
 */
@property (readonly) int buildingId;

/**
 The ID of the site associated with the building.
 */
@property (readonly) int siteId;

/**
 The name of the building.
 */
@property (readonly, nullable) NSString *name;

- (nullable id) initWithBuildingId:(int) buildingId withName: (NSString *_Nullable) name withSiteId: (int) siteId;


@end
