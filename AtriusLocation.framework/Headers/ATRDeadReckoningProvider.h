#import <UIKit/UIKit.h>
#import <CoreMotion/CoreMotion.h>
#import <CoreLocation/CoreLocation.h>
#import "ATRAngle.h"


@interface ATRDeadReckoningProvider : NSObject<CLLocationManagerDelegate>
-(nullable id)init;
-(void)start;
-(void)stop;
-(void)reset;
-(void)calculateCurrentPosition:(double)x andWithY:(double)y andWithZ:(double)z andWithTimeStamp:(double)timestamp;
-(void)setCoordinate: (ATRCoordinate* _Nonnull)coordinate;
-(ATRCoordinate* _Nonnull)getEstimatedCoordinate;
-(ATRAngle* _Nonnull)getEstimatedAngle;
@end
