package com.sbugert.rnadmob;

import android.os.Handler;
import android.os.Looper;
import android.support.annotation.Nullable;

import com.facebook.react.bridge.Arguments;
import com.facebook.react.bridge.Callback;
import com.facebook.react.bridge.Promise;
import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;
import com.facebook.react.bridge.ReactMethod;
import com.facebook.react.bridge.ReadableArray;
import com.facebook.react.bridge.ReadableNativeArray;
import com.facebook.react.bridge.WritableMap;
import com.facebook.react.bridge.WritableArray;
import com.facebook.react.modules.core.DeviceEventManagerModule;
import com.google.android.gms.ads.AdListener;
import com.google.android.gms.ads.AdRequest;
import com.google.android.gms.ads.InterstitialAd;
import com.google.android.gms.ads.AdLoader;
import com.google.android.gms.ads.formats.UnifiedNativeAd;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.Map;

public class RNAdManger extends ReactContextBaseJavaModule {

    public static final String REACT_CLASS = "RNAdManger";

    public static final String EVENT_ADS_LOADED = "nativeAdsLoaded";
    public static final String EVENT_ADS_FAILED_TO_LOAD = "nativeAdsFailedToLoad";

    UnifiedNativeAd nativeAd;
    String adUnitID;
    int adsToRequest;
    AdLoader adLoader;
    private Promise mRequestAdPromise;

    @Override
    public String getName() {
        return REACT_CLASS;
    }

    public RNAdManagerAdModule(ReactApplicationContext reactContext) {
        super(reactContext);
    }

    @ReactMethod
    public void init(String adUnitID, int adsToRequest){
        this.adUnitID = adUnitID;
        this.adsToRequest = adsToRequest;

        this.adLoader = new AdLoader.Builder(context, adUnitID)
            .forUnifiedNativeAd(new UnifiedNativeAd.OnUnifiedNativeAdLoadedListener() {
                 @Override
                public void onUnifiedNativeAdLoaded(UnifiedNativeAd unifiedNativeAd) {
                    // Show the ad.
                    this.nativeAd=unifiedNativeAd;
                sendEvent(EVENT_ADS_LOADED,null);
                }
            })
            .withAdListener(new AdListener() {
                @Override
                public void onAdFailedToLoad(int errorCode) {
                    // Handle the failure by logging, altering the UI, and so on.
                                    sendEvent(EVENT_ADS_FAILED_TO_LOAD,null);

                }
            })
            .withNativeAdOptions(new NativeAdOptions.Builder()
                    // Methods in the NativeAdOptions.Builder class can be
                // used here to specify individual options settings.
                .build())
            .build();

    }

    private void sendEvent(String eventName, @Nullable WritableMap params) {
        getReactApplicationContext().getJSModule(DeviceEventManagerModule.RCTDeviceEventEmitter.class).emit(eventName, params);
    }

    @ReactMethod
    public void loadAd() {
        this.adLoader.loadAd(new AdRequest.Builder().build());
    }

}
