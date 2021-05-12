//
//  ATRSiteQueryResult.h
//  AtriusCore
//
//  Created by Christopher Bupp on 2/9/17.
//  Copyright © 2017 Acuity Brands. All rights reserved.
//

#import <Foundation/Foundation.h>
/**
 @brief The ATRSiteQueryResult class represents a query result from the server.
 */
@interface ATRSiteQueryResult : NSObject

/**
 The site ID of the site.
 */
@property (readonly) int siteId;

/**
 The site name of the site.
 */
@property (readonly, nonnull) NSString *name;

@property (readonly,nonnull) NSString* serviceStatus;

/**
 Initialize a site with site ID, name
 @param siteId The site ID
 @param name The site name
 */
- (nullable id) initWithSiteId:(int) siteId withName: (NSString *_Nonnull) name andServiceStatus: (NSString *_Nonnull) serviceStatus;

@end
