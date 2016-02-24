
package com.example.moduleapi_android_test;

import java.util.List;

import android.content.Context;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ArrayAdapter;
import android.widget.BaseAdapter;
import android.widget.TextView;

import android.content.Context;
import android.graphics.Color;

public class MyAdapter extends ArrayAdapter{

	public Context Ct;
	//private Object[] bjt;
	public MyAdapter(Context context, int textViewResourceId, Object[] objects) {
		super(context, textViewResourceId, objects);
		// TODO Auto-generated constructor stub
		//bjt=objects;
	}
    
	@Override
	public View getView(int arg0, View arg1, ViewGroup arg2) {
		// TODO Auto-generated method stub
		//TextView mTextView=new TextView(getApplicationContext());
		TextView mTextView=new TextView(Ct);
		
		mTextView.setText(this.getItem(arg0).toString());
		mTextView.setTextSize(15);
		mTextView.setTextColor(Color.BLUE);
		return mTextView;
	}

}
