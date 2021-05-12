//
//  ATRAngle.h
//  AtriusLocation
//
//  Created by Scott Mappes on 3/17/15.
//  Copyright (c) 2015 Acuity Brands. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
	Types of Angle captures
 
 ATRAngleSourceVLC - the source is visual light communication (VLC)
 ATRAngleSourceCompass - the source is device compass
 */
typedef enum {
    ATRAngleSourceVLC = 1,   // VLC angle capture
    ATRAngleSourceCompass = 2    // Device compass angle capture
} AtrAngleSource;

/**
 @brief The ATRAngle class represents a device orientation angle.
 */
@interface ATRAngle : NSObject

/**
	Initializes and returns an AtrAngle object.
	@param angleInRadians Angle in radians. Expressed in meters.
	@param timestamp Exact time the orientation was determined in milliseconds using Epoch timestamp.
    @param angleSource Source of the angle
    @param angleAccuracy accuracy in degrees
	@returns AtrAngle based on the angle in radians and the timestamp.
 */
- (nullable id) initWithAngle:(float)angleInRadians timestamp:(uint64_t)timestamp source:(AtrAngleSource)angleSource accuracy:(float)angleAccuracy;

/**
	Angle value in radians. Expressed in meters.
 */
@property (readonly, getter=getAngleInRadians) float radians;


/**
	Angle value in degrees. Expressed in meters.
 */

@property (readonly, getter=getAngleInDegrees) float degrees;

/**
	Exact time the orientation was determined in milliseconds using Epoch Timestamp.
 */
@property (readonly) uint64_t timestamp;

/**
 The source of the Angle.
 */
@property AtrAngleSource angleSource;

/**
 The accuracy of the Angle. Expressed in degrees.
 */
@property float accuracy;

@end
