import React from 'react';
import { requireNativeComponent, ViewPropTypes, NativeModules } from 'react-native';
import { string } from 'prop-types';
console.log('admobnative', NativeModules);

RNAdMobNativeAdView = requireNativeComponent('RNAdMobNativeAdView', NativeAdView);

NativeAdView = props => {
  return <RNAdMobNativeAdView {...props} />;
};

NativeAdView.propTypes = {
  ...ViewPropTypes,
  adUnitId: string.isRequired
};

export default NativeAdView;
