//
//  SimulateLocation.h
//  atlantademo
//
//  Created by Melinda Frost on 11/13/17.
//  Copyright © 2017 gisi. All rights reserved.
//

#ifndef SimulateLocation_h
#define SimulateLocation_h

@import AtriusCore;
@import AtriusLocation;
@import ArcGIS;

@interface SimulateLocation: NSObject <ATRILocationManagerV2Delegate>
    @property NSArray<ATRCoordinate*> *simCoordinates;
    @property ATRLocationManagerV2 *locationManager;

typedef enum {
    SimulationStopped,
    SimulationStarted,
    SimulationPaused
} SimulationState;

//-(void)getCoordinates:(NSArray<ATRCoordinate*>) *coordinates;
- (ATRSimulation *) createSimulation;
-(void)restartSimulation;
-(void)startSimulation;
-(void)pauseSimulation;
-(void)endSimulation;

@end
#endif /* SimulateLocation_h */
