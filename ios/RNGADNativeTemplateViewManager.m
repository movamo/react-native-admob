#import "RNGADNativeTemplateViewManager.h"
#import "RNGADNativeTemplateView.h"
#import "RCTConvert+GADAdSize.h"


#if __has_include(<React/RCTBridge.h>)
#import <React/RCTBridge.h>
#import <React/RCTUIManager.h>
#import <React/RCTEventDispatcher.h>
#else
#import "RCTBridge.h"
#import "RCTUIManager.h"
#import "RCTEventDispatcher.h"
#endif

@implementation RNGADNativeTemplateViewManager

RCT_EXPORT_MODULE();

- (UIView *)view
{
    return [RNGADNativeTemplateView new];
}

RCT_EXPORT_VIEW_PROPERTY(adId, NSString)
RCT_EXPORT_VIEW_PROPERTY(adType, NSString)

RCT_EXPORT_VIEW_PROPERTY(onSizeChange, RCTBubblingEventBlock)
RCT_EXPORT_VIEW_PROPERTY(onAdLoaded, RCTBubblingEventBlock)
RCT_EXPORT_VIEW_PROPERTY(onAdFailedToLoad, RCTBubblingEventBlock)
RCT_EXPORT_VIEW_PROPERTY(onAdOpened, RCTBubblingEventBlock)
RCT_EXPORT_VIEW_PROPERTY(onAdClosed, RCTBubblingEventBlock)
RCT_EXPORT_VIEW_PROPERTY(onAdLeftApplication, RCTBubblingEventBlock)

@end
