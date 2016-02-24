package com.example.moduleapi_android_test;

import com.lsc.gpio.Scan;
import com.uhf.api.cls.Reader;
import com.uhf.api.cls.Reader.AntPower;
import com.uhf.api.cls.Reader.AntPowerConf;
import com.uhf.api.cls.Reader.Mtr_Param;
import com.uhf.api.cls.Reader.READER_ERR;

import android.app.Activity;
import android.app.Application;
import android.os.Bundle;
import android.view.View;
import android.view.View.OnClickListener;
import android.widget.Button;
import android.widget.EditText;
import android.widget.RadioGroup;
import android.widget.Toast;
import android.widget.RadioGroup.OnCheckedChangeListener;

public class OpActivity  extends Activity {
    
	MyApplication myapp;
	RadioGroup group1_ant,group2_bank;
	Button button_readbank,button_wirtebank,button_epc,button_connect2,button_setpow2;
	Reader Jreader;
	private Scan scan=null; 
	private int SortGroup(RadioGroup rg)
	{
		 int check1=rg.getCheckedRadioButtonId();
		    if(check1!=-1)
		    {
		    	for(int i=0;i<rg.getChildCount();i++)
		    	{ 
		    	  View vi=rg.getChildAt(i);
		    	  int vv=vi.getId();
		    	  if(check1==vv)
		    	  {
		    		  return i;
		    	  }
		    	}
		    	
		    	return -1;
		    }
		    else
		    	return check1;
	}
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.singleantop);
		
		Application app=getApplication();
		myapp=(MyApplication) app; 
		Jreader=myapp.Jreader;
	
		button_connect2=(Button) this.findViewById(R.id.button_connect2);
		button_readbank=(Button) this.findViewById(R.id.button_readbank);
		button_wirtebank=(Button) this.findViewById(R.id.button_wbank);
		button_epc=(Button) this.findViewById(R.id.button_wepc);
		group1_ant=(RadioGroup)this.findViewById(R.id.radioGroup_ant);
		group2_bank=(RadioGroup)this.findViewById(R.id.radioGroup_bank);
		button_setpow2=(Button) this.findViewById(R.id.button_setpow2);
		button_setpow2.setOnClickListener(new OnClickListener()
		{

			@Override
			public void onClick(View arg0) {
				// TODO Auto-generated method stub
				
				EditText et1=(EditText)findViewById(R.id.editText_power2);
			    String  p=et1.getText().toString();
				AntPowerConf apcf=Jreader.new AntPowerConf();
				apcf.antcnt=1;
				for(int i=0;i<apcf.antcnt;i++)
				{
					AntPower jaap=Jreader.new AntPower();
					jaap.antid=i+1;
					jaap.readPower=Short.parseShort(p);
					jaap.writePower=Short.parseShort(p);
					apcf.Powers[i]=jaap; 
				}
				AntPowerConf apcf2=Jreader.new AntPowerConf();
				if(Jreader.ParamSet(Mtr_Param.MTR_PARAM_RF_ANTPOWER, apcf)==READER_ERR.MT_OK_ERR)
				{
					Toast.makeText(OpActivity.this, "成功",Toast.LENGTH_SHORT).show();
				}
				else
				{
					Toast.makeText(OpActivity.this, "失败",Toast.LENGTH_SHORT).show();
				}
			}
			
		});
		button_connect2.setOnClickListener(new OnClickListener()
		{

			@Override
			public void onClick(View arg0) {
				// TODO Auto-generated method stub
				if(scan==null)
				{try
				{
				   scan=new Scan();
				   Toast.makeText(OpActivity.this, "返回:gpio ok",Toast.LENGTH_SHORT).show();
				}
				catch(Exception ex)
				{
					Toast.makeText(OpActivity.this, "返回:gpio failed",Toast.LENGTH_SHORT).show();
					return;
				}
				}
				int re=scan.ctrl(0x01);
				Toast.makeText(OpActivity.this, "返回："+String.valueOf(re),Toast.LENGTH_SHORT).show();
				 
				Jreader=new Reader();
				 
					READER_ERR er= Jreader.InitReader_Notype("/dev/ttyMT1", 1);
					Toast.makeText(OpActivity.this, er.toString(),Toast.LENGTH_SHORT).show();

			}
			
		});
		 
		button_readbank.setOnClickListener(new OnClickListener()
		{

			@Override
			public void onClick(View arg0) {
				// TODO Auto-generated method stub
				int ant =SortGroup(group1_ant);
				if(ant==-1)
				{
					Toast.makeText(OpActivity.this, "没选天线",Toast.LENGTH_SHORT).show();
					return ;
				}
				ant+=1;
				int bank=SortGroup(group2_bank);
				if(bank==-1)
				{
					Toast.makeText(OpActivity.this, "没选区域",Toast.LENGTH_SHORT).show();
					return ;
				}
				int address=0;
				 EditText etar=(EditText)findViewById(R.id.editText_stblock);
				    if(etar.getText().toString().isEmpty())
				    {
				    	Toast.makeText(OpActivity.this, "没写起始地址",Toast.LENGTH_SHORT).show();
						return ;
				    }
				try
				{
					address=Integer.valueOf(etar.getText().toString());
				}catch(Exception ex)
				{
					Toast.makeText(OpActivity.this, "起始地址错误",Toast.LENGTH_SHORT).show();
					return ;
				}
				
				int blkcnt=0;
				 EditText etbc=(EditText)findViewById(R.id.editText_blockcnt);
				    if(etbc.getText().toString().isEmpty())
				    {
				    	Toast.makeText(OpActivity.this, "没写块数",Toast.LENGTH_SHORT).show();
						return ;
				    }
				try
				{
					blkcnt=Integer.valueOf(etbc.getText().toString());
				}catch(Exception ex)
				{
					Toast.makeText(OpActivity.this, "块数错误",Toast.LENGTH_SHORT).show();
					return ;
				}
				byte[] data=new byte[blkcnt*2];
				READER_ERR er=Jreader.GetTagData(ant, (char) bank, address, blkcnt, data, null, (short) 1000);
				if(er==READER_ERR.MT_OK_ERR)
				{
					Toast.makeText(OpActivity.this, "成功",Toast.LENGTH_SHORT).show();
					EditText etdata=(EditText)findViewById(R.id.editText_data);
					String str1="";
					
					for(int i=0;i<data.length;i++)
					{
						str1+=(Integer.toHexString(data[i]&0xff).length()==2?"":"0")+Integer.toHexString(data[i]&0xff).toUpperCase() ;
						 
					}
					etdata.setText(str1);
				}
				else
				{
					Toast.makeText(OpActivity.this, "失败:"+er.toString(),Toast.LENGTH_SHORT).show();
				}
			}
			
		});
		button_wirtebank.setOnClickListener(new OnClickListener()
		{

			@Override
			public void onClick(View arg0) {
				// TODO Auto-generated method stub
				int ant =SortGroup(group1_ant);
				if(ant==-1)
				{
					Toast.makeText(OpActivity.this, "没选天线",Toast.LENGTH_SHORT).show();
					return ;
				}
				ant+=1;
				int bank=SortGroup(group2_bank);
				if(bank==-1)
				{
					Toast.makeText(OpActivity.this, "没选区域",Toast.LENGTH_SHORT).show();
					return ;
				}
				int address=0;
				 EditText etar=(EditText)findViewById(R.id.editText_stblock);
				    if(etar.getText().toString().isEmpty())
				    {
				    	Toast.makeText(OpActivity.this, "没写起始地址",Toast.LENGTH_SHORT).show();
						return ;
				    }
				try
				{
					address=Integer.valueOf(etar.getText().toString());
				}catch(Exception ex)
				{
					Toast.makeText(OpActivity.this, "起始地址错误",Toast.LENGTH_SHORT).show();
					return ;
				}
				
				int blkcnt=0;
				 EditText etbc=(EditText)findViewById(R.id.editText_blockcnt);
				    if(etbc.getText().toString().isEmpty())
				    {
				    	Toast.makeText(OpActivity.this, "没写块数",Toast.LENGTH_SHORT).show();
						return ;
				    }
				try
				{
					blkcnt=Integer.valueOf(etbc.getText().toString());
				}catch(Exception ex)
				{
					Toast.makeText(OpActivity.this, "块数错误",Toast.LENGTH_SHORT).show();
					return ;
				}
				 EditText etdata=(EditText)findViewById(R.id.editText_data);
				byte[] hexbuf=new byte[etdata.getText().toString().length()/2];
				
				 try{
				Jreader.Str2Hex(etdata.getText().toString(), etdata.getText().toString().length(), hexbuf);
				 }catch(Exception ex)
				 {
					 Toast.makeText(OpActivity.this, "数据错误",Toast.LENGTH_SHORT).show();
						return ;
				 }
				 
				READER_ERR er=Jreader.WriteTagData(ant, (char) bank, address, hexbuf, hexbuf.length, null, (short) 1000);
				if(er==READER_ERR.MT_OK_ERR)
				{
					Toast.makeText(OpActivity.this, "成功",Toast.LENGTH_SHORT).show();
				}
				else
				{
					Toast.makeText(OpActivity.this, "失败:"+er.toString(),Toast.LENGTH_SHORT).show();
				}
			}
			
		});
		button_epc.setOnClickListener(new OnClickListener()
		{

			@Override
			public void onClick(View arg0) {
				// TODO Auto-generated method stub
				int ant =SortGroup(group1_ant);
				if(ant==-1)
				{
					Toast.makeText(OpActivity.this, "没选天线",Toast.LENGTH_SHORT).show();
					return ;
				}
				ant+=1;
				 EditText etdata=(EditText)findViewById(R.id.editText_data);
				byte[] hexbuf=new byte[etdata.getText().toString().length()/2];
				
				 try{
					 Jreader.Str2Hex(etdata.getText().toString(), etdata.getText().toString().length(), hexbuf);
				 }catch(Exception ex)
				 {
					 Toast.makeText(OpActivity.this, "数据错误",Toast.LENGTH_SHORT).show();
						return ;
				 }
				  
				READER_ERR er=Jreader.WriteTagEpcEx(ant, hexbuf, hexbuf.length, null, (short) 1000);
				if(er==READER_ERR.MT_OK_ERR)
				{
					Toast.makeText(OpActivity.this, "成功",Toast.LENGTH_SHORT).show();
				}
				else
				{
					Toast.makeText(OpActivity.this, "失败:"+er.toString(),Toast.LENGTH_SHORT).show();
				}
			}
			
		});
		 
	}
}
