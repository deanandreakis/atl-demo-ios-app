#import "ATRILocationEstimator.h"
#import "ATRAngle.h"
#import "ATRILocationProvider.h"
@interface ATRDeadReckoningEstimator : NSObject<ATRILocationEstimator,ATRILocationProvider>
@property (nonatomic) int waitTimeMs;
@property (nonatomic) int updateFrequencyMs;
@property (nonatomic) int confidenceTimeoutMs;
- (nullable id) init;
- (nullable id) initWithWaitTime:(int)waitTime andUpdateFrequency:(int)updateFrequency andConfidenceTimeout:(int)confidenceTimeout;
-(void)addDelegate:(id<ATRILocationProviderDelegate> _Nonnull)delegate;

-(void)removeDelegate:(id<ATRILocationProviderDelegate> _Nonnull)delegate;
@end
