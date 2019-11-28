import React, { forwardRef } from "react";
import { requireNativeComponent, ViewPropTypes } from "react-native";
import { string, func } from "prop-types";

NativeAdView = ({ forwardedRef, ...props }) => {
  return <RNAdMobNativeAdView {...props} ref={forwardedRef} />;
};

NativeAdView.propTypes = {
  ...ViewPropTypes,
  adUnitId: string.isRequired,
  onAdLoaded: func,
  onAdFailedToLoad: func
};

const RNAdMobNativeAdView = requireNativeComponent(
  "RNAdMobNativeAdView",
  NativeAdView
);

export default forwardRef((props, ref) => (
  <NativeAdView forwardedRef={ref} {...props} />
));
