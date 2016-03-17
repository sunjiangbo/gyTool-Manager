package com.example.moduleapi_android_test;

import java.io.Serializable;

import com.uhf.api.cls.Reader;

public class SerialObject implements Serializable {
    /**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	private Object object;
    public SerialObject(Object oj)
    {
    	object=oj;
    }
    
    public Object GetObject()
    {
    	return object;
    }
}
