//
//  ATRZone.h
//  ATRNavigatorCore
//
//  Created by Christopher Bupp on 5/23/16.
//  Copyright © 2016 Christopher Bupp. All rights reserved.
//

#import "ATRIZone.h"

@interface ATRZone : NSObject<ATRIZone>

- (nullable id) initWithGeometry:(id<ATRIGeometry> _Nonnull)geometry floor:(int)floor;

@end
