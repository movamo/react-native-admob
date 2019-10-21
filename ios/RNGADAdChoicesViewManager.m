//
//  RNGADAdChoicesViewManager.m
//  RNAdMobManager
//
//  Created by Jan-Ole Claußen on 19.09.19.
//  Copyright © 2019 accosine. All rights reserved.
//

#import "RNGADAdChoicesViewManager.h"

@implementation RNGADAdChoicesViewManager

RCT_EXPORT_MODULE()

- (UIView *)view
{
    return [[GADAdChoicesView alloc] init];
}

@end
