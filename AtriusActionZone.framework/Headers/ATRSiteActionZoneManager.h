//
//  ATRSiteActionZoneManager.h
//  AtriusActionZone
//
//  Created by Satya Mukkavilli on 1/5/17.
//  Copyright © 2017 Acuity Brands. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ATRIActionZoneManager.h"

enum AZ_ERRORS_AND_WARNINGS {
    //Errors
    azError_NetworkError = 1,
    azError_InvalidAPIKey = 2,
    azError_UnableToReadConfigurationDataFromCacheDuringNetworkUnavailability = 3,
    azError_UnableToParseJSONFromInitialize =  4
};

// Forward declaration
@protocol ATRISiteActionZoneManagerDelegate;

/**
 @brief This class defines the site action zone manager class.
 */
@interface ATRSiteActionZoneManager : NSObject <ATRIActionZoneManager>

- (nullable id) init __attribute__((unavailable("init not available. use static class methods")));

/**
 The property that permits the site action zone manager delegate to be set.
 */
@property (nullable, nonatomic, getter=getDelegate, setter=setDelegate:) id <ATRISiteActionZoneManagerDelegate> delegate;

/**
 A class method that returns the instance of the ATR Site ActionZone Manager.
 @returns The current ATRSiteActionZoneManager object.
 */
+(ATRSiteActionZoneManager* _Nonnull) sharedInstance;


/**
 Loads a location manager.
 @param siteName the site to load
 */
-(void)loadSite:(NSString* _Nullable)siteName;

/**
 Method to be invoked to enable the action zone manager
 */
-(void)enable;

/**
 Method to be invoked to disable the action zone manager
 */
-(void)disable;

/**
 Returns an array of action zones for the site
 */
-(NSArray *_Nullable) listZones;

@end

/**
 @brief The ATRISiteActionZoneManagerDelegate represents the methods need to receive communication from ATR Site ActionZone Manager.
 */
@protocol ATRISiteActionZoneManagerDelegate <NSObject>

/**
 Notifies the delegator the the ATR Site ActionZone Manager has been enabled.
 */
-(void)onLoad;

/**
 Notifies the delegator that an error has occured within the ATR Site ActionZone Manager.
 @param error A error being returnd from the ATR Site ActionZone Manager.
 */
-(void)onError:(NSError* _Nonnull)error;

@end
