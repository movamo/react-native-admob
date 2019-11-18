import React from 'react';
import useAdManager from './useAdManager';

const withAdManager = adUnitId => Component => props => {
  const adProps = useAdManager(adUnitId);

  return <Component {...props} {...adProps}></Component>;
};

export default withAdManager;
