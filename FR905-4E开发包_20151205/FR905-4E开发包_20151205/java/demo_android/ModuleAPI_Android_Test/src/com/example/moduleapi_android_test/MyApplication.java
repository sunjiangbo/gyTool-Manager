package com.example.moduleapi_android_test;

import com.uhf.api.cls.Reader;
import android.app.Application;

public class MyApplication extends Application{

	/*
	 * 公共变量  蓝牙读写器
	 */
	public Reader Jreader;
	public String address;
	public int antport;
	public int PdaType;
}
