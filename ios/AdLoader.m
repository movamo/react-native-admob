#import "AdLoader.h"
#import "RNAdMobUtils.h"

#if __has_include(<React/RCTUtils.h>)
#import <React/RCTUtils.h>
#else
#import "RCTUtils.h"
#endif
#import <React/RCTUIManager.h>
#import "RNGADNativeTemplateView.h"
#import "RNAdManager.h"
static NSString *const kEventAdLoaded = @"nativeAdLoaded";
static NSString *const kEventAdFailedToLoad = @"nativeAdFailedToLoad";

@implementation AdLoader
{
    GADAdLoader  *_adLoader;
    NSString *_adUnitID;
    RNAdManager*_adManager;
    NSMutableArray<RNGADNativeTemplateView*> *templateViews;
    NSMutableArray<GADUnifiedNativeAd*> *nativeAds;
    NSUInteger* _numAds;
}

- (instancetype)init:(UIViewController *)rootViewController adUnitID:(NSString*)adUnitID ref:(RNAdManager*)ref
{
        NSLog(@"AdLoader.init");
    self = [super init];
    if(self) {
        templateViews = [NSMutableArray new];
        nativeAds = [NSMutableArray new];
        _adUnitID=adUnitID;
        _adManager=ref;
        _numAds=0;
        _adLoader = [[GADAdLoader alloc]
                         initWithAdUnitID:_adUnitID
                         rootViewController:rootViewController
                         adTypes:@[ kGADAdLoaderAdTypeUnifiedNative ]
                         options:nil];        
                         
        _adLoader.delegate = self;
    }
    return self;
}

- (NSArray<NSString *> *)supportedEvents
{
    return @[
             kEventAdLoaded,
             kEventAdFailedToLoad ];
}

-(void)registerAdView:(nonnull RNGADNativeTemplateView *) templateView resolve:(RCTPromiseResolveBlock)resolve
{
    NSLog(@"AdLoader.registerAdView");



            [templateViews addObject:templateView];
            NSUInteger* index =[nativeAds count]-1;
            GADUnifiedNativeAd* ad = [nativeAds objectAtIndex:index];
            [templateView setNativeAd: ad];
         //          [nativeAds removeObjectAtIndex:index];
                   resolve(@[]);


  
    
}

-(void)requestAd 
{
        NSLog(@"AdLoader.requestAd");

        GADRequest *request = [GADRequest request];
        [_adLoader loadRequest:request];
  
}




#pragma mark GADUnifiedNativeAdLoaderDelegate

- (void)adLoader:(GADAdLoader *)adLoader didFailToReceiveAdWithError:(GADRequestError *)error 
{
        NSLog(@"AdLoader.didFailToReceiveAdWithError");

}
    
- (void)adLoader:(GADAdLoader *)adLoader didReceiveUnifiedNativeAd:(GADUnifiedNativeAd *)nativeAd 
{
        NSLog(@"AdLoader.didReceiveUnifiedNativeAd");
        [nativeAds addObject:nativeAd];
       // _numAds=_numAds+1;
        NSUInteger* adCount = [nativeAds count];
        NSString *text = [NSString stringWithFormat:@"%li",adCount];

        [_adManager sendEvent:kEventAdLoaded body:@{@"adCount":text, @"adUnitId":_adUnitID}];
}

@end
