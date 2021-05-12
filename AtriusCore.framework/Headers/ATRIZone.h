//
//  ATRIZone.h
//  ATRNavigatorCore
//
//  Created by Christopher Bupp on 5/23/16.
//  Copyright © 2016 Christopher Bupp. All rights reserved.
//

#import "ATRFloor.h"
#import "ATRIGeometry.h"

@protocol ATRIZone <NSCopying, NSObject>

@property (nonnull) id<ATRIGeometry> geometry;
@property int floor;

- (BOOL) positionInside:(ATRPoint * _Nonnull)position;

- (BOOL)isEqualToZone:(id<ATRIZone> _Nonnull)aZone;

@end
