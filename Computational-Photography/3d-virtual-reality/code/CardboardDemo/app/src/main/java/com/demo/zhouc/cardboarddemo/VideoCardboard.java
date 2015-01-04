package com.demo.zhouc.cardboarddemo;

import android.app.Activity;
import android.content.Context;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.graphics.Point;
import android.media.MediaPlayer;
import android.os.Bundle;
import android.os.Environment;
import android.os.Vibrator;
import android.util.Log;
import android.view.Display;
import android.view.MotionEvent;
import android.view.View;
import android.view.Window;
import android.view.WindowManager;
import android.widget.ImageView;
import android.widget.MediaController;
import android.widget.VideoView;

import com.google.vrtoolkit.cardboard.CardboardActivity;

import java.io.File;
import java.io.IOException;

/**
 * Created by zhouc on 14-11-4.
 */
public class VideoCardboard extends CardboardActivity {

    private static final String mStoragePath = "CardBoardDemo";
    private static final String mLeftVideoName = "left.mp4";
    private static final String mRightVideoName = "right.mp4";

    private String[] mLeftVideoNames = {
            "left_static.mp4",
            "left_sub.mp4",
            "left_animate.mp4",
            "left_animate2.mp4",
            "left_animate3.mp4",
            "left_animate4.mp4"
    };
    private String[] mRightVideoNames = {
            "right_static.mp4",
            "right_sub.mp4",
            "right_animate.mp4",
            "right_animate2.mp4",
            "right_animate3.mp4",
            "right_animate4.mp4"
    };

    private VideoView mLeftVideoView;
    private VideoView mRightVideoView;

    private Vibrator vibrator;

    private int index;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

        //Remove title bar
//        this.requestWindowFeature(Window.FEATURE_NO_TITLE);

        //Remove notification bar
        this.getWindow().setFlags(WindowManager.LayoutParams.FLAG_FULLSCREEN, WindowManager.LayoutParams.FLAG_FULLSCREEN);

        setContentView(R.layout.activity_video_cardboard);

        mLeftVideoView = (VideoView) findViewById(R.id.vv_left);
        mRightVideoView = (VideoView) findViewById(R.id.vv_right);
        // initialize videoview



        mLeftVideoView.setOnTouchListener(listener);
        mRightVideoView.setOnTouchListener(listener);

        vibrator = (Vibrator) getSystemService(Context.VIBRATOR_SERVICE);
    }

    @Override
    public void onCardboardTrigger() {
        initVideoView(mLeftVideoNames[index], mRightVideoNames[index]);
        index = (index + 1) % 6;

        vibrator.vibrate(50);
    }

    private View.OnTouchListener listener = new View.OnTouchListener() {

        @Override
        public boolean onTouch(View view, MotionEvent event) {

            int action = event.getActionMasked();
            Log.i("CardView", action + "");
            if (action == MotionEvent.ACTION_DOWN) {
                initVideoView(mLeftVideoNames[index], mRightVideoNames[index]);
                index = (index + 1) % 6;
            }
            return true;
        }
    };

    private void initVideoView(String mLeftVideoName, String mRightVideoName) {

        // load 2 images
        String sdPath = Environment.getExternalStorageDirectory().getAbsolutePath();
        File vidL = new File(sdPath + File.separator + mStoragePath + File.separator + mLeftVideoName);
        File vidR = new File(sdPath + File.separator + mStoragePath + File.separator + mRightVideoName);
        mLeftVideoView.setVideoPath(vidL.getAbsolutePath());
        mRightVideoView.setVideoPath(vidR.getAbsolutePath());

        // set the scale and translation of the video
        // how to change the video player size?
//        float scaleL = 0.7f;
//        float scaleR = 0.7f;
        float scaleL = 0.6f;
        float scaleR = 1.0f;
        float scaleLx = 1.15f;
        float scaleLy = 1.15f;
        float transL_x = 0, transL_y = 0;
        float transR_x = 0 , transR_y =0;

        mLeftVideoView.setScaleX(scaleLx);     mLeftVideoView.setScaleY(scaleLy);
        mRightVideoView.setScaleX(scaleLx);     mRightVideoView.setScaleY(scaleLy);
        mLeftVideoView.setTranslationX(transL_x);
        mLeftVideoView.setTranslationY(transL_y);
        mRightVideoView.setTranslationX(transR_x);
        mRightVideoView.setTranslationY(transR_y);

        // start to play the video
        mLeftVideoView.start();
        mRightVideoView.start();

    }
}
