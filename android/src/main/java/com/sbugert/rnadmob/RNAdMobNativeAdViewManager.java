package com.sbugert.rnadmob;

import android.content.Context;
import android.util.Log;
import android.view.View;
import android.view.ViewGroup;

import androidx.annotation.Nullable;

import com.facebook.react.bridge.Arguments;
import com.facebook.react.bridge.ReactContext;
import com.facebook.react.bridge.ReadableArray;
import com.facebook.react.bridge.WritableMap;
import com.facebook.react.common.MapBuilder;
import com.facebook.react.uimanager.ThemedReactContext;
import com.facebook.react.uimanager.ViewGroupManager;
import com.facebook.react.uimanager.annotations.ReactProp;
import com.facebook.react.uimanager.events.RCTEventEmitter;
import com.google.android.gms.ads.AdListener;
import com.google.android.gms.ads.AdLoader;
import com.google.android.gms.ads.AdRequest;
import com.google.android.gms.ads.formats.AdChoicesView;
import com.google.android.gms.ads.formats.MediaView;
import com.google.android.gms.ads.formats.UnifiedNativeAd;
import com.google.android.gms.ads.formats.UnifiedNativeAdView;

import java.util.Map;

import javax.annotation.Nonnull;

public class RNAdMobNativeAdViewManager extends ViewGroupManager<UnifiedNativeAdView> {
    public static final String REACT_CLASS = "RNAdMobNativeAdView";

    public static final String PROP_AD_ID = "adUnitId";

    public static final String EVENT_AD_LOADED = "onAdLoaded";
    public static final String EVENT_AD_LOAD_FAILED = "onAdFailedToLoad";

    public static final int COMMAND_CLICK = 1;

    @Override
    public String getName() {
        return REACT_CLASS;
    }

    @Override
    public UnifiedNativeAdView createViewInstance(ThemedReactContext themedReactContext) {
        UnifiedNativeAdView nativeAdView = new UnifiedNativeAdView(themedReactContext);
        return nativeAdView;
    }

    @Override
    public void onDropViewInstance(@Nonnull UnifiedNativeAdView view) {
        view.destroy();
    }

    @Override
    public void receiveCommand(@Nonnull UnifiedNativeAdView root, int commandId, @javax.annotation.Nullable ReadableArray args) {
        switch (commandId){
            case COMMAND_CLICK:
                root.performClick();
        }
    }

    @javax.annotation.Nullable
    @Override
    public Map<String, Integer> getCommandsMap() {
       return MapBuilder.of("onClick", COMMAND_CLICK);
    }

    @ReactProp(name = PROP_AD_ID)
    public void setAdvertisingId(final UnifiedNativeAdView view, @Nullable String advertisingId) {
        Context context = view.getContext();
        AdLoader loader = new AdLoader.Builder(context, advertisingId).forUnifiedNativeAd(new UnifiedNativeAd.OnUnifiedNativeAdLoadedListener() {
            @Override
            public void onUnifiedNativeAdLoaded(UnifiedNativeAd unifiedNativeAd) {
                onAdLoadEvent(view, unifiedNativeAd);
            }
        }).withAdListener(new AdListener() {
            @Override
            public void onAdFailedToLoad(int errorCode) {
                Log.e("ADS", Integer.toString(errorCode));
                onAdLoadFailedEvent(view);
            }
        }).build();
        loader.loadAd(new AdRequest.Builder().build());
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

    private void onAdLoadEvent(UnifiedNativeAdView view, UnifiedNativeAd ad) {
        MediaView mediaView = getFirstChildOfType(view, MediaView.class);
        if (mediaView != null) {
            view.setMediaView(mediaView);
        }

        WritableMap adInformation = Arguments.createMap();
        adInformation.putString("headline", ad.getHeadline());
        adInformation.putString("callToAction", ad.getCallToAction());
        adInformation.putString("body", ad.getBody());
        adInformation.putString("advertiser", ad.getAdvertiser());
        ReactContext context = (ReactContext) view.getContext();
        context.getJSModule(RCTEventEmitter.class).receiveEvent(view.getId(), EVENT_AD_LOADED, adInformation);
        view.setNativeAd(ad);
        //AdChoicesView can only be set by attaching a native Ad
        AdChoicesView adChoicesView = getFirstChildOfType(view, AdChoicesView.class);
        if (adChoicesView != null) {
            //Measure is hopefully the same everytime
            int width = 39, height = 39;
           adChoicesView.measure(width, height);
           // Measure Parent for the upper right corner
           ViewGroup parent = (ViewGroup) adChoicesView.getParent();
           int right = parent.getRight(), top = parent.getTop();
           adChoicesView.layout(right - width, top, right, top + height);
        }
    }


    private void onAdLoadFailedEvent(UnifiedNativeAdView view) {
        ReactContext context = (ReactContext) view.getContext();
        context.getJSModule(RCTEventEmitter.class).receiveEvent(view.getId(), EVENT_AD_LOAD_FAILED, null);
    }

    @Override
    @Nullable
    public Map<String, Object> getExportedCustomDirectEventTypeConstants() {
        MapBuilder.Builder<String, Object> builder = new MapBuilder().builder();
        String[] events = {EVENT_AD_LOADED, EVENT_AD_LOAD_FAILED};
        for (int i = 0; i < events.length; i++) {
            builder.put(events[i], MapBuilder.of("registrationName", events[i]));
        }
        return builder.build();
    }

    @Override
    public boolean needsCustomLayoutForChildren() {
        return true;
    }
}
