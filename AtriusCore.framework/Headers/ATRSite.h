//
//  ATRSite.h
//  AtriusCore
//
//  Created by Stan Hughes on 2/7/17.
//  Copyright © 2017 Acuity Brands. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ATRBuilding.h"
#import "ATRFloor.h"
#import "ATRCoordinate.h"

/**
    @brief The ATRSite class defines a site and the method(s) addociated with it.
 */
@interface ATRSite : NSObject

/**
 The site ID of the site.
 */
@property (readonly) int siteId;

/**
 The site name of the site.
 */
@property (readonly, nonnull) NSString *name;

/**
 The NorthEast Corner Coordinate Extent
 */
@property (readonly, nullable) ATRCoordinate *neCornerCoordinate;

/**
 The SouthWest Corner Coordinate Extent
 */
@property (readonly, nullable) ATRCoordinate *swCornerCoordinate;

/**
 The floors of the site.
 */
@property (readonly, nullable) NSArray<ATRFloor*>*floors;

/**
 The buildings of the site.
 */
@property (readonly, nullable) NSArray<ATRBuilding*>* buildings;


@property (readonly, nullable) NSDictionary* configData;

/**
 Initialize a site with site ID, name, floors, building.
 @param siteId The site ID
 @param name The site name
 @param neCoordinate The NorthEast Coordinate Extent of the site
 @param swCoordinate The SouthWest Coordinate Extent of the site
 @param floors The floors of the site
 @param buildings The building of the site.
 */
- (nullable id) initWithSiteId:(int) siteId withName: (NSString *_Nullable) name withNECoordinate: (ATRCoordinate *_Nullable) neCoordinate withSWCoordinate: (ATRCoordinate *_Nullable) swCoordinate withFloors: (NSArray<ATRFloor*>*_Nullable) floors withBuildings:(NSArray<ATRBuilding*>*_Nullable) buildings andWithConfigData:(NSDictionary* _Nullable) configData;

@end
