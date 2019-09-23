//
//  RNGADUnifiedNativeAdView.m
//  RNAdMobManager
//
//  Created by Jan-Ole Claußen on 19.09.19.
//  Copyright © 2019 accosine. All rights reserved.
//
#import "RNGADUnifiedNativeAdView.h"
#import "RNAdMobUtils.h"

#if __has_include(<React/RCTBridgeModule.h>)
#import <React/RCTBridgeModule.h>
#import <React/UIView+React.h>
#import <React/RCTLog.h>
#else
#import "RCTBridgeModule.h"
#import "UIView+React.h"
#import "RCTLog.h"
#endif

@implementation RNGADUnifiedNativeAdView
{
    GADUnifiedNativeAdView *_nativeAdView;
    GADAdLoader * _adLoader;
}

- (void)dealloc
{
    _adLoader.delegate = nil;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if ((self = [super initWithFrame:frame])) {
        super.backgroundColor = [UIColor clearColor];
        UIWindow *keyWindow = [[UIApplication sharedApplication] keyWindow];
        UIViewController *rootViewController = [keyWindow rootViewController];
        _nativeAdView = [[GADUnifiedNativeAdView alloc] init];
       // _adLoader = [[GADAdLoader alloc] initWithAdUnitID:_adLoader.adUnitID ]
        _adLoader.delegate = self;
        [self addSubview:_nativeAdView];
    }
    return self;
}

- (void)adLoader:(GADAdLoader *)adLoader didReceiveUnifiedNativeAd:(GADUnifiedNativeAd *)nativeAd {
    _nativeAdView.nativeAd = nativeAd;
    // In order for the SDK to process touch events properly, user interaction
    // should be disabled.
    _nativeAdView.callToActionView.userInteractionEnabled = NO;
}

- (void)adLoader:(GADAdLoader *)adLoader didFailToReceiveAdWithError:(GADRequestError *)error {
    NSLog(@"%@ failed with error: %@", adLoader, error);
}

@end