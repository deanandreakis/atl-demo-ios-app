//
//  ATRIGeometry.h
//  ATRNavigatorCore
//
//  Created by Christopher Bupp on 5/25/16.
//  Copyright © 2016 Christopher Bupp. All rights reserved.
//

#import "ATRPoint.h"

@protocol ATRIGeometry <NSCopying, NSObject>

- (BOOL) contains:(ATRPoint* _Nonnull)point;

@end
