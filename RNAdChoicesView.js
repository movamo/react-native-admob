import React from 'react';
import { requireNativeComponent, ViewPropTypes } from 'react-native';

const AdChoicesView = props => {
  return <RNGADAdChoicesView {...props} />;
};

AdChoicesView.propTypes = {
  ...ViewPropTypes
};

RNGADAdChoicesView = requireNativeComponent('RNGADAdChoicesView', AdChoicesView);

export default AdChoicesView;
