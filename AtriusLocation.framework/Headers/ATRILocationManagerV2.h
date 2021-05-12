//
//  ATRILocationManagerV2.h
//  AtriusLocation
//
//  Created by Grant Yi on 12/13/17.
//  Copyright © 2017 Acuity Brands. All rights reserved.
//

#ifndef ATRILocationManagerV2_h
#define ATRILocationManagerV2_h


#endif /* ATRILocationManagerV2_h */
//
//  ATRILocationManager.h
//  AtriusLocation
//
//  Created by Satya Mukkavilli on 10/10/16.
//  Copyright © 2016 Acuity Brands. All rights reserved.
//

@import AtriusCore;
#import <Foundation/Foundation.h>
#import "ATRLocationOptions.h"
#import "ATRServerOptions.h"
#import "ATRLocation.h"
#import "ATRAngle.h"

/**
 @brief The ATRILocationManager protocol represents the methods required by a ATR location manager.
 
 */
typedef enum {
    APP_REQUESTED = 1,
    FLOORSWITCH_VLC_TEMPORARY_DISABLE = 2
    //The other reasons are not consistent enough at the moment
    //iOS currently has a bug where the peripheral disable also triggers a central disable
    //The Beacon exit event does not satisfy all of our needs at the moment
    //HARDWARE_DISABLED = 3,
   // BEACON_REGION_EXITED = 4,
} AtrDisabledReason;
/**
 @brief The ATRILocationManagerV2Delegate protocol represents the methods used by the ATRLocationManagerV2 to communicate with the application.
 */
@protocol ATRILocationManagerV2Delegate;
/**
 @brief The ATRILocationManagerV2 protocol represents the methods required by the ATRLocationManagerV2.
 */
@protocol ATRILocationManagerV2 <NSObject>

/**
 Get the location options for a ATR location manager.
 @returns An ATRLocationOptions.
 */
-(ATRLocationOptions* _Nullable) getLocationOptions;

/**
 Get the server options for a ATR location manager.
 @returns An ATRLocationOptions.
 */
-(ATRServerOptions* _Nullable) getServerOptions;

/**
 Load the data related to the location manager.
 */
-(void)updateOptionsforLocation: (ATRLocationOptions* _Nullable)locOptions andServer:(ATRServerOptions* _Nullable)serverOptions; //options as param

/**
 Enables a location manager.
 @param siteName the site to load
 */
-(void) loadSite:(NSString* _Nonnull)siteName;

/**
 Attempts to auto load a site if present.
 @param proximityUuid The proximity ID.
 */
-(void) autoLoad:(NSString* _Nonnull)proximityUuid timeout:(long)milliseconds;

@required
/**
 Enables a location manager.
 @param siteName the site to load
 @param floorspaceName the floorspace to load
 */
-(void) loadSite:(NSString* _Nonnull)siteName andFloorspace:(NSString* _Nullable)floorspaceName;

/**
 Enables a location manager.
 */
-(void) enable;

/**
 Enable a specified source in the location manager.
 */
-(void) enable: (AtrLocationSrc) source;

/**
 Disable a location manager.
 */
-(void) disable;

/**
 Disable a location manager base on the source.
 */
-(void) disable: (AtrLocationSrc) source;

/**
 Terminates a location manager.
 */
-(void) terminate;

/**
 Adds a location manager interface delegate to the location manager.
 @param delegate The location manager delegate to the list of delegates.
 */
-(void) addDelegate:(id<ATRILocationManagerV2Delegate> _Nonnull)delegate;

/**
 Removes a location manager interface delegate from the location manager.
 */
-(void) removeDelegate:(id<ATRILocationManagerV2Delegate> _Nonnull)delegate;

@end

/**
 @brief The ATRILocationManagerDelegate represents the methods need to receive communication from location manager.
 */
@protocol ATRILocationManagerV2Delegate<NSObject>

@optional
/**
 Notifies the delegator the the location manager has been enabled.
 */
-(void) onEnabled:(AtrLocationSrc) source;

@optional
/**
 Notifies the delegator that the location manager has been disabled.
 */
-(void) onDisabled:(AtrLocationSrc) source withReason:(AtrDisabledReason) reason;
@optional
/**
 Notifies the delegator that the location manager has been disabled.
 */
-(void) onAutoLoadTimeout;


@required
/**
 Notifies the delegator that location the location manager has been updated.
 */
-(void) onLocationUpdate:(ATRLocation* _Nonnull)location;


@optional
/**
 Notifies the delegator that angle from the location manager has been updated.
 */
-(void) onAngleUpdate:(ATRAngle* _Nonnull) angle;

/**
 Notifies the delegator that the ATR site had been loaded.
 @param site The site loaded.
 @param floor The current floor.
 */
-(void) onSiteLoaded: (ATRSite* _Nonnull) site withFloor: (ATRFloor* _Nullable) floor;

/**
 Notifies the delegator that an error has occured within the location manager.
 @param error A error being returnd from the location manager.
 */
-(void) onError:(NSError* _Nonnull)error;

@optional
-(void) onLoadError:(NSError* _Nonnull)error;

@optional
/**
 Notifies the delegator that a floor change has occured.
 @param newFloor The current floor changed to.
 @param oldFloor The old floor changine from.
 */

-(void) onFloorChange:(ATRFloor* _Nonnull) newFloor withOldFloor:(ATRFloor* _Nonnull) oldFloor;



@end

