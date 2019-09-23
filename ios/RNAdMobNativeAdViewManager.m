//
//  RNAdMobNativeAdViewManager.m
//  RNAdMobManager
//
//  Created by Jan-Ole Claußen on 19.09.19.
//  Copyright © 2019 accosine. All rights reserved.
//

#import "RNAdMobNativeAdViewManager.h"
#import "RNGADUnifiedNativeAdView.h"

@implementation RNAdMobNativeAdViewManager

RCT_EXPORT_MODULE();
- (UIView *)view
{
    return [RNGADUnifiedNativeAdView new];
}

RCT_REMAP_VIEW_PROPERTY(adUnitID, _adLoader.adUnitID, NSString)

RCT_EXPORT_VIEW_PROPERTY(onAdLoaded, RCTBubblingEventBlock)
RCT_EXPORT_VIEW_PROPERTY(onAdFailedToLoad, RCTBubblingEventBlock)
RCT_EXPORT_VIEW_PROPERTY(onAdOpened, RCTBubblingEventBlock)
RCT_EXPORT_VIEW_PROPERTY(onAdClosed, RCTBubblingEventBlock)
RCT_EXPORT_VIEW_PROPERTY(onAdLeftApplication, RCTBubblingEventBlock)


@end


