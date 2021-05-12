//
//  ATRCompassProvider.h
//  AtriusLocation
//
//  Created by Satya Mukkavilli on 6/27/17.
//  Copyright © 2017 Acuity Brands. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ATRAngle.h"

@protocol ATRCompassProviderDelegate;

@interface ATRCompassProvider : NSObject

-(void)enableCompass;

-(void)disableCompass;
/**
 The delegate to be called in response to ATR Compass Provider listener.
 */
@property (weak, nonatomic, getter=getDelegate, setter=setDelegate:)id<ATRCompassProviderDelegate> _Nullable delegate;


@end

@protocol ATRCompassProviderDelegate <NSObject>

-(void)onCompassAngleUpdate:(ATRAngle* _Nullable)angle;

@end
