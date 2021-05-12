//
//  ATRFloor.h
//
//  Copyright (c) 2014 Geographic Information Services, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 @brief The ATRFloor represents a floor.
 */
@interface ATRFloor : NSObject

/**
 The floor identifier.
 */
@property (readonly) int floorId;

/**
 The site identifier.
 */
@property (readonly) int siteId;

/**
 The building identifier.
 */
@property (readonly) int buildingId;

/**
 The name of the floor.
 */
@property (readonly, nullable) NSString *name;

/**
 The level of the floor. This can be thought of as the "elevator button label". It's a short, non-unique name. For instance, The ground level floor of building A could have a level of "1".
 */
@property (readonly, nullable) NSString *level;

/**
 The vertical order is used to sort the list of floors for presentation.
 */
@property (readonly) int verticalOrder;

/**
 The mapServiceUrl will contain a URL that associates a tile hosting URL (like mapbox or ArcGIS Online) to the floor for representing the map in world coordinates.
 */
@property (readonly, nullable) NSString *mapServiceUrl;

@property (readonly, nullable) NSString *mapServiceType;

@property (readonly, nullable) NSString *token;


- (nullable id) initWithFloorId:(int)floorId siteId:(int)siteId buildingId:(int)buildingId name:(NSString*_Nullable)name level:(NSString*_Nullable)level verticalOrder:(int)verticalOrder mapServiceUrl:(NSString*_Nullable)mapServiceUrl mapServiceType:(NSString*_Nullable)mapServiceType token:(NSString*_Nullable)token;

@end
