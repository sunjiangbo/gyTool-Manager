package com.lsc.gpio;

import java.io.IOException;

import android.util.Log;

public class Scan{
	private static final String TAG = "Scan";
	
	/*
	 * Do not remove or rename the field mFd: it is used by native method close() and ctrl();
	 */
	private int mFd;
	
	public Scan() throws IOException {
		mFd = open();
		if (mFd <0) {
			Log.e(TAG, "native open returns null");
			throw new IOException();
		}
	}
	
	public void close(){
		close(mFd);
		mFd=-1;
	}
	
	public int ctrl(int cmd){
		if (mFd==-1) {
			Log.e(TAG, "scan has closed");
			return -1;
		}
		return ctrl(mFd, cmd);
	}
	
	// JNI
	public native static int open();
	private native void close(int fd);
	private native int ctrl(int fd,int cmd);
	static {
		System.loadLibrary("scan_jni");
	}
}
