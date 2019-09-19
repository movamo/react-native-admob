package com.sbugert.rnadmob;

import android.content.Context;
import android.view.View;

import com.facebook.react.uimanager.ThemedReactContext;
import com.facebook.react.uimanager.ViewGroupManager;
import com.google.android.gms.ads.formats.AdChoicesView;

import javax.annotation.Nonnull;

class RNAdChoicesView extends AdChoicesView{
    public RNAdChoicesView(Context context){
        super(context);
    }

    @Override
    public void addView(View view){
        super.addView(view);
        int height = this.getMeasuredHeight();
        int width = this.getMeasuredWidth();
        int left = this.getLeft();
        int top= this.getTop();
        view.measure(height, width);
        view.layout(left, top, left + width, top + height);
    }
}

public class RNAdMobAdChoicesViewManager extends ViewGroupManager<RNAdChoicesView> {
    public final static String REACT_CLASS = "AdChoicesView";


    @Override
    public boolean needsCustomLayoutForChildren() {
        return true;
    }

    @Nonnull
    @Override
    public String getName() {
        return REACT_CLASS;
    }

    @Nonnull
    @Override
    protected RNAdChoicesView createViewInstance(@Nonnull ThemedReactContext reactContext) {
        return new RNAdChoicesView(reactContext);
    }
}
