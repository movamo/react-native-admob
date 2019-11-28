import React, { useRef, useState, useEffect } from "react";
import { UIManager, findNodeHandle } from "react-native";
import NativeAdView from "./RNNativeAdView";

const withNativeAd = Component => ({ adUnitId, adManager, ...props }) => {
  const adContainerRef = useRef(null);

  const [adProps, setAdProps] = useState({});
  useEffect(() => {
    if (adContainerRef.current) {
      adManager
        .registerView(findNodeHandle(adContainerRef.current), adUnitId)
        .then(adValue => {
          setAdProps(adValue);
          adManager.requestAd(adUnitId);
        });
    }
  }, [adManager, adUnitId]);

  return (
    <NativeAdView ref={adContainerRef}>
      <Component {...props} {...adProps}></Component>
    </NativeAdView>
  );
};

export default withNativeAd;
