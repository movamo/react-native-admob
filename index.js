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
    return require("./RNAdChoicesView").default;
  }
};
