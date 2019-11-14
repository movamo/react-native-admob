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
}

- (instancetype)initWithFrame:(CGRect)frame
{
    NSLog(@"RNGADNativeTemplateView.initWithFrame");

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

-(void) setNativeAd:(GADUnifiedNativeAd *)nativeAd{

    NSLog(@"RNGADNativeTemplateView.setNativeAd");
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
    NSLog(@"RNGADNativeTemplateView.getSome");
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

- (void)setAdType:(NSString *)adType
{
    NSLog(@"RNGADNativeTemplateView.setAdType: %@", adType);
    _adType = adType;
}

# pragma mark GADBannerViewDelegate

/// Tells the delegate that a full screen view will be presented in response
/// to the user clicking on an ad.
- (void)nativeAdWillPresentScreen:(GADUnifiedNativeAd *)nativeAd
{
    NSLog(@"RNGADNativeTemplateView.nativeAdWillPresentScreen");
    if (self.onAdOpened) {
        self.onAdOpened(@{});
    }
}

/// Tells the delegate that the full screen view will be dismissed.
- (void)nativeAdWillDismissScreen:(GADUnifiedNativeAd *)nativeAd
{
    NSLog(@"RNGADNativeTemplateView.nativeAdWillDismissScreen");
    if (self.onAdClosed) {
        self.onAdClosed(@{});
    }
}

/// Tells the delegate that a user click will open another app (such as
/// the App Store), backgrounding the current app.
- (void)nativeAdWillLeaveApplication:(GADUnifiedNativeAd *)nativeAd
{
    NSLog(@"RNGADNativeTemplateView.nativeAdWillLeaveApplication");
    if (self.onAdLeftApplication) {
        self.onAdLeftApplication(@{});
    }
}
@end
