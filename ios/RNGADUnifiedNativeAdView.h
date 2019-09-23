//
//  RNGADUnifiedNativeAdView.h
//  RNAdMobManager
//
//  Created by Jan-Ole Claußen on 19.09.19.
//  Copyright © 2019 accosine. All rights reserved.
//

#if __has_include(<React/RCTView.h>)
#import <React/RCTView.h>
#else
#import "RCTView.h"
#endif

#import <GoogleMobileAds/GoogleMobileAds.h>

@class RCTEventDispatcher;

@interface RNGADUnifiedNativeAdView: RCTView <GADUnifiedNativeAdLoaderDelegate, GADUnifiedNativeAdDelegate>

@property (nonatomic, copy) RCTBubblingEventBlock onAdLoaded;
@property (nonatomic, copy) RCTBubblingEventBlock onAdFailedToLoad;
@property (nonatomic, copy) RCTBubblingEventBlock onAdOpened;
@property (nonatomic, copy) RCTBubblingEventBlock onAdClosed;
@property (nonatomic, copy) RCTBubblingEventBlock onAdLeftApplication;

@end
