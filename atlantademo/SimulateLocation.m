//
//  SimulateLocation.m
//  atlantademo
//
//  Created by Melinda Frost on 11/13/17.
//  Copyright © 2017 gisi. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "retailerdef.h"
#import "SimulateLocation.h"

@implementation SimulateLocation

int currentIndex = 0;
SimulationState simState = SimulationStopped;
NSTimer *aTimer;

-(id) init{
    self = [super init];
    [ATRCore setApiUrl:ATRIUS_BASE_URL_PREFIX];
    [ATRCore configureWithApiToken:ATRIUS_RETAILER_API_KEY andPartnerId:ATRIUS_PARTNER_ID andEnvironmentId:ATRIUS_ENVIRONMENT_ID];
    
    ATRLocationOptions *locationOptions = [ATRLocationOptionsBuilder makeWithBuilderBlock:^(ATRLocationOptionsBuilder *builder) {
        builder.desiredLocationAuthorizationStatus = kCLAuthorizationStatusAuthorizedWhenInUse;
        builder.useCompassWithBLE = YES;
        }];
    ATRServerOptions *serverOptions = [ATRServerOptionsBuilder makeWithBuilderBlock:^(ATRServerOptionsBuilder *builder) {
        /* Server options example */
         builder.locationSampleMs = 500;
         builder.transmitFrequencyMs = 5000;
         builder.disableCache = NO;
    }];
    self.locationManager = [ATRLocationManagerV2 sharedInstance];
    [self.locationManager addDelegate:self];
    [self.locationManager updateOptionsforLocation:locationOptions andServer:serverOptions];
    [self.locationManager loadSite:ATRIUS_SITENAME];
    
    return self;
}


- (void) fakeWalkingRoute:(NSTimer *)timer
{
    switch(simState){
        case SimulationStopped:
            [timer invalidate];
            [self.locationManager disable];
            break;
        case SimulationStarted:
            //fire off update current location
            [self updateCurrentLocation];
            [self.locationManager enable];
            [timer isValid];
            break;
        default:
            [timer isValid];
            break;
    }
}

-(void) onSiteLoaded: (ATRSite *) site withFloor: (ATRFloor *) floor{
    NSLog(@"Loaded site: %@ \nLoaded floor: %@", [site name], [floor name]);
    
    [self.locationManager enable];
}

-(void) onLocationUpdate:(ATRLocation *)location{
    
    NSLog(@"onLocationUpdate - X: %f   /   Y: %f", location.x, location.y);
    ATRCoordinate *coord = [[ATRCoordinate alloc] init];
    [coord setX:location.x];
    [coord setY:location.y];
    NSMutableDictionary* locInfo = [NSMutableDictionary dictionary];
    [locInfo setObject: coord forKey:@"currentCoord"];
    [[NSNotificationCenter defaultCenter]
     postNotificationName:@"CoordinateUpdated"
     object: nil userInfo:locInfo];}

/*
 Called whenever an error occures during the Atrius lifecycle
 @param error The error object with details
 */
-(void) onError:(NSError *)error{
    
    NSLog(@"onError: %@", [error description]);
    
}

- (ATRSimulation *) createSimulation {
    currentIndex = 0;
    bool loopSim = NO;
    NSMutableArray<ATRSimulationLocation*>* locations = [[NSMutableArray alloc] initWithCapacity:[self.simCoordinates count]];
    for(ATRCoordinate *coord in self.simCoordinates){
        ATRSimulationLocation *simLocation = [ATRSimulationLocationBuilder makeWithBuilderBlock:^(ATRSimulationLocationBuilder *builder) {
            builder.x = coord.x;
            builder.y = coord.y;
            builder.source = ATR_SOURCE_VLC;
            builder.floorId = 2;
            builder.angleInDegrees = 1;
            builder.duration = 2000;
        }];
        [locations addObject:simLocation];
    }
    
    ATRSimulation *simulation = [ATRSimulationBuilder makeWithBuilderBlock:^(ATRSimulationBuilder *builder) {
        [builder shouldLoop:loopSim];
        for(ATRSimulationLocation* loc in locations) {
            [builder interpolateToLocation:loc every:250];
        }
    }];
    
    return simulation;
}

-(void) updateCurrentLocation {
    
    if(self.simCoordinates.count > 0){
        NSLog(@"coordinates count: %lu",(unsigned long)self.simCoordinates.count);
        if((currentIndex + 1) == self.simCoordinates.count){
            //stop timer
            simState = SimulationStopped;
            [self.locationManager disable];
        }else{
            ATRCoordinate *coord = self.simCoordinates[currentIndex];
            
            NSMutableDictionary* locInfo = [NSMutableDictionary dictionary];
            [locInfo setObject: coord forKey:@"currentCoord"];
            [[NSNotificationCenter defaultCenter]
             postNotificationName:@"CoordinateUpdated"
             object: nil userInfo:locInfo];
            
            currentIndex++;
        }
    }
}

-(void)restartSimulation {
    [self.locationManager loadSimulation:[self createSimulation]];
}

-(void)startSimulation{
    simState = SimulationStarted;
    
    //if(aTimer != nil){
    //    [aTimer invalidate];
    //}
    //aTimer = [NSTimer scheduledTimerWithTimeInterval:3.0f target:self selector:@selector(fakeWalkingRoute:) userInfo:nil repeats:YES];
    [self.locationManager enable];
}

-(void)pauseSimulation{
    simState = SimulationPaused;
    [self.locationManager disable];
    
}

-(void)endSimulation{
    simState = SimulationStopped;
    if(aTimer != nil){
        [aTimer invalidate];
    }
    [self.locationManager disable];
}

@end
