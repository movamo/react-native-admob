/* eslint-disable global-require */
module.exports = {
  get AdMobBanner() {
    return require('./RNAdMobBanner').default;
  },
  get AdMobInterstitial() {
    return require('./RNAdMobInterstitial').default;
  },
  get PublisherBanner() {
    return require('./RNPublisherBanner').default;
  },
  get AdMobRewarded() {
    return require('./RNAdMobRewarded').default;
  },
  get NativeAdView() {
    return require('./RNNativeAdView').default;
  },
  get MediaView() {
    return require('./RNMediaView').default;
  },
  get AdChoicesView() {
    return require('./RNAdChoicesView').default;
  },
  get NativeTemplateView() {
    return require('./RNNativeTemplateView').default;
  },
  get withNativeAd() {
    return require('./withNativeAd').default;
  },
  get useAdManager() {
    return require('./useAdManager').default;
  },
  get withAdManager() {
    return require('./withAdManager').default;
  }
};
