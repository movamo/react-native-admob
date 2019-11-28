package com.sbugert.rnadmob;

import android.view.View;
import android.view.ViewGroup;

import androidx.annotation.Nullable;

import com.facebook.react.bridge.Arguments;
import com.facebook.react.bridge.Promise;
import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;
import com.facebook.react.bridge.ReactMethod;
import com.facebook.react.bridge.UIManager;
import com.facebook.react.bridge.WritableMap;
import com.facebook.react.modules.core.DeviceEventManagerModule;
import com.facebook.react.uimanager.NativeViewHierarchyManager;
import com.facebook.react.uimanager.UIBlock;
import com.facebook.react.uimanager.UIManagerModule;
import com.facebook.react.uimanager.events.RCTEventEmitter;
import com.facebook.react.uimanager.util.ReactFindViewUtil;
import com.google.android.gms.ads.AdListener;
import com.google.android.gms.ads.AdRequest;
import com.google.android.gms.ads.AdLoader;
import com.google.android.gms.ads.formats.AdChoicesView;
import com.google.android.gms.ads.formats.MediaView;
import com.google.android.gms.ads.formats.NativeAdOptions;
import com.google.android.gms.ads.formats.UnifiedNativeAd;
import com.google.android.gms.ads.formats.UnifiedNativeAdView;

import java.lang.reflect.Array;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.WeakHashMap;


public class RNAdManagerModule extends ReactContextBaseJavaModule {

    public static final String REACT_CLASS = "RNAdManager";

    public static final String EVENT_ADS_LOADED = "nativeAdLoaded";
    public static final String EVENT_ADS_FAILED_TO_LOAD = "nativeAdFailedToLoad";

    private HashMap<String, ArrayList<UnifiedNativeAd>> loadedAds = new HashMap<>();

    @Override
    public String getName() {
        return REACT_CLASS;
    }

    public RNAdManagerModule(ReactApplicationContext reactContext) {
        super(reactContext);
    }

    private void sendEvent(String eventName, @Nullable WritableMap params) {
        getReactApplicationContext().getJSModule(DeviceEventManagerModule.RCTDeviceEventEmitter.class).emit(eventName, params);
    }

    @ReactMethod
    public void requestAd(final String adUnitId) {
        AdLoader adLoader = new AdLoader.Builder(this.getReactApplicationContext(), adUnitId).forUnifiedNativeAd(new UnifiedNativeAd.OnUnifiedNativeAdLoadedListener() {
            @Override
            public void onUnifiedNativeAdLoaded(UnifiedNativeAd unifiedNativeAd) {
                addLoadedAd(unifiedNativeAd, adUnitId);
                ArrayList<UnifiedNativeAd> ads = loadedAds.get(adUnitId);
                WritableMap result = Arguments.createMap();
                result.putInt("numAds", ads.size());
                result.putString("adUnitId", adUnitId);
                sendEvent(EVENT_ADS_LOADED, result);
            }
        }).withAdListener(new AdListener() {
            @Override
            public void onAdFailedToLoad(int i) {
                String message = "";
                switch (i) {
                    case AdRequest.ERROR_CODE_INTERNAL_ERROR:
                        message = "Internal Error";
                        break;
                    case AdRequest.ERROR_CODE_INVALID_REQUEST:
                        message = "Invalid Request";
                        break;
                    case AdRequest.ERROR_CODE_NO_FILL:
                        message = "No Ad was found";
                        break;
                    case AdRequest.ERROR_CODE_NETWORK_ERROR:
                        message = "Server could not be reached";
                }
                WritableMap map = Arguments.createMap();
                map.putString("message", message);
                map.putString("adUnitId", adUnitId);
                map.putInt("errorCode", i);
                sendEvent(EVENT_ADS_FAILED_TO_LOAD, map);
            }
        }).withNativeAdOptions(new NativeAdOptions.Builder().build()).build();
       adLoader.loadAd(new AdRequest.Builder().build());
    }

    @ReactMethod
    public void registerView(final int nativeViewTag, final String adUnitId, final Promise promise){
        ReactApplicationContext context  = this.getReactApplicationContext();
        UIManagerModule uiManagerModule = context.getNativeModule(UIManagerModule.class);

        uiManagerModule.addUIBlock(new UIBlock() {
            @Override
            public void execute(NativeViewHierarchyManager nativeViewHierarchyManager) {
                try {
                    UnifiedNativeAdView view = (UnifiedNativeAdView) nativeViewHierarchyManager.resolveView(nativeViewTag);
                    WritableMap information = inflateAdView(view, adUnitId);
                    promise.resolve(information);
                } catch ( Exception e){
                    promise.reject("Error", e);
                    return;
                }

            }
        });
    }

    private WritableMap inflateAdView(UnifiedNativeAdView view, String adUnitId) {
        ArrayList<UnifiedNativeAd> ads = loadedAds.get(adUnitId);
        UnifiedNativeAd ad = ads.get(ads.size() -1);

        MediaView mediaView = getFirstChildOfType(view, MediaView.class);
        if (mediaView != null) {
            view.setMediaView(mediaView);
        }

        WritableMap adInformation = Arguments.createMap();
        adInformation.putString("headline", ad.getHeadline());
        adInformation.putString("callToAction", ad.getCallToAction());
        adInformation.putString("body", ad.getBody());
        adInformation.putString("advertiser", ad.getAdvertiser());
        view.setNativeAd(ad);
        //Set Ad First or the Click-Events are getting mismatched.
        view.setHeadlineView(ReactFindViewUtil.findView(view, "Headline"));
        view.setBodyView(ReactFindViewUtil.findView(view, "Body"));
        view.setCallToActionView(ReactFindViewUtil.findView(view, "CallToAction"));
        //AdChoicesView can only be set by attaching a native Ad
        AdChoicesView adChoicesView = getFirstChildOfType(view, AdChoicesView.class);
        if (adChoicesView != null) {
            //Measure is hopefully the same everytime
            ViewGroup parent = (ViewGroup) adChoicesView.getParent();
            adChoicesView.measure(View.MeasureSpec.makeMeasureSpec(parent.getMeasuredWidth(), View.MeasureSpec.EXACTLY),
                    View.MeasureSpec.makeMeasureSpec(parent.getMeasuredHeight(), View.MeasureSpec.EXACTLY));
            // Measure Parent for the upper right corner

            adChoicesView.layout(0, 0, adChoicesView.getMeasuredWidth(), adChoicesView.getMeasuredHeight());
        }
        return adInformation;
    }

    @javax.annotation.Nullable
    private <T extends View> T getFirstChildOfType(ViewGroup view, Class<T> type) {
        int numOfChilds = view.getChildCount();
        for (int i = 0; i < numOfChilds; i++) {
            View child = view.getChildAt(i);
            if (type.isAssignableFrom(child.getClass())) {
                return (T) child;
            }
            if (child instanceof ViewGroup) {
                View potentialChild = getFirstChildOfType((ViewGroup) child, type);
                if (potentialChild != null) {
                    return (T) potentialChild;
                }
            }
        }
        return null;
    }

    private void addLoadedAd(UnifiedNativeAd ad, String adUnitId) {
        if (!loadedAds.containsKey(adUnitId)) {
            loadedAds.put(adUnitId, new ArrayList<UnifiedNativeAd>());
        }
        loadedAds.get(adUnitId).add(ad);
    }

}
