package com.sbugert.rnadmob;

import android.content.Context;
import android.view.View;
import android.widget.ImageView;

import com.facebook.react.uimanager.ThemedReactContext;
import com.facebook.react.uimanager.ViewGroupManager;
import com.facebook.react.uimanager.annotations.ReactProp;
import com.google.android.gms.ads.formats.MediaView;


class RNMediaView extends MediaView {
    public RNMediaView(Context context) {
        super(context);

    }

    @Override
    public void addView(View view) {
        super.addView(view);
        int height = this.getMeasuredHeight();
        int width = this.getMeasuredWidth();
        int left = this.getLeft();
        int top = this.getTop();
        view.measure(height, width);
        view.layout(left, top, left + width, top + height);
    }

}

public class RNAdMobMediaViewManager extends ViewGroupManager<RNMediaView> {
    public static final String REACT_CLASS = "MediaView";

    public static final String PROP_IMAGE_SCALE = "resizeMode";

    @Override
    public String getName() {
        return REACT_CLASS;
    }

    @Override
    public RNMediaView createViewInstance(ThemedReactContext context) {
        RNMediaView mediaView = new RNMediaView(context);
        return mediaView;
    }

    @ReactProp(name = PROP_IMAGE_SCALE)
    public void setImageScale(RNMediaView view, String imageScale) {
        view.setImageScaleType(getScaleTypeFromString(imageScale));
    }

    private ImageView.ScaleType getScaleTypeFromString(String type) {
        switch (type) {
            case "center":
                return ImageView.ScaleType.CENTER;
            case "cover":
                return ImageView.ScaleType.CENTER_CROP;
            default:
                return ImageView.ScaleType.CENTER_INSIDE;
        }
    }

    @Override
    public boolean needsCustomLayoutForChildren() {
        return true;
    }
}
