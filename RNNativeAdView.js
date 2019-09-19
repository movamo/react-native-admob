import React from 'react';
import { requireNativeComponent, ViewPropTypes } from 'react-native';
import { string } from 'prop-types';

NativeAdView = props => {
  return <RNAdMobNativeAdView {...props} />;
};

NativeAdView.propTypes = {
  ...ViewPropTypes,
  adUnitId: string.isRequired
};

RNAdMobNativeAdView = requireNativeComponent('RNAdMobNativeAdView', NativeAdView);

export default NativeAdView;
