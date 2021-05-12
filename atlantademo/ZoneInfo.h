//
//  ZoneInfo.h
//  atlantademo
//
//  Created by GISAdmin on 3/21/18.
//  Copyright © 2018 gisi. All rights reserved.
//
@import Foundation;
@import ArcGIS;

#ifndef ZoneInfo_h
#define ZoneInfo_h

@protocol ZoneInfoClassDelegate <NSObject>
@required
-(void)metricsDidUpdate:(NSDictionary*) metrics;
@end

@interface ZoneInfoClass: NSObject <NSURLSessionDelegate>
@property (retain, nonatomic) id <ZoneInfoClassDelegate> delegate;
- (void) getMetrics;
@end



#endif /* ZoneInfo_h */
