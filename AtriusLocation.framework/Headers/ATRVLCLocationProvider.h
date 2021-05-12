//
//  ATRVLCLocationProvider.h
//  AtriusLocation
//
//  Created by Satya Mukkavilli on 10/4/16.
//  Copyright © 2016 Acuity Brands. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "ATRILocationProvider.h"
#import "Floorspace.h"

/**
 @brief The ATRVLCLocaitonManager class represents a location controller for VLC (visual light communication) stream of positions.
 */
@interface ATRVLCLocationProvider : NSObject <ATRILocationProvider> {
    ATRSite *currentSite;
    ATRFloor *currentFloor;
    
    Floorspace *currentFloorspace;
}

- (nullable id) init __attribute__((unavailable("The init method is not available.  Use static class method sharedInstance.")));

/**
    Returns to current ATRVLCLocationManage object.
    @returns ATRVLCLocationProvider object.
 */
+(ATRVLCLocationProvider* _Nonnull)sharedInstance;


+(NSString* _Nullable)getVersionNumber;

- (int) getCentralFixtureCodeword;

/*
 Set the site and floor.
 @param site The site that was loaded.
 @param floor The floor that was loaded.
 @param floorspace The floorspace that was loaded.
 */
-(void) setSite: (ATRSite* _Nullable) site andFloor: (ATRFloor* _Nullable) floor andFloorspace: (Floorspace* _Nullable) floorspace;

-(void) floorspaceHasChanged:(ATRSite* _Nullable)site withFloor:(ATRFloor* _Nullable)floor withFloorspace:(Floorspace* _Nullable)floorspace;

@property BOOL isEnabled;
@property BOOL isEnabling;
@end


