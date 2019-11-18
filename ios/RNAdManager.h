#if __has_include(<React/RCTBridgeModule.h>)
#import <React/RCTBridgeModule.h>
#import <React/RCTEventEmitter.h>
#else
#import "RCTBridgeModule.h"
#import "RCTEventEmitter.h"
#endif

@interface RNAdManager : RCTEventEmitter <RCTBridgeModule>
- (void)sendEvent:(NSString*)eventName body:(NSString*)body;
@end
