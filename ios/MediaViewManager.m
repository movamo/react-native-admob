//
//  RNGADMediaViewManager.m
//  RNAdMobManager
//
//  Created by Jan-Ole Claußen on 19.09.19.
//  Copyright © 2019 accosine. All rights reserved.
//

#import "MediaViewManager.h"

@implementation MediaViewManager

RCT_EXPORT_MODULE();

- (UIView *)view
{
    return [[GADMediaView alloc] init];
}

@end
