import React, { useState, useEffect } from 'react';

import { NativeModules, NativeEventEmitter } from 'react-native';

import { createErrorFromErrorData } from './utils';

const RNAdManager = NativeModules.RNAdManager;
const eventEmitter = new NativeEventEmitter(RNAdManager);

const useAdManager = adUnitId => {
  const [hasAds, setHasAds] = useState(false);
  const [numAds, setNumAds] = useState(0);

  useEffect(() => {
    // console.log('AdManager.init', adUnitId);
    RNAdManager.initLoader(adUnitId).then(resp => {
      // console.log('AdManager.response', adUnitId);
      RNAdManager.requestAd(adUnitId);
    });
  }, []);

  useEffect(() => {
    // console.log('AdManager.initAdloadlistener', adUnitId);
    function onAdLoaded({ adCount, adUnitId: respAdUnitId }) {
      // console.log('aduinitid', respAdUnitId);
      if (respAdUnitId === adUnitId) {
        //  console.log('AdManager.nativeAdLoaded', adCount);
        setNumAds(parseInt(adCount));
        setHasAds(true);
      }
    }
    const listener = eventEmitter.addListener('nativeAdLoaded', onAdLoaded);

    return () => listener.remove();
  }, [eventEmitter]);

  useEffect(() => {
    // console.log('AdManager.initAdfaillistener', adUnitId);

    const listener = eventEmitter.addListener('nativeAdFailedToLoad', error => {
      //  console.log('AdManager.nativeAdFailedToLoad', error);
    });

    return () => listener.remove();
  }, [eventEmitter]);

  return { hasAds, numAds, adManager: RNAdManager };
};

export default useAdManager;
