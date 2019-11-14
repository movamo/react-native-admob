import React, { useState, useEffect } from "react";

import { NativeModules, NativeEventEmitter } from "react-native";

import { createErrorFromErrorData } from "./utils";

const RNAdManager = NativeModules.RNAdManager;
const eventEmitter = new NativeEventEmitter(RNAdManager);

const useAdManager = adUnitId => {
  const [hasAds, setHasAds] = useState(false);
  const [numAds, setNumAds] = useState(0);

  useEffect(() => {
    console.log("AdManager.init");
    RNAdManager.setAdUnitID(adUnitId);
    RNAdManager.initLoader().then(resp => {
      console.log("AdManager.response");
      RNAdManager.requestAd();
    });
  }, []);

  useEffect(() => {
    console.log("AdManager.initAdloadlistener");
    function onAdLoaded({ adCount }) {
      console.log("AdManager.nativeAdLoaded", adCount);

      setHasAds(true);
      setNumAds(parseInt(adCount) + 1);
    }
    const listener = eventEmitter.addListener("nativeAdLoaded", onAdLoaded);

    return () => listener.remove();
  }, [eventEmitter]);

  useEffect(() => {
    console.log("AdManager.initAdfaillistener");

    const listener = eventEmitter.addListener("nativeAdFailedToLoad", error => {
      console.log("AdManager.nativeAdFailedToLoad", error);
    });

    return () => listener.remove();
  }, [eventEmitter]);

  return { hasAds, numAds, adManager: RNAdManager };
};

export default useAdManager;
