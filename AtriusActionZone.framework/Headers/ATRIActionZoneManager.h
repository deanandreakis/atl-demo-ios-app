//
//  ATRIActionZoneManager.h
//  AtriusActionZone
//
//  Created by Satya Mukkavilli on 1/5/17.
//  Copyright © 2017 Acuity Brands. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ATRActionZone.h"

@protocol ATRIActionZoneTransitionDelegate;

@protocol ATRIActionZoneManager <NSObject>

/**
 Adds an Action Zone manager interface delegate to the Action Zone manager.
 @param delegate The Action Zone manager delegate.
 */
-(void) addDelegate:(nonnull id<ATRIActionZoneTransitionDelegate>)delegate;

/**
 Removes an Action Zone manager interface delegate from the Action Zone manager.
 @param delegate The Action Zone manager delegate.
 */
-(void) removeDelegate:(nonnull id<ATRIActionZoneTransitionDelegate>)delegate;

@end

/**
 @brief The ATRIActionZoneTransitionDelegate represents the methods need to receive communication from the Action Zone manager.
 */
@protocol ATRIActionZoneTransitionDelegate <NSObject>

@optional

/**
 Notifies the delegator that location has enetered a specified action zone.
 @param actionZone The Action Zone that has been enetered.
 */
- (void) onEntered:(ATRActionZone*_Nonnull)actionZone;

/**
 Notifies the delegator that location has exited a specified action zone.
 @param actionZone The Action Zone that has been exited.
 */
- (void) onExited:(ATRActionZone *_Nonnull)actionZone;

/**
 Notifies the delegator that location has dwelled in a specified action zone for a specific time.
 @param actionZone The Action Zone that has dwelt inside.
 */
- (void) onDwellInside:(ATRActionZone *_Nonnull)actionZone;

@end
