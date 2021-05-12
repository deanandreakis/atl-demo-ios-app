//
//  ATRSiteManager.h
//  AtriusCore
//
//  Created by Satya Mukkavilli on 8/23/17.
//  Copyright © 2017 Acuity Brands. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ATRSiteManagerDelegate;

@interface ATRSiteManager : NSObject


/**
	Fetches a list of all available sites for the provided token in ATRCore.
 */
-(void)fetchAllSites;

/**
 The delegate to be called in response to ATR site Manager listener.
 */
@property (weak, nonatomic,nullable, getter=getDelegate, setter=setDelegate:)id<ATRSiteManagerDelegate> delegate;


@end

@protocol ATRSiteManagerDelegate <NSObject>

/**
	Called by framework when the list of sites are available after the download task is complete
 @param siteList value indicates the array list of sites available
 @param isError value indicates if an error occured retrieving the site list*/

-(void)onAtrSiteListReady: (NSArray *_Nullable) siteList andError:(BOOL)isError;


@end
