//
//  ATRLocationManagerV2.h
//  AtriusLocation
//
//  Created by Grant Yi on 12/13/17.
//  Copyright © 2017 Acuity Brands. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "ATRILocationManagerV2.h"
#import "ATRIGeoLocationManager.h"
#import "ATRSimulation.h"


/**
 @brief The ATRLocationManager represents a class for managing a stream of points and the state related to them.
 
 */
@interface ATRLocationManagerV2 : NSObject <ATRILocationManagerV2, ATRIGeoLocationManager>

- (nullable id) init __attribute__((unavailable("The 'init' method is not available. Use the static class method instead.")));

/**
 A class method that returns the instance of the ATR location manager.
 @returns The current ATRLocationManager object.
 */
+(ATRLocationManagerV2* _Nonnull) sharedInstance;

/**
 Loads the simulation data for the site
 @param simulation the simulation instance to run
 */
-(void) loadSimulation:(ATRSimulation* _Nonnull)simulation;
-(void) injectLocation:(ATRLocation* _Nonnull)location;
@end

