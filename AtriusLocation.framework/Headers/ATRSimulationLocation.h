//
//  ATRSimulationLocation.h
//  AtriusLocation
//
//  Created by Christopher Bupp on 5/21/17.
//  Copyright © 2017 Acuity Brands. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ATRLocation.h"
#import "ATRAngle.h"

@interface ATRSimulationLocation : NSObject

- (nullable id) init __attribute__((unavailable("init not available. Use ATRSimulationLocationBuilder class.")));

/**
 The x portion of the simulated position.
 */
@property (readonly) double x;

/**
 The y portion of the simulated position.
 */
@property (readonly) double y;

/**
 The accuracy of the simulated position.
 */
@property (readonly) float accuracy;

/**
 The source of the simulated position.
 */
@property (readonly) AtrLocationSrc source;

/**
 The floor of the simulated position.
 */
@property (readonly) int floorId;

/**
 The angle of the simulated location's heading in radians
 */
@property (readonly) float angleInRadians;

/**
 The angle of the simulated location's heading in degrees
 */
@property (readonly) float angleInDegrees;

/**
 The duration of the simulated location
 */
@property (readonly) int duration;

/**
 Defines if the simulation location has a location defined
 */
@property (readonly) BOOL hasLocation;

/**
 Defines if the simulation location has an angle defined
 */
@property (readonly) BOOL hasAngle;

@end

@protocol ATRISimulationLocationBuilder <NSObject>
/**
 The x portion of the simulated position.
 */
@property (nonatomic, setter=hiddenSetX:) double x;

/**
 The y portion of the simulated position.
 */
@property (nonatomic, setter=hiddenSetY:) double y;

/**
 The accuracy of the simulated position.
 */
@property (setter=hiddenSetAccuracy:) float accuracy;

/**
 The source of the simulated position.
 */
@property (setter=hiddenSetSource:) AtrLocationSrc source;

/**
 The floor of the simulated position.
 */
@property (nonatomic, setter=hiddenSetFloorId:) int floorId;

/**
 The angle of the simulated location's heading in degrees
 */
@property (nonatomic, setter=hiddenSetAngleInDegrees:) float angleInDegrees;

/**
 The duration of the simulated location
 */
@property (setter=hiddenSetDuration:) int duration;
@end

typedef void(^ATRSimulationLocationBuilderBlock)(id<ATRISimulationLocationBuilder> _Nonnull);

@interface ATRSimulationLocationBuilder : NSObject<ATRISimulationLocationBuilder>

/**
 Defines if the simulation location has a location defined
 */
@property (readonly, getter=getHasLocation) BOOL hasLocation;

/**
 Defines if the simulation location has an angle defined
 */
@property (readonly, getter=getHasAngle) BOOL hasAngle;

-(ATRSimulationLocationBuilder*_Nonnull) setX:(double)x;
-(ATRSimulationLocationBuilder*_Nonnull) setY:(double)y;
-(ATRSimulationLocationBuilder*_Nonnull) setAccuracy:(double)accuracy;
-(ATRSimulationLocationBuilder*_Nonnull) setSource:(double)source;
-(ATRSimulationLocationBuilder*_Nonnull) setFloorId:(double)floorId;
-(ATRSimulationLocationBuilder*_Nonnull) setAngleInDegrees:(double)angle;
-(ATRSimulationLocationBuilder*_Nonnull) setDuration:(double)duration;

/**
 Builds a SimLocation Object.
 @returns ATRSimulationLocation The SimLocation object that was created.
 */
- (ATRSimulationLocation* _Nullable) build;

/**
 Static method utilizing a ATRSimulationLocationBuilderBlock to generate an ATRSimPosition object.
 @param block The SimPosition Builder block.
 @returns instance The instance of ATRSimulationLocation class.
 */
+ (ATRSimulationLocation* _Nullable) makeWithBuilderBlock:(ATRSimulationLocationBuilderBlock _Nonnull)block;

@end

