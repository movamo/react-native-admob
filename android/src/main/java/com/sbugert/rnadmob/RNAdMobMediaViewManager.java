package com.sbugert.rnadmob;

import android.content.Context;
import android.view.View;

import com.facebook.react.uimanager.ThemedReactContext;
import com.facebook.react.uimanager.ViewGroupManager;
import com.google.android.gms.ads.formats.MediaView;


class RNMediaView extends MediaView{
    public RNMediaView(Context context){
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

public class RNAdMobMediaViewManager extends ViewGroupManager<RNMediaView> {
    public static final String REACT_CLASS = "MediaView";

    @Override
    public String getName(){
        return REACT_CLASS;
    }

    @Override
    public RNMediaView createViewInstance(ThemedReactContext context){
        RNMediaView mediaView = new RNMediaView(context);
        return mediaView;
    }

    @Override
    public boolean needsCustomLayoutForChildren() {
        return true;
    }
}
