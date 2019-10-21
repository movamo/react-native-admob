import React, { Component } from 'react';
import { requireNativeComponent, ViewPropTypes } from 'react-native';
import { string, func } from 'prop-types';

class NativeTemplateView extends Component {
  constructor() {
    super();
    this.handleAdFailedToLoad = this.handleAdFailedToLoad.bind(this);
    this.state = {
      style: {}
    };
  }

  handleAdFailedToLoad(event) {
    if (this.props.onAdFailedToLoad) {
      this.props.onAdFailedToLoad(createErrorFromErrorData(event.nativeEvent.error));
    }
  }

  render() {
    return (
      <RNGADNativeTemplateView
        {...this.props}
        style={[this.props.style, this.state.style]}
        onAdFailedToLoad={this.handleAdFailedToLoad}
        onSizeChange={this.handleSizeChange}
      />
    );
  }
}

NativeTemplateView.propTypes = {
  ...ViewPropTypes,
  onAdLoaded: func,
  onAdFailedToLoad: func,
  onAdOpened: func,
  onAdClosed: func,
  onAdLeftApplication: func
};

const RNGADNativeTemplateView = requireNativeComponent(
  'RNGADNativeTemplateView',
  NativeTemplateView
);

export default NativeTemplateView;
