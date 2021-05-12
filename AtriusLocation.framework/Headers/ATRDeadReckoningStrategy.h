#import "ATRISmoothingStrategy.h"
@import AtriusCore;
@interface ATRDeadReckoningStrategy : NSObject<ATRISmoothingStrategy>
-(void)reset;
-(void)stopSensorCapture;
-(ATRCoordinate* _Nullable)update:(ATRCoordinate* _Nullable)input;
- (nullable id) init;
- (nullable id) initWithTolerance:(double) tolerance;

@end
