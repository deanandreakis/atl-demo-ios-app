//
//  ATRLocationOptions.h
//  AtriusLocation
//
//  Created by Satya Mukkavilli on 10/10/16.
//  Copyright © 2016 Acuity Brands. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import "ATRISmoothingStrategy.h"
#import "ATRILocationEstimator.h"



/**
 @brief The AblOptions class provides capabilities to override the default values for position capture parameters
 
 */
@interface ATRLocationOptions : NSObject

- (nullable id) init __attribute__((unavailable("init not available. Use ATRLocationOptionsBuilder class.")));

/**
	The desired CLAuthorizationStatus value indicating how the user will be prompted for location use within an application.
 
 Valid values are:
 kCLAuthorizationStatusAuthorizedWhenInUse,
 kCLAuthorizationStatusAuthorizedAlways,
 kCLAuthorizationStatusDenied
 
 Default is kCLAuthorizationStatusAuthorizedAlways
 
 
 If the user when prompted selects Denied and enableBlePositioning is called an error will be raised to onAtrError.
 
 If the user when prompted selects WhenInUse and enableBlePositioning is called positions will be collected while the application is the foreground.  Positions will not be collected when the app moves into background.  Auto application launch is also disabled.
 
 If the user when prompted selects Always and the framework is intialized, the auto initialization is enabled meaning that when a users enters into a beacon region, the framework will automatically make a server call to obtain configuration data and once loaded will call onAtrSiteInitialized with the siteName and floorspace name loaded.  The calling app should then call enableBlePositioning.  If the application moves into background positions will continue to be collected.  If the user
 moves to a new site onAtrSiteInitialized will be called.  If the user terminates the application prior to terminate being called then the application will be relaunched upon beacon region entry and onAtrSiteInitialized will be called.
 
 */
@property (readonly) CLAuthorizationStatus desiredLocationAuthorizationStatus;

/**
	The number of milliseconds required to elapse during a VLC position outage before changing to use BLE positions.
 
 Default:    2000
 Min:        2000
 Max:        60000
 */
@property (readonly) NSUInteger fallbackMs;

/**
	This simulation data represents VLC positions to be returned by the VLC positioning library in place of real locations. This is useful for situations where the developer is not at a commissioned site. It's important to realize that the simulation data for this version needs to be in the lights map coordinate system. In other words, the positions are with respect to the lights location in meters.
 
 Default:    null
 
 Example JSON:
 
 \code{.json}
 {
 "positions": [
 {"x": 1.00, "y": 1.00, "angle": 270.00, "duration":   10 },
 {"x": 4.00, "y": 1.00, "angle": 180.00, "duration": 2000 },
 {"x": 4.00, "y": 4.00, "angle":  90.00, "duration": 2000 },
 {"outage": 1, "angle":  45.00, "duration": 2000 },
 {"x": 1.00, "y": 4.00, "angle":   1.00, "duration": 2000 },
 {"x": 1.00, "y": 1.00, "angle": 270.00, "duration": 2000 }
 ]
 }
 \endcode
 */

/**
	The desired smoothing strategy to be used when returning BLE positions
 
 See ATRISmoothingStrategy interface for more details
 
 Example Objective-C:
 \code{.objc}
 //default options
 ATRKalmanSmoothingStrategy *kalmanFilter = [ATRKalmanSmoothingStrategy new];
 
 //custom options
 ATRKalmanSmoothingStrategy *kalmanFilter = [[ATRKalmanSmoothingStrategy alloc] initWithProcessNoiseCovariance:0.2 andMeasurementCovariance:13 andInitialEstimationErrorCovariance:[[ATRCoordinate alloc] initWithX:1 y:1]];
 
 builder.bleSmoothingStrategy = (ATRISmoothingStrategy*)kalmanFilter;
 \endcode
 */
@property (readonly) id<ATRISmoothingStrategy> _Nullable bleSmoothingStrategy;

/**
	The BOOL value that if set to YES will enable the use of compass angle when receiving BLE positions
 
 Default:   NO
 */

@property BOOL useCompassWithBLE;
//@property (readonly) id<ATRILocationEstimator> _Nullable locationEstimator;

@end

@protocol ATRILocationOptionsBuilder <NSObject>

@property (setter=hiddenSetDesiredLocationAuthorizationStatus:) CLAuthorizationStatus desiredLocationAuthorizationStatus;
@property (setter=hiddenSetFallbackMs:) NSUInteger fallbackMs;
@property (setter=hiddenSetBleSmoothingStrategy:) id<ATRISmoothingStrategy> _Nullable bleSmoothingStrategy;
@property (setter=hiddenSetUseCompassWithBLE:) BOOL useCompassWithBLE;
//@property (setter=hiddenSetLocationEstimator:) id<ATRILocationEstimator> _Nullable locationEstimator;

@end

typedef void(^ATRLocationOptionsBuilderBlock)(id<ATRILocationOptionsBuilder> _Nonnull);

@interface ATRLocationOptionsBuilder : NSObject<ATRILocationOptionsBuilder>

-(ATRLocationOptionsBuilder* _Nonnull)setDesiredLocationAuthorizationStatus:(CLAuthorizationStatus)desiredLocationAuthorizationStatus;
-(ATRLocationOptionsBuilder* _Nonnull)setFallbackMs:(NSUInteger)fallbackMs;
-(ATRLocationOptionsBuilder* _Nonnull)setBleSmoothingStrategy:(id<ATRISmoothingStrategy> _Nonnull)bleSmoothingStrategy;
//-(ATRLocationOptionsBuilder* _Nonnull)setLocationEstimator:(id<ATRILocationEstimator> _Nonnull)locationEstimator;

-(ATRLocationOptionsBuilder* _Nonnull)setUseCompassWithBLE:(BOOL)useCompassWithBLE;

/**
 Builds a Location Options Object.
 @returns ATRLocationOptions The Location Options object that was created.
 */
- (ATRLocationOptions* _Nullable) build;

/**
 Static method utilizing a LocationOptionsBuilderBlock to generate an ATRLocationOptions object.
 @param block The Location Options Builder block.
 @returns instance The instance of LocationOptions class.
 */
+ (ATRLocationOptions* _Nullable) makeWithBuilderBlock:(ATRLocationOptionsBuilderBlock _Nonnull )block;


@end
