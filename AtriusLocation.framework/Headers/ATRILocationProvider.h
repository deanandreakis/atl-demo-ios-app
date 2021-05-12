//
//  ATRILocationProvider.h
//  AtriusLocation
//
//  Created by Christopher Bupp on 2/11/17.
//  Copyright © 2017 Acuity Brands. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ATRLocationOptions.h"
#import "Floorspace.h"
#import "ATRLocation.h"
#import "ATRAngle.h"

/**
 @brief The ATRILocationprovider protocol represents the methods required by a ATR location provider.
 
 */

@protocol ATRILocationManagerDelegate;
@protocol ATRILocationProviderDelegate;

@protocol ATRILocationProvider <NSObject>

/**
 Enables a location provider.
 */
-(void) enable;

/**
 Disable a location provider.
 */
-(void) disable;

/**
 Terminates a location provider.
 */
-(void) terminate;

/**
 Adds a location provider interface delegate to the location provider.
 @param delegate The location provider delegate to the list of delegates.
 */
-(void) addDelegate:(id<ATRILocationProviderDelegate> _Nonnull)delegate;

/**
 Removes a location provider interface delegate from the location provider.
 */
-(void) removeDelegate:(id<ATRILocationProviderDelegate> _Nonnull)delegate;

@end

/**
 @brief The ATRILocationproviderDelegate represents the methods need to receive communication from location provider.
 */
@protocol ATRILocationProviderDelegate<NSObject>

@optional
/**
 Notifies the delegator the the location provider has been enabled.
 */
-(void) onEnabled:(AtrLocationSrc) source;

@required
/**
 Notifies the delegator that location the location provider has been updated.
 */
-(void) onLocationUpdate:(ATRLocation* _Nullable)location andAngle:(ATRAngle* _Nullable) angle andFloorspace:(Floorspace* _Nullable)floorspace;

/**
 Notifies the delegator that an error has occured within the location providor.
 @param error A error being returnd from the location provider.
 */
-(void) onError:(NSError* _Nullable)error;

@optional
/**
 Notifies the delegator that a site exit has occured in the location providor.
 @param site The site exited.
 */
-(void) onSiteExit:(ATRSite* _Nullable) site;

@end

