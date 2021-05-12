//
//  ATRActionZone.h
//  AtriusActionZone
//
//  Created by Christopher Bupp on 7/15/15.
//  Copyright © 2016 Acuity Brands. All rights reserved.
//

/*!
 @header ATRActionZone.h
 
 @brief An ActionZone is a zone that contains the action definitions.
 
 This class also will store and pass along message contents defined by the API and deliver the message contents to the calling application when an action zone event is triggered.
 
 This class can only be instantiated using the ActionZoneBuilder class.
 
 @author Christopher Bupp
 @copyright 2016 Acuity Brands Lighting
 @version 1.0.0
 
 */

@import AtriusCore;

@interface ATRActionZone : NSObject

/**
	Specifies the Action Zone ID in integer.
 */
@property (readonly) int actionZoneId;

/**
	Specifies the Action Zone Site ID in integer.
 */
@property (readonly) int siteId;

/**
	Specifies the Zone.
 */
@property (readonly, nonnull) id<ATRIZone> zone;

/**
	Specifies the name for the Action Zone.
 */
@property (readonly, nonnull) NSString* name;

/**
	Specifies the bool value for the Action Zone enter events.
 */
@property (readonly) BOOL isEnterEnabled;

/**
	Specifies the bool value for the Action Zone exit events.
 */
@property (readonly) BOOL isExitEnabled;

/**
	Specifies the bool value for the Action Zone dwell events.
 */
@property (readonly) BOOL isDwellInside;

/**
	Specifies the value for the Action Zone dwell trigger duration.
 */
@property (readonly) long dwellInsideMS;

/**
	Specifies the associated message for the Action Zone.
 */
@property (nonnull) NSDictionary *messageContent;

- (nullable id) init __attribute__((unavailable("init not available. Use TestBuilder class.")));

/**
 Constructor that relies on the ActionZoneBuilder class to create the instance.
 @param sinceEnterMS The number of milliseconds required for a dwell inside.
 @returns hasDwelt If dwell time is greater than millisecondSinceEnter, then the Action Zone dwelt inside.
 */
- (BOOL) isDwelling:(long)sinceEnterMS;

@end

@protocol ATRIActionZoneBuilder <NSObject>

/**
 Specifies the Action Zone ID in integer.
 */
@property (setter=hiddenSetActionZoneId:) int actionZoneId;

/**
 Specifies the Action Zone Site ID in integer.
 */
@property (setter=hiddenSetSiteId:) int siteId;

/**
 Specifies the Zone.
 */
@property (setter=hiddenSetZone:) _Nonnull id<ATRIZone> zone;

/**
 Specifies the name for the Action Zone.
 */
@property (setter=hiddenSetName:)  NSString* _Nonnull  name;

/**
 Specifies the bool value for the Action Zone enter events.
 */
@property (setter=hiddenSetIsEnterEnabled:) BOOL isEnterEnabled;

/**
 Specifies the bool value for the Action Zone exit events.
 */
@property (setter=hiddenSetIsExitEnabled:) BOOL isExitEnabled;

/**
 Specifies the bool value for the Action Zone dwell events.
 */
@property (setter=hiddenSetIsDwellInside:)  BOOL isDwellInside;

/**
 Specifies the value for the Action Zone dwell trigger duration.
 */
@property (setter=hiddenSetDwellInsideMS:) long dwellInsideMS;

/**
 Specifies the associated message for the Action Zone.
 */
@property (setter=hiddenSetMessageContent:)  NSDictionary * _Nonnull messageContent;

@end

typedef void(^ActionZoneBuilderBlock)(id<ATRIActionZoneBuilder> _Nonnull);

@interface ATRActionZoneBuilder : NSObject<ATRIActionZoneBuilder>

-(ATRActionZoneBuilder*_Nonnull)setActionZoneId:(int)actionZoneId;
-(ATRActionZoneBuilder*_Nonnull)setSiteId:(int)siteId;
-(ATRActionZoneBuilder*_Nonnull)setZone:(_Nonnull id<ATRIZone>)zone;
-(ATRActionZoneBuilder*_Nonnull)setName:( NSString* _Nonnull )name;
-(ATRActionZoneBuilder*_Nonnull)setIsEnterEnabled:(BOOL)isEnterEnabled;
-(ATRActionZoneBuilder*_Nonnull)setIsExitEnabled:(BOOL)isExitEnabled;
-(ATRActionZoneBuilder*_Nonnull)setIsDwellInside:(BOOL)isDwellInside;
-(ATRActionZoneBuilder*_Nonnull)setDwellInsideMS:(long)dwellInsideMS;
-(ATRActionZoneBuilder*_Nonnull)setMessageContent:(NSDictionary*_Nonnull)messageContent;

/**
 Builds an Action Zone.
 @returns actionZone The Action Zone that was created.
 */
- (ATRActionZone*_Nullable) build;

/**
 Static method utilizing a ActionZoneBuilderBlock to generate an ActionZone.
 @param block The Action Zone Builder block.
 @returns instance The instance of ActionZone class.
 */
+ (ATRActionZone*_Nullable) makeWithBuilderBlock:(ActionZoneBuilderBlock _Nonnull)block;


@end

