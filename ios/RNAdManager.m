#import "RNAdManager.h"
#import "RNAdMobUtils.h"

#if __has_include(<React/RCTUtils.h>)
#import <React/RCTUtils.h>
#else
#import "RCTUtils.h"
#endif
#import <React/RCTUIManager.h>
#import "RNGADNativeTemplateView.h"

static NSString *const kEventAdLoaded = @"nativeAdLoaded";
static NSString *const kEventAdFailedToLoad = @"nativeAdFailedToLoad";

@implementation RNAdManager
{
    GADAdLoader  *_adLoader;
    NSString *_adUnitID;
    RCTPromiseResolveBlock _requestAdResolve;
    RCTPromiseRejectBlock _requestAdReject;
    BOOL hasListeners;
    NSMutableArray<RNGADNativeTemplateView*> *templateViews;
    NSMutableArray<GADUnifiedNativeAd*> *nativeAds;
}

- (instancetype)init 
{
        NSLog(@"RNAdManager.init");
    self = [super init];
    if(self) {
        templateViews = [NSMutableArray new];
        nativeAds = [NSMutableArray new];
    }
    return self;
}

- (dispatch_queue_t)methodQueue
{
    return self.bridge.uiManager.methodQueue;
}

+ (BOOL)requiresMainQueueSetup
{
    return NO;
}

RCT_EXPORT_MODULE();

- (NSArray<NSString *> *)supportedEvents
{
    return @[
             kEventAdLoaded,
             kEventAdFailedToLoad ];
}

#pragma mark exported methods

RCT_EXPORT_METHOD(setAdUnitID:(NSString *)adUnitID)
{
    NSLog(@"RNAdManager.setAdUnitID");
    _adUnitID = adUnitID;
}

RCT_EXPORT_METHOD(registerAdView:(nonnull NSNumber *) nativeAdViewTag resolve:(RCTPromiseResolveBlock)resolve reject:(RCTPromiseRejectBlock)reject)
{
    NSLog(@"RNAdManager.registerAdView %@", nativeAdViewTag);

    [self.bridge.uiManager addUIBlock:^(RCTUIManager *uiManager, NSDictionary<NSNumber *,UIView *> *viewRegistry) {
        RNGADNativeTemplateView *templateView = nil;

        if([viewRegistry objectForKey:nativeAdViewTag] == nil) {
            reject(@"E_NO_VIEW_FOR_TAG",@"Could not find nativeTemplateView", nil);
            return;
        }

        if ([[viewRegistry objectForKey:nativeAdViewTag] isKindOfClass:[RNGADNativeTemplateView class]]) {
             templateView = (RNGADNativeTemplateView *)[viewRegistry objectForKey:nativeAdViewTag];
            [templateViews addObject:templateView];
            GADUnifiedNativeAd* ad = [nativeAds objectAtIndex:([nativeAds count]-1)];
            [templateView setNativeAd: ad];
            
            //GADRequest *request = [GADRequest request];
            //[_adLoader loadRequest:request];
            
            resolve(@[]);
        } else {
            reject(@"E_INVALID_VIEW_CLASS", @"View returned for passed native ad view tag is not an instance of RNGADNativeTemplateView", nil);
            return;
        }
    
    }];
}

RCT_EXPORT_METHOD(initLoader:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject)
{
        NSLog(@"RNAdManager.initLoader");

        _adLoader = [[GADAdLoader alloc]
                         initWithAdUnitID:_adUnitID
                         rootViewController:self
                         adTypes:@[ kGADAdLoaderAdTypeUnifiedNative ]
                         options:nil];        
                         
        _adLoader.delegate = self;
            resolve(@[]);

  
}

RCT_EXPORT_METHOD(requestAd:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject)
{
        NSLog(@"RNAdManager.requestAd");


        _requestAdResolve = resolve;
        _requestAdReject = reject;

        GADRequest *request = [GADRequest request];
        [_adLoader loadRequest:request];
  
}


- (void)startObserving
{
    hasListeners = YES;
}

- (void)stopObserving
{
    hasListeners = NO;
}

#pragma mark GADUnifiedNativeAdLoaderDelegate

- (void)adLoader:(GADAdLoader *)adLoader didFailToReceiveAdWithError:(GADRequestError *)error 
{
    if (hasListeners) {
        NSDictionary *jsError = RCTJSErrorFromCodeMessageAndNSError(@"E_AD_REQUEST_FAILED", error.localizedDescription, error);
        [self sendEventWithName:kEventAdFailedToLoad body:jsError];
    }
    _requestAdReject(nil);
}
    
- (void)adLoader:(GADAdLoader *)adLoader didReceiveUnifiedNativeAd:(GADUnifiedNativeAd *)nativeAd 
{
    if (hasListeners) {
 NSUInteger* adCount = [nativeAds count];
        NSString *text = [NSString stringWithFormat:@"%li",adCount];
        [self sendEventWithName:kEventAdLoaded body:@{@"adCount":text}];
    }
    [nativeAds addObject: nativeAd];

    _requestAdResolve(nil);
}

@end
