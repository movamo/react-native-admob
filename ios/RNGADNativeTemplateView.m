//
//  RNGADUnifiedNativeAdView.m
//  RNAdMobManager
//
//  Created by Jan-Ole Claußen on 19.09.19.
//  Copyright © 2019 accosine. All rights reserved.
//
#import "RNGADNativeTemplateView.h"
#import "RNAdMobUtils.h"
#import <React/RCTUtils.h>
#import "GADTVotingTemplateView.h"
#import "GADTVisitorsTemplateView.h"
#import "GADTMatchesTemplateView.h"
#import "GADTChatsTemplateView.h"
#import "GADTSearchTemplateView.h"


#if __has_include(<React/RCTBridgeModule.h>)
#import <React/RCTBridgeModule.h>
#import <React/UIView+React.h>
#import <React/RCTLog.h>
#else
#import "RCTBridgeModule.h"
#import "UIView+React.h"
#import "RCTLog.h"
#endif

@implementation RNGADNativeTemplateView

{
    GADUnifiedNativeAdView * _nativeAdView;
    GADAdLoader * _adLoader;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    NSLog(@"initWithFrame");

    if ((self = [super initWithFrame:frame])) {
        super.backgroundColor = [UIColor clearColor];
        UIWindow *keyWindow = [[UIApplication sharedApplication] keyWindow];
        UIViewController *rootViewController = [keyWindow rootViewController];

        _nativeAdView = [[GADUnifiedNativeAdView alloc] init];
        

        [self addSubview:_nativeAdView];
        self.userInteractionEnabled=YES;
    }
    return self;
}


- (void)adLoader:(GADAdLoader *)adLoader didFailToReceiveAdWithError:(GADRequestError *)error 
{
    NSLog(@"%@ failed with error: %@", adLoader, error);
    if (self.onAdFailedToLoad) {
        self.onAdFailedToLoad(@{ @"error": @{ @"message": [error localizedDescription] } });
    }
}
    
- (void)adLoader:(GADAdLoader *)adLoader didReceiveUnifiedNativeAd:(GADUnifiedNativeAd *)nativeAd 
{
    NSLog(@"didReceiveUnifiedNativeAd");

   if (self.onAdLoaded) {
       self.onAdLoaded(@{});
   }

    GADTTemplateView *templateView = [self getSome:self.adType];
    
    _nativeAdView = templateView;
    nativeAd.delegate = self;
    
    [self addSubview:templateView];
    templateView.nativeAd = nativeAd;

    [templateView addHorizontalConstraintsToSuperviewWidth];
    [templateView addVerticalCenterConstraintToSuperview];
}

- (GADTTemplateView*)getSome:(NSString *)adType
{
    NSArray * items = @[@"voting", @"visitors", @"matches", @"chats", @"search"];
    int adTypeAsInt = [items indexOfObject:adType];
    switch(adTypeAsInt)
    {
        case 0:
            return [[GADTVotingTemplateView alloc] init];
            break;
        case 1:
            return [[GADTVisitorsTemplateView alloc] init];
            break;
        case 2:
            return [[GADTMatchesTemplateView alloc] init];
            break;
        case 3:
            return [[GADTChatsTemplateView alloc] init];
            break;
        case 4:
            return [[GADTSearchTemplateView alloc] init];
            break;
        default:
            return [[GADTMatchesTemplateView alloc] init];
            break;
    }
}

- (void)setAdId:(NSString *)adId
{
    NSLog(@"setAdUnitId: %@", adId);
    _adId = adId;
    _adLoader = [[GADAdLoader alloc]
                     initWithAdUnitID:_adId
                     rootViewController:self
                     adTypes:@[ kGADAdLoaderAdTypeUnifiedNative ]
                     options:nil];
    
    _adLoader.delegate = self;
    [_adLoader loadRequest:[GADRequest request]];
}

- (void)setAdType:(NSString *)adType
{
    NSLog(@"setAdType: %@", adType);
    _adType = adType;
}

# pragma mark GADBannerViewDelegate

/// Tells the delegate that a full screen view will be presented in response
/// to the user clicking on an ad.
- (void)nativeAdWillPresentScreen:(GADUnifiedNativeAd *)nativeAd
{
    if (self.onAdOpened) {
        self.onAdOpened(@{});
    }
}

/// Tells the delegate that the full screen view will be dismissed.
- (void)nativeAdWillDismissScreen:(GADUnifiedNativeAd *)nativeAd
{
    if (self.onAdClosed) {
        self.onAdClosed(@{});
    }
}

/// Tells the delegate that a user click will open another app (such as
/// the App Store), backgrounding the current app.
- (void)nativeAdWillLeaveApplication:(GADUnifiedNativeAd *)nativeAd
{
    if (self.onAdLeftApplication) {
        self.onAdLeftApplication(@{});
    }
}
@end
