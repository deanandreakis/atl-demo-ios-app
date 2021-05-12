//
//  ATRLocationManager.h
//  AtriusLocation
//
//  Created by Satya Mukkavilli on 10/10/16.
//  Copyright © 2016 Acuity Brands. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "ATRILocationManager.h"
#import "ATRIGeoLocationManager.h"
#import "ATRSimulation.h"
//#import "ATRDeadReckoningEstimator.h"
/**
   @brief The ATRLocationManager represents a class for managing a stream of points and the state related to them.
 
   @deprecated This class will go away in future versions AtriusLocation.framework.
   @see ATRLocationManagerV2
 */
NS_CLASS_DEPRECATED_IOS(3.0, 5.0, "This has been replaced by the ATRLocationManagerV2")
@interface ATRLocationManager : NSObject <ATRILocationManager, ATRIGeoLocationManager>

- (nullable id) init __attribute__((unavailable("The 'init' method is not available. Use the static class method instead.")));

/**
    A class method that returns the instance of the ATR location manager.
    @returns The current ATRLocationManager object.
 */
+(ATRLocationManager* _Nonnull) sharedInstance;

/**
 Loads the simulation data for the site
 @param simulation the simulation instance to run
 */
-(void) loadSimulation:(ATRSimulation* _Nonnull)simulation;
-(void) injectLocation:(ATRLocation* _Nonnull)location;
@end 
