import React from 'react';
import { requireNativeComponent, ViewPropTypes } from 'react-native';
import { oneOf } from 'prop-types';

const MediaView = props => {
  return <RNMediaView {...props} />;
};

MediaView.propTypes = {
  ...ViewPropTypes,
  resizeMode: oneOf(['cover', 'contain', 'center'])
};

RNMediaView = requireNativeComponent('MediaView', MediaView);

export default MediaView;
