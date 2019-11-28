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
import com.facebook.react.uimanager.util.ReactFindViewUtil;
import com.google.android.gms.ads.AdListener;
import com.google.android.gms.ads.AdLoader;
import com.google.android.gms.ads.AdRequest;
import com.google.android.gms.ads.formats.AdChoicesView;
import com.google.android.gms.ads.formats.MediaView;
import com.google.android.gms.ads.formats.UnifiedNativeAd;
import com.google.android.gms.ads.formats.UnifiedNativeAdView;

import java.util.EventListener;
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
        final UnifiedNativeAdView nativeAdView = new UnifiedNativeAdView(themedReactContext);
        return nativeAdView;
    }

    @Override
    public void onDropViewInstance(@Nonnull UnifiedNativeAdView view) {
        view.destroy();
    }

    @javax.annotation.Nullable
    @Override
    public Map<String, Integer> getCommandsMap() {
        return MapBuilder.of("onClick", COMMAND_CLICK);
    }

    @Override
    public boolean needsCustomLayoutForChildren() {
        return true;
    }
}
