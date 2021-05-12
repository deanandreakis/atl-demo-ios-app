//
//  ATRSimplePolygon.h
//  ATRNavigatorCore
//
//  Created by Christopher Bupp on 5/25/16.
//  Copyright © 2016 Christopher Bupp. All rights reserved.
//

#import "ATRIGeometry.h"

@interface ATRSimplePolygon : NSObject<ATRIGeometry>

@property (readonly, nonnull) NSArray *points;

- (nullable id) initWithPoints:(NSArray *_Nonnull)points;


//NSARRay *tmp;
//myClass *myC = [[alloc];
//tmp = [nsarray addObj : myC];
@end
