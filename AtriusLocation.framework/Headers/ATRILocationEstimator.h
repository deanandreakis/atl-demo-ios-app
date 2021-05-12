//
//  ATRILocationEstimator.h
//  AtriusLocation
//
//  Created by Grant Yi on 11/13/17.
//  Copyright © 2017 Acuity Brands. All rights reserved.
//

#import "ATRLocation.h"
@protocol ATRILocationEstimator <NSObject>
@optional

-(void)start;

-(void)stop;

-(void)reset;

-(void)setEstimateWaitTime :(int)waitTimeMs;

-(void)setEstimationUpdateFrequency: (int)updateFrequencyMs;

-(void)setEstimationConfidenceTimeout: (int)confidenceTimeout;

-(int)getWaitTime;

-(int)getUpdateFrequency;

-(int)getConfidenceTimeout;

-(void)updateLiveLocation:(ATRLocation * _Nullable)liveLoction;



@end
