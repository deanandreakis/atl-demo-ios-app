//
//  ATRRoutePriority.h
//  AtriusRoute
//
//  Created by Stan Hughes on 5/11/17.
//  Copyright © 2017 Acuity Brands. All rights reserved.
//

#ifndef ATRRoutePriority_h
#define ATRRoutePriority_h

/**
 Used to specify if the priority is high or low.
 A low priority indicates that the stops will be processed as a low priority.
 A high priority indicates that the stops will be processed as a hight priority.
 */
typedef enum {
    ATRRoute_LOW = 0, /**< Low priority */
    ATRRoute_HIGH = 1, /**< High priority */
} ATRRoutePriority;

#endif /* ATRRoutePriority_h */
