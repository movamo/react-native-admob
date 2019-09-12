package com.sbugert.rnadmob;

import androidx.annotation.Nullable;

import com.facebook.react.bridge.Promise;
import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;
import com.facebook.react.bridge.ReactMethod;
import com.facebook.react.bridge.WritableMap;
import com.facebook.react.modules.core.DeviceEventManagerModule;
import com.google.android.gms.ads.AdListener;
import com.google.android.gms.ads.AdRequest;
import com.google.android.gms.ads.AdLoader;
import com.google.android.gms.ads.formats.NativeAdOptions;
import com.google.android.gms.ads.formats.UnifiedNativeAd;

public class RNAdManagerModule extends ReactContextBaseJavaModule {

    public static final String REACT_CLASS = "RNAdManger";

    public static final String EVENT_ADS_LOADED = "nativeAdsLoaded";
    public static final String EVENT_ADS_FAILED_TO_LOAD = "nativeAdsFailedToLoad";

    private UnifiedNativeAd nativeAd;
    String adUnitID;
    int adsToRequest;
    AdLoader adLoader;
    private Promise mRequestAdPromise;

    @Override
    public String getName() {
        return REACT_CLASS;
    }

    public RNAdManagerModule(ReactApplicationContext reactContext) {
        super(reactContext);
    }

    @ReactMethod
    public void init(String adUnitID, int adsToRequest){
        final ReactApplicationContext reactContext = this.getReactApplicationContext();
        this.adUnitID = adUnitID;
        this.adsToRequest = adsToRequest;

        this.adLoader = new AdLoader.Builder(reactContext, adUnitID)
            .forUnifiedNativeAd(new UnifiedNativeAd.OnUnifiedNativeAdLoadedListener() {
                 @Override
                public void onUnifiedNativeAdLoaded(UnifiedNativeAd unifiedNativeAd) {
                    // Show the ad.
                    nativeAd = unifiedNativeAd;
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
