//
//  ATRLocation.h
//  AtriusLocation
//
//  Created by Christopher Bupp on 6/13/16.
//  Copyright © 2016 Christopher Bupp. All rights reserved.
//

@import AtriusCore;

#ifndef AtriusLocation_ATRLocation_h
#define AtriusLocation_ATRLocation_h

/**
 @brief The ATRLocation represents a location.
 */
@interface ATRLocation : NSObject

/**
	Types of position captures
 
 TYPE_ATR_VLC - the source is visual light communication (VLC)
 TYPE_ATR_BLE - the source is bluetooth low energy (BLE)
 
 Default value is unknown (TYPE_UNKNOWN)
 */
typedef enum {
    ATR_SOURCE_VLC = 1,   // VLC location capture
    ATR_SOURCE_BLE = 2,    // Bluetooth low engery location capture
    ATR_SOURCE_EST = 3     //Location estimation
} AtrLocationSrc;

/**
 The x portion of the coordinate.
 */
@property (nonatomic) double x;

/**
 The y portion of the coordinate.
 */
@property (nonatomic) double y;

/**
 The z portion of the coordinate, measured in meters from the floor.
 */
@property (nonatomic) NSNumber* _Nullable ceilingOffsetMeters;

/** 
    The accuracy of the position.
 */
@property float accuracy;

/**
    The source of the position.
 */
@property AtrLocationSrc source;

/**
    The time of the position.
 */
@property uint64_t timestamp;

/**
    The floor of the position.
 */
@property (nonatomic) ATRFloor* _Nullable floor;

/**
 Initializes and returns a location.
 @param x The x portion of a coordinate.
 @param y The y portion of a coordinate.
 @param ceilingOffsetMeters The cealing offset in meters.
 @param timestamp The timestamp of the coordinate.
 @param accuracy The accuracy of the location.
 @param source The source of the location (VLC/BLE/etc.).
 @param floor The floor associated with the coordinate.
 @returns An ATRLocation object based on the parameters provided.
 */
- (nullable id) initWithX:(double)x y:(double)y ceilingOffsetMeters:(NSNumber* _Nullable)ceilingOffsetMeters timestamp:(uint64_t)timestamp accuracy:(float)accuracy source:(AtrLocationSrc)source floor:(ATRFloor* _Nullable)floor;

/**
    Return the system timestamp of the function.
    @returns An unsigned system timestamp
 */
+(uint64_t)getSystemTimestamp;

@end

#endif

