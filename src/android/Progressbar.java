package de.fastr.phonegap.plugins;

import android.app.Activity;
import android.util.Log;
import android.view.ViewGroup;
import android.webkit.WebView;

import org.apache.cordova.CordovaInterface;
import org.apache.cordova.CordovaPlugin;
import org.apache.cordova.CordovaWebView;


public class Progressbar extends CordovaPlugin {

	private WebView progressbarWebview;
    private Activity activity;
	@Override
	public void initialize(CordovaInterface cordova, CordovaWebView webView) {
        super.initialize(cordova, webView);
        activity = this.cordova.getActivity();
        progressbarWebview = new WebView(activity);
        progressbarWebview.getSettings().setJavaScriptEnabled(true);
        progressbarWebview.loadUrl("file:///android_asset/www/progressbar.html");
    }
	@Override
	public boolean onOverrideUrlLoading(String url){
		Log.d("SpielerPlus", "URL: "+ url);
		return false;		
	}
	@Override
	public Object onMessage(String id, Object data){
		if (id.equals("onPageStarted")){
			this.onPageStarted();	
		}
		if (id.equals("onPageFinished")){
			this.onPageFinished();	
		}
		Log.d("SpielerPlus", "MESSAGE: " +id);
		return null;
	}
	private void onPageStarted(){
		if (progressbarWebview.getParent() != null){
    	((ViewGroup) progressbarWebview.getParent()).removeView(progressbarWebview);
		}
		activity.addContentView(progressbarWebview, new ViewGroup.LayoutParams(
   		ViewGroup.LayoutParams.MATCH_PARENT,
     	4));
		progressbarWebview.loadUrl("javascript:resetBar();runTick();");
	}
	private void onPageFinished(){
    progressbarWebview.loadUrl("javascript:finishBar();");
    ((ViewGroup) progressbarWebview.getParent()).removeView(progressbarWebview);
	}
}
