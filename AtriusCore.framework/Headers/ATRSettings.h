//
//  ATRSettings.h
//  AtriusCore
//
//  Created by Scott Mappes on 3/25/15.
//  Copyright (c) 2015 Acuity Brands. All rights reserved.
//

#ifndef AtriusCore_AtrSettings_h
#define AtriusCore_AtrSettings_h

static const NSString *kAtrCachePrefix = @"ATR.AtriusCore";


static NSString *const kAtrOptionKey_disableCache = @"disableCache";
static NSString *const kAtrOptionKey_DesiredLocationAuthorizationStatus = @"DesiredLocationAuthorizationStatus";
static NSString *const kAtrOptionKey_fallbackMS = @"fallbackMS";
static NSString *const kAtrOptionKey_SignificantXChange = @"SignificantVlcXChange";
static NSString *const kAtrOptionKey_SignificantYChange = @"SignificantVlcYChange";
static NSString *const kAtrOptionKey_SignificantVlcAngleChange = @"SignificantVlcAngleChange";
static NSString *const kAtrOptionKey_UseCompassWithBLE = @"UseCompassWithBLE";
static NSString *const kAtrOptionKey_SiteAutoDetect = @"siteAutoDetect";
static NSString *const kAtrOptionKey_atrMaxCaptureFrequencyMS = @"atrMaxCaptureFrequencyMS";
static NSString *const kAtrOptionKey_locationSampleMs = @"transmitFrequencyMS";
static NSString *const kAtrOptionKey_locationCaptureMS = @"locationSampleMs";
static NSString *const kAtrOptionKey_angleCaptureMS = @"angleCaptureMS";
static NSString *const kAtrOptionKey_mergeAngleIntoLocation = @"mergeAngleIntoLocation";

//Private
static NSString *const kAtrOptionKey_VLCIDOnly = @"VLCIDOnly";
static NSString *const kAtrOptionKey_AlwaysTransmitBLELocationCaptureWhenAvailable = @"AlwaysTransmitBLELocationCaptureWhenAvailable";
static NSString *const kAtrOptionKey_NumberOfBeaconsRequiredForFloorspaceChange = @"NumberOfBeaconsRequiredForFloorspaceChange";
static NSString *const kAtrOptionKey_HttpEventHubPostTimeoutSeconds = @"HttpEventHubPostTimeoutSeconds";
static NSString *const kAtrOptionKey_HttpInitializePostTimeoutSeconds = @"HttpInitializePostTimeoutSeconds";
static NSString *const kAtrOptionKey_SkipBlueToothFloorspaceEntry = @"SkipBlueToothFloorspaceEntry";
static NSString *const kAtrOptionKey_VlcFloorspaceChangeFrequencyCheckSeconds = @"VlcFloorspaceChangeFrequencyCheckSeconds";
static NSString *const kAtrOptionKey_BleFloorspaceChangeEnabledOverride = @"BleFloorspaceChangeEnabledOverride";



typedef NS_OPTIONS(NSUInteger, ATRCoordinateConversion) {
    atrCoordinateConversionNone = 0,
    atrCoordinateConversionNegateX = 1 << 0,
    atrCoordinateConversionNegateY = 1 << 1,
    atrCoordinateConversionSwapXY = 1 << 2
};

//
// Constants that are not currently an option
//

static float atrInternalDefaultVLCAccuracy = 0.1;

// The default Lumicast angle accuracy is 5 degrees as defined by Qualcomm.
static float atrInternalDefaultVLCAngleAccuracy = 5.0;

// This value is related to the ATRAngleSource define in ATRAngle.h
static int atrInternalDefaultAngleSource = 1;

static NSUInteger atrMaxNumberOfDeviceTypeFilters = 8;
static NSUInteger atrMaxCaptureFrequencyMS = 60000;
static NSUInteger atrMaxTransmitFrequencyMS = 120000;
static NSUInteger atrActionZoneCheckFrequencyMS =  500;

#endif
