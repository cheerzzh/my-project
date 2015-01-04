package com.demo.zhouc.cardboarddemo;

import android.app.Activity;
import android.content.Context;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.graphics.Color;
import android.graphics.Matrix;
import android.graphics.Point;
import android.os.Bundle;
import android.os.Vibrator;
import android.util.Log;
import android.view.Display;
import android.view.MotionEvent;
import android.view.View;
import android.view.Window;
import android.view.WindowManager;
import android.widget.ImageView;

import com.google.vrtoolkit.cardboard.CardboardActivity;

/**
 * Created by zhouc & xtao on 14-11-4.
 */
public class ImageCardboard extends CardboardActivity {

    private Matrix leftOriginalMatrix;
    private Matrix rightOriginalMatrix;

    private ImageView imgViewL;
    private ImageView imgViewR;

    private Vibrator vibrator;
    //public static int index = 0;
    //private Vibrator mVibrator;

    int index = 0;
    int[] resLeft = {
            R.drawable.left_sample,
            R.drawable.left1,
            R.drawable.left2,
            R.drawable.left3,
            R.drawable.left4,
            R.drawable.left5
    };

    int[] resRight = {
            R.drawable.right_sample,
            R.drawable.right1,
            R.drawable.right2,
            R.drawable.right3,
            R.drawable.right4,
            R.drawable.right5
    };

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);


        //remove title bar
//        this.requestWindowFeature(Window.FEATURE_NO_TITLE);

        // remove notification bar
        this.getWindow().setFlags(WindowManager.LayoutParams.FLAG_FULLSCREEN, WindowManager.LayoutParams.FLAG_FULLSCREEN);

        // set content view
        setContentView(R.layout.activity_image_cardboard);

        imgViewL   = (ImageView) findViewById(R.id.iv_left);
        imgViewR  = (ImageView) findViewById(R.id.iv_right);
        leftOriginalMatrix = new Matrix(imgViewL.getImageMatrix());
        rightOriginalMatrix = new Matrix(imgViewR.getImageMatrix());

        imgViewL.setOnTouchListener(listener);
        imgViewR.setOnTouchListener(listener);

        vibrator = (Vibrator) getSystemService(Context.VIBRATOR_SERVICE);


        // initialize imageview
        //initImageView(R.drawable.left1, R.drawable.right1);
    }

    @Override
    public void onCardboardTrigger() {
        initImageView(resLeft[index], resRight[index]);
        index = (index + 1) % 6;

        vibrator.vibrate(50);
    }

    private View.OnTouchListener listener = new View.OnTouchListener() {

        @Override
        public boolean onTouch(View view, MotionEvent event) {

            int action = event.getActionMasked();
            Log.i("CardView", action+"");
            if (action == MotionEvent.ACTION_DOWN) {
                initImageView(resLeft[index], resRight[index]);
                index = (index + 1) % 6;
            }
            return true;
        }
    };

    private void initImageView(int leftRes, int rightRes) {

        imgViewL.setImageBitmap(null);
        imgViewR.setImageBitmap(null);
        // load 2 images
        //String sdPath   = Environment.getExternalStorageDirectory().getAbsolutePath(); // SD card location
       // File imgL    = new File( sdPath + File.separator + mStoragePath + File.separator + mLeftImageName );
        //File imgR   = new File( sdPath + File.separator + mStoragePath + File.separator + mRightImageName );

        //File imgL    = new File( mStoragePath + File.separator + mLeftImageName );
        //File imgR   = new File( mStoragePath + File.separator + mRightImageName );


        // save 2 images into bitmap
//        Bitmap bmL  = BitmapFactory.decodeFile( imgL.getAbsolutePath() );
//        Bitmap bmR  = BitmapFactory.decodeFile( imgR.getAbsolutePath() );

        Bitmap bmL = BitmapFactory.decodeResource(getResources(), leftRes);
        Bitmap bmR = BitmapFactory.decodeResource(getResources(), rightRes);

        // get height and width of images
        float imgL_h = bmL.getHeight();
        float imgL_w = bmL.getWidth();
        float imgR_h = bmR.getHeight();
        float imgR_w = bmR.getWidth();

        // get height and width of imageview
        Display d = getWindowManager().getDefaultDisplay();
        Point szScreen = new Point();
        d.getSize(szScreen);
        float imgViewL_h = szScreen.y;
        float imgViewL_w = szScreen.x / 2;
        float imgViewR_h = szScreen.y;
        float imgViewR_w = szScreen.x / 2;



        // set scale and translation of 2 images
        Matrix matrixL =  new Matrix(leftOriginalMatrix);
        Matrix matrixR =  new Matrix(rightOriginalMatrix);

        //float scaleL = 1.0f*Math.min( 1.0f*imgViewL_h/imgL_h, 1.0f*imgViewL_w/imgL_w );
        float scaleL = 0.78f* 1.0f*imgViewL_h/imgL_h;
        //float scaleR = 1.0f*Math.min( 1.0f*imgViewR_h/imgR_h, 1.0f*imgViewR_w/imgR_w );
        float scaleR = 0.78f*1.0f*imgViewR_h/imgR_h;
        matrixL.postScale( scaleL, scaleL );
        matrixR.postScale( scaleR, scaleR );
        // how to auto place the image in the center
        matrixL.postTranslate( 60, 80 );
        matrixR.postTranslate( 60, 80 );

        // display images inside the imageview
        imgViewL.setImageBitmap(bmL);
        imgViewR.setImageBitmap(bmR);
        bmL = null;
        bmR = null;

        //imgViewL.setImageResource(R.drawable.left1);
        //imgViewR.setImageResource(R.drawable.right1);

        // using matrix to control scale and translation of images
        imgViewL.setImageMatrix(matrixL);
        imgViewR.setImageMatrix(matrixR);
        imgViewL.setScaleType(ImageView.ScaleType.MATRIX); //
        imgViewR.setScaleType(ImageView.ScaleType.MATRIX);

        // set imageview background color
        imgViewL.setBackgroundColor(Color.rgb(0,0,0));
        imgViewR.setBackgroundColor(Color.rgb(0,0,0));


    }
}
