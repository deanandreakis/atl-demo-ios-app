//
//  ATRPreference.h
//  AtriusRoute
//
//  Created by Satya Mukkavilli on 4/12/17.
//  Copyright © 2017 Acuity Brands. All rights reserved.
//

#ifndef ATRPreference_h
#define ATRPreference_h

/**
 Used to specify the route preference of either avoid stairs or not.
 ATRRoute_WALKING don't avoid stairs.
 ATRRoute_ADA avoid stairs.
 */
typedef enum {
    ATRRoute_WALKING = 1, /**< Walking */
    ATRRoute_ADA = 2, /**< Accessible */
} ATRPreference;

#endif /* ATRPreference_h */
