//
//  ATRIGeoLocationManager.h
//  AtriusLocation
//
//  Created by Satya Mukkavilli on 2/15/17.
//  Copyright © 2017 Acuity Brands. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 @brief The ATRIGeoLocationManager protocol represents the methods required by a ATR location manager.
 
 */

@protocol ATRIGeoLocationManagerDelegate;

@protocol ATRIGeoLocationManager <NSObject>

/**
 Adds a Geo location manager interface delegate to the location manager.
 @param delegate The Geo location manager delegate to the list of delegates.
 */
-(void) addGeoDelegate:(id<ATRIGeoLocationManagerDelegate> _Nullable)delegate;

/**
 Removes a Geo location manager interface delegate to the location manager.
 @param delegate The Geo location manager delegate to the list of delegates.
 */
-(void) removeGeoDelegate:(id <ATRIGeoLocationManagerDelegate> _Nullable)delegate;

@end

@protocol ATRIGeoLocationManagerDelegate <NSObject>

@optional

/**
 Notifies the delegator that Geo location from the location manager has been updated.
 */
-(void) onGeoLocationUpdate:(ATRLocation* _Nullable)geoLocation;

/**
 Notifies the delegator that Geo angle from the location manager has been updated.
 */
-(void) onGeoAngleUpdate:(ATRAngle* _Nullable)geoAngle;

@end;
