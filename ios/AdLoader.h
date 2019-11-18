@import GoogleMobileAds;
#import "RNGADNativeTemplateView.h"
#import "RNAdManager.h"

@interface AdLoader : NSObject <GADUnifiedNativeAdLoaderDelegate>
-(void)requestAd;
-(void)registerAdView:(nonnull RNGADNativeTemplateView *) templateView resolve:(RCTPromiseResolveBlock)resolve;
-(instancetype)init:(UIViewController *)rootViewController adUnitID:(NSString*)adUnitID ref:(RNAdManager*)ref;

@end
