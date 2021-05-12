//
//  ATRSimulation.h
//  AtriusLocation
//
//  Created by Christopher Bupp on 5/21/17.
//  Copyright © 2017 Acuity Brands. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ATRSimulationLocation.h"

/**
 @brief A class the defines a simulation. 
 
 A simulation is a collection of locations and angles that can be returned
 in place of using Acuity hardware.
 
 @code {.cpp}
 ATRSimulation *simulation = [ATRSimulation makeWithBuilder:^(ATRSimulationBuilder *builder) {
     // set whether the simulation should loop
     [builder shouldLoop: YES];
     // to set the initial start location
     [builder addSimLocation:[ATRSimulationLocation makeWithBuilder:^(ATRSimulationLocationBuilder *builder) {
         builder.x = 20;
         builder.y = 20;
         builder.duration = 500;
         builder.source = ATR_SOURCE_VLC;
         builder.floorId = 1;
     }]];
 
     //using the interpolateToLocation method will create several location on the way to the final location
     [builder interpolateToLocation:[ATRSimulationLocation makeWithBuilder:^(ATRSimulationLocationBuilder *builder) {
         builder.x = 40;
         builder.y = 40;
         builder.duration = 2000;
         builder.source = ATR_SOURCE_VLC;
         builder.floorId = 1;
     }]] every:500];
 
     //interpolateToLocation can also be used to change the floor and source. Note: all of the interpolated points will be assigned the second floor and source
     [builder interpolateToLocation:[ATRSimulationLocation makeWithBuilder:^(ATRSimulationLocationBuilder *builder) {
         builder.x = 60;
         builder.y = 60;
         builder.duration = 2000;
         builder.source = ATR_SOURCE_BLE;
         builder.floorId = 2;
     }]] every:500];
 }];
 @endcode
 
 */
@interface ATRSimulation : NSObject

/**
 The array of the simulated locations.
 */
@property NSArray<ATRSimulationLocation*>* _Nullable locations;

/**
 Sets whether or not the simulation should loop
 */
@property BOOL shouldLoop;

@end

@protocol ATRISimulationBuilder <NSObject>
@property(setter=hiddenSetLocations:) NSMutableArray<ATRSimulationLocation*>* _Nullable locations;
@property(setter=hiddenShouldLoop:) BOOL loop;
@end

typedef void(^ATRSimulationBuilderBlock)(id<ATRISimulationBuilder> _Nonnull);

@interface ATRSimulationBuilder : NSObject<ATRISimulationBuilder>

- (ATRSimulationBuilder *_Nonnull) shouldLoop:(BOOL)loop;

/**
 * Adds an ATRSimulationLocation instance to the current list of SimulationLocations
 */
- (ATRSimulationBuilder *_Nonnull) addSimLocation:(ATRSimulationLocation* _Nonnull)location;

/**
 * Appends an array of ATRSimulationLocations to the current list of SimulationLocations
 */
- (ATRSimulationBuilder*_Nonnull) addSimLocations:(NSMutableArray<ATRSimulationLocation*>*_Nonnull)locations;

/**
* Generates equidistant SimulationLocations between the last Simulation Location in the Builder's list of
* SimulationLocations and appends them to the list of SimulationLocations. If the list of SimulationLocations is current empty,
* the Builder interpolates the given SimulationLocation to itself.
 */
- (ATRSimulationBuilder *_Nonnull) interpolateToLocation:(ATRSimulationLocation* _Nonnull)loc every:(int)milliseconds;

/**
 Builds a Simulation Object.
 @returns ATRSimulation The Simulation object that was created.
 */
- (ATRSimulation*_Nullable) build;

/**
 Static method utilizing a ATRSimulationBuilderBlock to generate an ActionZone.
 @param block The Simulation Builder block.
 @returns instance The instance of ATRSimulation class.
 */
+ (ATRSimulation*_Nullable) makeWithBuilderBlock:(ATRSimulationBuilderBlock _Nonnull )block;

@end

