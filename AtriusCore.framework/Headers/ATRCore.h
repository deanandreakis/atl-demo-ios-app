//
//  ATRCore.h
//  AtriusCore
//
//  Created by Satya Mukkavilli on 10/6/16.
//  Copyright © 2016 Acuity Brands. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 @brief The ATRCore provides the representation of the ATR core API URL and device.
 */

enum ATR_ERRORS_AND_WARNINGS {
    //Errors
    atrError_LumicastFrameworkError = 1,
    atrError_BLEFrameworkError = 2,
    atrError_UnableToReadConfigurationDataFromCacheDuringNetworkUnavailability = 3,
    atrError_UnableToParseJSONFromInitialize = 4,
    atrError_NetworkError = 5,
    atrError_ConfigurationDataNotFound = 6,
    atrError_InvalidAPIKey = 7,
    atrError_authorizationError = 8,
    atrError_noBeaconsDetectedError = 9,
    //Warnings
    atrWarning_UnsupportedVLCDevice = 10000,
    atrWarning_UsingCachedConfigurationDataForSite = 10001,
    atrWarning_RequestedSiteToEnableConflictsWithCurrentlyDeterminedSite = 10002,
    atrWarning_CameraNotAvailable = 10003,
    atrWarning_LocationNotAvailable = 10004,
    atrWarning_SiteNotFound = 10005,
    atrWarning_UnknownSource = 10006,
    atrWarning_CorruptedConfiguration = 10007,
    atrWarning_InvalidProximityUUID = 10008
    
};

/**
 ATRProjected - the coordinate system is projected
 ATRInjected - the coordinate system is injected
 */
typedef enum {
    ATRProjected = 1,   // Projected cooordinate system capture (Local)
    ATRGeographic = 2    // Injected coordinate system capture (Geo)
} ATRCoordinateSystem;


@interface ATRCore : NSObject

- (nullable id) init __attribute__((unavailable("init not available. use static class methods")));

/**
 Configures with the API token, partner ID, and environment ID.
 @param token the API token provided or nil
 @param partnerId the API partner ID
 @param environmentId the API environment ID
 */
+(void)configureWithApiToken:(NSString*_Nonnull)token andPartnerId:(NSString*_Nonnull)partnerId andEnvironmentId:(NSString*_Nonnull)environmentId;

/**
 Returns the API URL.  If nil, value should be sent to server.
 @return NSString of the API URL.
 */
+(NSString *_Nonnull)getApiUrl;

/**
 Sets the API URL. Sets the API URL. This is only required when the default URL needs to be overwritten..
 @param url the URL of the API
 */
+(void)setApiUrl:(NSString*_Nonnull)url;

/**
 Returns the API token. If nil, value should be not be sent to server.
 @return NSString of the API token.
 */
+(NSString *_Nullable)getApiToken;

/**
 Returns the device ID. If nil, use the IDFA ID value.
 @return NSString the device ID.
 */
+(NSString *_Nullable)getDeviceId;

/**
 Sets the device ID.  If the device ID is not set, the device ID of the device the app is running on will be used. 
 @param device the device ID
 */
+(void)setDeviceId:(NSString*_Nonnull)device;

/**
 Return the partner ID.  If nil,
 @return the partner ID
 */
+(NSString*_Nullable)getPartnerId;

/**
 Returns the environment ID.
 @return environment ID
 */
+(NSString*_Nullable)getEnvironmentId;

/**
 Returns the request source.
 @return request source
 */
+(NSString*_Nullable)getRequestSource;

/**
 Returns the Coordinate Preference.
 @return the ATRCoordinateSystem preference.
 */
+(ATRCoordinateSystem) getCoordinatePreference;

/**
 Sets the Coordinate Preference.  If the Coordinate Preference is not set, Geographic coordinates will be used.
 @param preference the ATRCoordinateSystem to be used.
 */
+(void)setCoordinatePreference:(ATRCoordinateSystem)preference;

/**
 The version of the AtriusCore framework.
 @return a string that contains the version.
 */
+(const NSString*_Nonnull) version;

@end
