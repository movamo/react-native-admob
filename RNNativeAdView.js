import React, { Component } from 'react';
import { requireNativeComponent, ViewPropTypes } from 'react-native';
import { string, func } from 'prop-types';

class NativeAdView extends Component {
  constructor() {
    super();
    this.state = {
      style: {}
    };
  }

  render() {
    return (
      <RNGADUnifiedNativeAdView {...this.props} style={[this.props.style, this.state.style]} />
    );
  }
}

NativeAdView.propTypes = {
  ...ViewPropTypes,
  /**
   * AdMob ad unit ID
   */
  adUnitID: string,

  onAdLoaded: func,
  onAdFailedToLoad: func,
  onAdOpened: func,
  onAdClosed: func,
  onAdLeftApplication: func
};

const RNGADUnifiedNativeAdView = requireNativeComponent('RNGADUnifiedNativeAdView', NativeAdView);

export default NativeAdView;
