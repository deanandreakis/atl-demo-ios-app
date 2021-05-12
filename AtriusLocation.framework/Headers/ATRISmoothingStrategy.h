//
//  ATRISmoothingStrategy.h
//  AtriusLocation
//
//  Created by Aaron Tharpe on 5/18/17.
//  Copyright © 2017 Acuity Brands. All rights reserved.
//

#import <Foundation/Foundation.h>
@import AtriusCore;

/**
 @brief The ATRISmoothingStrategy represents the default interface for a position smoothing strategy
 */

@protocol ATRISmoothingStrategy <NSObject>

@required

/**
 Resets the strategy's last known point (subsequently resetting the smoothing prediction)
 This is called in 4 areas of LocationManager:
    1. directly before onFloorChange delegate callback
    2. directly before floorspaceHasChanged delegate callback
    3. when a VLC location is received directly following a BLE location (switch from BLE to VLC-type positioning)
    4. after the location manager is terminated
 */
-(void) reset;

/**
 Updates a given point after applying smoothing logic.
 @param input - The coordinate to pass into a smoothing strategy
 */
- (ATRCoordinate* _Nullable) update:(ATRCoordinate* _Nullable)input;

@end
