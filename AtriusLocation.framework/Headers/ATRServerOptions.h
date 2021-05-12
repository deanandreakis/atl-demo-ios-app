//
//  ATRServerUpdateOptions.h
//  AtriusLocation
//
//  Created by Satya Mukkavilli on 10/31/16.
//  Copyright © 2016 Acuity Brands. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

/**
 @brief The ATROptions class provides capabilities to override the default values for position capture parameters
 
 */
@interface ATRServerOptions : NSObject

- (nullable id) init __attribute__((unavailable("init not available. Use ATRLocationOptionsBuilder class.")));

/**
 The value to be set to determine the milliseconds in between location captures
 */
@property (readonly) NSUInteger locationSampleMs;

/**
 The value to be set to determine the milliseconds in between transmitting the captured locations
 */
@property (readonly) NSUInteger transmitFrequencyMs;

/**
	The BOOL value indicating rather or not to use a cached copy the configuration data if available during network unavailability.  If no cached site name / floorspace configuration is available, an exception will be thrown.
 
 Default is NO
 */
@property (readonly) BOOL disableCache;

/**
	Initializes an ATROptions object with default values.
	@returns ATRServerUpdateOptions
 */

@end

@protocol ATRIServerOptionsBuilder <NSObject>

@property (setter=hiddenSetLocationSampleMs:) NSUInteger locationSampleMs;
@property (setter=hiddenSetTransmitFrequencyMs:) NSUInteger transmitFrequencyMs;
@property (setter=hiddenSetDisableCache:) BOOL disableCache;

@end

typedef void(^ATRServerOptionsBuilderBlock)(id<ATRIServerOptionsBuilder> _Nonnull);

@interface ATRServerOptionsBuilder : NSObject<ATRIServerOptionsBuilder>


-(ATRServerOptionsBuilder*_Nonnull)setLocationSampleMs:(NSUInteger)locationSampleMs;
-(ATRServerOptionsBuilder*_Nonnull)setDisableCache:(BOOL)disableCache;
-(ATRServerOptionsBuilder*_Nonnull)setTransmitFrequencyMs:(NSUInteger)transmitFrequencyMs;

/**
 Builds a Server Options Object.
 @returns ATRServerOptions The Server Options object that was created.
 */
- (ATRServerOptions* _Nullable) build;

/**
 Static method utilizing a ServerOptionsBuilderBlock to generate an ATRServerOptions object.
 @param block The Server Options Builder block.
 @returns instance The instance of ServerOptions class.
 */
+ (ATRServerOptions* _Nullable) makeWithBuilderBlock:(ATRServerOptionsBuilderBlock _Nonnull)block;

@end


