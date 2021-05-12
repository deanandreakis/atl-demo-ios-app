//
//  ZoneInfoObject.h
//  atlantademo
//
//  Created by GISAdmin on 3/26/18.
//  Copyright © 2018 gisi. All rights reserved.
//
@import Foundation;
@import ArcGIS;

#ifndef ZoneInfoObject_h
#define ZoneInfoObject_h

@interface ZoneInfoObject: NSObject
@property NSString *description;
@property NSNumber *waitTime;
@property AGSPoint *location;
@end

#endif /* ZoneInfoObject_h */
