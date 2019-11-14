import React, { useRef, useEffect } from "react";
import {
  requireNativeComponent,
  ViewPropTypes,
  findNodeHandle
} from "react-native";
import { func } from "prop-types";

NativeTemplateView = ({ adManager, ...props }) => {
  const adViewRef = useRef(null);
  console.log("NativeTemplateView", findNodeHandle(adViewRef.current));
  useEffect(() => {
    if (adManager && adViewRef && adViewRef.current) {
      console.log("NativeTemplateView.useEffect", adViewRef.current);

      adManager.registerAdView(findNodeHandle(adViewRef.current)).then(resp => {
        console.log("NativeTemplateView.response");
        console.log("AdManager.requestAd");
        adManager.requestAd();
      });
    }
  }, [adManager, adViewRef]);

  return <RNGADNativeTemplateView {...props} ref={adViewRef} />;
};

NativeTemplateView.propTypes = {
  ...ViewPropTypes,
  onAdOpened: func,
  onAdClosed: func,
  onAdLeftApplication: func
};

const RNGADNativeTemplateView = requireNativeComponent(
  "RNGADNativeTemplateView",
  NativeTemplateView
);

export default NativeTemplateView;
