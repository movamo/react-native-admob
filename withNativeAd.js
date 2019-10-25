import React, { useRef, useState, useCallback } from 'react';
import { UIManager, findNodeHandle } from 'react-native';
import NativeAdView from './RNNativeAdView';

const withNativeAd = adUnitId => Component => props => {
  const adContainerRef = useRef(null);

  const [adProps, setAdProps] = useState({});

  const registerClick = () => {
    console.log('Container', adContainerRef.current);
    if (adContainerRef.current) {
      UIManager.dispatchViewManagerCommand(
        findNodeHandle(adContainerRef.current),
        UIManager.getViewManagerConfig('RNAdMobNativeAdView').Commands.onClick,
        null
      );
    }
  };

  return (
    <NativeAdView
      adUnitId={adUnitId}
      onAdLoaded={({ nativeEvent }) => setAdProps(nativeEvent)}
      ref={adContainerRef}
    >
      <Component {...props} {...adProps} onClick={registerClick}></Component>
    </NativeAdView>
  );
};

export default withNativeAd;
