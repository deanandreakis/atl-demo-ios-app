//
//  ATRKalmanSmoothingStrategy.h
//  AtriusLocation
//
//  Created by Aaron Tharpe on 5/18/17.
//  Copyright © 2017 Acuity Brands. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ATRISmoothingStrategy.h"

@interface ATRKalmanSmoothingStrategy : NSObject<ATRISmoothingStrategy>

/**
 Process noise covariance
 */
@property (nonatomic) CGFloat processNoiseCovariance;

/**
 Measurement noise covariance
 */
@property (nonatomic) CGFloat measurementNoiseCovariance;

/**
 The initial estimation error covariance
 */
@property (nonatomic) ATRCoordinate* _Nullable initialEstimationErrorCovariance;



/**
 Returns a new smoothing strategy instance with default values
 Default:
    processNoiseCovariance = 0.625;
    measurementNoiseCovariance = 15.0;
    initialEstimationErrorCovariance = [[ATRCoordinate alloc] initWithX:10000 y:10000];
 */
- (nullable id) init;

/**
 Initializes the filter object with custom variables
 @param processNoiseCovariance -  Process noise covariance
 @param measurementNoiseCovariance -   Measurement noise covariance
 @param initialEstimationErrorCovariance -  The initial estimation error covariance
 */
- (nullable id) initWithProcessNoiseCovariance:(CGFloat)processNoiseCovariance andMeasurementCovariance:(CGFloat)measurementNoiseCovariance andInitialEstimationErrorCovariance:(ATRCoordinate* _Nullable)initialEstimationErrorCovariance;

@end
