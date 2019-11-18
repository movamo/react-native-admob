#import "RNAdManager.h"
#import "RNAdMobUtils.h"

#if __has_include(<React/RCTUtils.h>)
#import <React/RCTUtils.h>
#else
#import "RCTUtils.h"
#endif
#import <React/RCTUIManager.h>

#import "RNGADNativeTemplateView.h"
#import "AdLoader.h"

static NSString *const kEventAdLoaded = @"nativeAdLoaded";
static NSString *const kEventAdFailedToLoad = @"nativeAdFailedToLoad";

@implementation RNAdManager
{
    NSMutableDictionary<NSString*,AdLoader*>*_adLoaders;
    BOOL hasListeners;
}

- (instancetype)init
{
        NSLog(@"RNAdManager.init");
    self = [super init];
    if(self) {
        _adLoaders = [NSMutableDictionary new];
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

RCT_EXPORT_METHOD(registerAdView:(nonnull NSString*)adUnitID nativeAdViewTag:(nonnull NSNumber *) nativeAdViewTag resolve:(RCTPromiseResolveBlock)resolve reject:(RCTPromiseRejectBlock)reject)
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

            [_adLoaders[adUnitID] registerAdView:templateView resolve:resolve];

        } else {
            reject(@"E_INVALID_VIEW_CLASS", @"View returned for passed native ad view tag is not an instance of RNGADNativeTemplateView", nil);
            return;
        }
    
    }];
}

RCT_EXPORT_METHOD(initLoader:(NSString*)adUnitID resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject)
{
           NSLog(@"RNAdManager.initLoader");
        AdLoader* loader =[[AdLoader alloc]
                           init:self adUnitID:adUnitID ref:self];  
    [_adLoaders setValue:loader forKey:adUnitID];
             
          resolve(nil);

}

RCT_EXPORT_METHOD(requestAd:(NSString*)adUnitID resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject)
{
        NSLog(@"RNAdManager.requestAd");

        [_adLoaders[adUnitID] requestAd];
        resolve(nil);
  
}


- (void)startObserving
{
    hasListeners = YES;
}

- (void)stopObserving
{
    hasListeners = NO;
}

- (void)sendEvent:(NSString*)eventName body:(NSString*)body
{
    [self sendEventWithName:eventName body:body];
}
@end
