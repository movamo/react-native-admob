import React, { useState, useEffect, useRef } from "react";

import { NativeModules, NativeEventEmitter, View } from "react-native";

import { createErrorFromErrorData } from "./utils";

const RNAdManager = NativeModules.RNAdManager;
const eventEmitter = new NativeEventEmitter(RNAdManager);

const withAdManager = adUnitId => Component => props => {
  const [hasAds, setHasAds] = useState(false);
  const [numAds, setNumAds] = useState(0);
  console.log("AdManager.render", hasAds, numAds);

  useEffect(() => {
    console.log("AdManager.initAdloadlistener");
    const listener = eventEmitter.addListener("nativeAdLoaded", function jo(
      response
    ) {
      console.log("AdManager.nativeAdLoaded", response);
      setHasAds(true);
      setNumAds(numAds + 1);
    });

    return () => listener.remove();
  }, [eventEmitter]);

  useEffect(() => {
    console.log("AdManager.initAdfaillistener");
    eventEmitter.addListener("nativeAdFailedToLoad", error => {
      console.log(
        "AdManager.nativeAdFailedToLoad",
        createErrorFromErrorData(error)
      );
    });

    return () => eventEmitter.remove("nativeAdFailedToLoad");
  }, []);

  useEffect(() => {
    console.log("AdManager.init");
    RNAdManager.setAdUnitID(adUnitId);
    RNAdManager.initLoader().then(resp => {
      console.log("AdManager.response");
      RNAdManager.requestAd();
    });
  }, []);

  return (
    <View style={{ flex: 1 }}>
      <Component
        {...props}
        hasAds={hasAds}
        numAds={numAds}
        adManager={RNAdManager}
        // onAdLoaded={onAdLoaded}
        //onAdFailedToLoad={onAdFailedToLoad}
      ></Component>
    </View>
  );
};

export default withAdManager;
