//
//  ATRBLELocationProvider.h
//  AtriusLocation
//
//  Created by Satya Mukkavilli on 10/4/16.
//  Copyright © 2016 Acuity Brands. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "ATRILocationProvider.h"
#import "Floorspace.h"


/*
 @brief The ATRBLELocationProvider class represents an ATR BLE location manager.
 */
@interface ATRBLELocationProvider : NSObject <ATRILocationProvider>

- (nullable id) init __attribute__((unavailable("init not available. Use static class methods.")));

/*
    Returns the current ATR BLE location manager object.
    @returns The current ATRBLELocationProvider object.
 */
+(ATRBLELocationProvider * _Nonnull)sharedInstance;

/*
 Set the site and floor.
 @param site The site that was loaded.
 @param floor The floor that was loaded.
 @param floorspace The floorspace that was loaded.
 */
-(void) setSite: (ATRSite* _Nullable) site andFloor: (ATRFloor* _Nullable) floor andFloorspace: (Floorspace* _Nullable) floorspace;
-(void)silentDisableBlePositioning;

@property BOOL isEnabled;

@end
