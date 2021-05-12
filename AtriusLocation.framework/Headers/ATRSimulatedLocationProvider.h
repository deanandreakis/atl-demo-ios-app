//
//  ATRSimulatedLocationProvider.h
//  AtriusLocation
//
//  Created by Christopher Bupp on 5/21/17.
//  Copyright © 2017 Acuity Brands. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ATRILocationProvider.h"
#import "ATRSimulation.h"

@interface ATRSimulatedLocationProvider : NSObject <ATRILocationProvider>

- (void) setSite:(ATRSite* _Nullable)site;
- (void) setSimulation:(ATRSimulation* _Nullable)simulation;

@end
