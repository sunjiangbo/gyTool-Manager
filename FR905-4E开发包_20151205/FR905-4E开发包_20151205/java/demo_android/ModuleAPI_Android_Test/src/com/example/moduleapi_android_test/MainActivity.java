package com.example.moduleapi_android_test;

import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.util.ArrayList;

import java.util.HashMap;
import java.util.Iterator;
import java.util.LinkedHashMap;
import java.util.Map;

import java.util.List;
import java.util.Map.Entry;

import android.media.AudioManager;
import android.media.SoundPool;
import android.os.Bundle;
import android.os.Handler;
import android.os.Message;
import android.app.Activity;
import android.app.Application;
import android.bluetooth.BluetoothDevice;
import android.content.Intent;
import android.view.KeyEvent;
import android.view.Menu;
import android.view.View;
import android.view.View.OnClickListener;
import android.widget.ArrayAdapter;
import android.widget.BaseAdapter;
import android.widget.Button;
import android.widget.EditText;
import android.widget.ListAdapter;
import android.widget.ListView;
import android.widget.Toast;

import com.uhf.api.cls.Reader;
import com.uhf.api.cls.Reader.*;
import com.example.moduleapi_android_test.R;
import cn.trinea.android.common.util.ShellUtils;
import cn.trinea.android.common.util.ShellUtils.CommandResult;

import android.util.Log;

//电源控制
import com.rscja.deviceapi.Module;
import com.rscja.deviceapi.exception.ConfigurationException;
import com.lsc.gpio.*;

import android_serialport_api.*;

public class MainActivity extends Activity {

	Button button_connect,button_read,button_discon,button_test,button_setpow,
	button_up,button_down,button_clear,button_op,button_setregion,button_setfre;
	MyApplication myapp;
	Reader Jreader;
	private Handler handler = new Handler( );

	private ListView listView;
	Map<String,TAGINFO> Devaddrs=new LinkedHashMap<String,TAGINFO>();//有序
	private SoundPool soundPool;
	
	//电源管理
	// com地址  “/dev/ttyMT3”
	// /dev/ttySAC3 2
	//....   /dev/ttyS0
	// ip地址    “192.168.1.100”
	private final int PdaType=1;//平台  1成为 ；2 commandlist； 3 scan
	private final int showType=1;
	private Module module;//1 成为  /dev/ttyMT3
	public static List<String>  commnandList = new ArrayList<String>();//2 trinea   /dev/ttyMT0
	private Scan scan=null;//3 alps-konka77_cu_ics    /dev/ttyMT1
	private SerialPort sp;
	private int[] uants=new int[]{1};
 	private void showlist(String[] epc)
	{
		 
	    	Object[] objs=new Object[epc.length];
	    	for(int i=0;i<epc.length;i++)
	    		if(epc[i]!=null)
	    		objs[i]=epc[i];
	    	MyAdapter mad=new MyAdapter(this,android.R.layout.simple_expandable_list_item_1,objs);
	    	mad.Ct=getApplicationContext();
	    	ListAdapter la=(ListAdapter)mad;  
	    	listView.setAdapter(la); 
	}
 	
 	String[] Coname=new String[]{"序号","epc","次数"};
	private void showlist2()
	{
		 
		List<Map<String, ?>> list = new ArrayList<Map<String, ?>>();

        Iterator<Entry<String, TAGINFO>> iesb=Devaddrs.entrySet().iterator();
            int j=1;
            while(iesb.hasNext())
           { 
             TAGINFO bd=iesb.next().getValue();
             Map<String, String> m = new HashMap<String, String>();
             m.put(Coname[0], String.valueOf(j));
               j++;
              
             m.put(Coname[1], Reader.bytes_Hexstr(bd.EpcId));
             String cs=m.get("次数");
             if(cs==null)
            	 cs="0";
             int isc=Integer.parseInt(cs)+bd.ReadCnt;
             
             m.put(Coname[2], String.valueOf(isc));
             list.add(m);
           } 
        
		///*
		   ListAdapter adapter = new MyAdapter3(this,list,
				R.layout.listitemview, Coname,new int[] { R.id.textView1,
				R.id.textView_stblock, R.id.textView_blockcnt});
		 
		 
		// layout为listView的布局文件，包括三个TextView，用来显示三个列名所对应的值
		// ColumnNames为数据库的表的列名 
		// 最后一个参数是int[]类型的，为view类型的id，用来显示ColumnNames列名所对应的值。view的类型为TextView
		listView.setAdapter(adapter); 
		//*/
	}
	private void showlist3()
	{
		  ListAdapter la = listView.getAdapter();
		  int itemNum = la.getCount();
		  Iterator<Entry<String, TAGINFO>> iesb=Devaddrs.entrySet().iterator();
         
          while(iesb.hasNext())
         { 
           TAGINFO bd=iesb.next().getValue();
           Map<String, String> m = new HashMap<String, String>();
              int k=0;
        	  for(;k<itemNum;k++)
        	  {
        		  Map<String, String> list2 = (Map<String, String>)(la.getItem(k));
        		  if (Reader.bytes_Hexstr(bd.EpcId)==(String)list2.get(Coname[1]));
                  {list2.put(Coname[2],String.valueOf(bd.ReadCnt));break;}
        	  }
        	 
          }
          
          ((BaseAdapter) la).notifyDataSetChanged();
	}
 	private Runnable runnable = new Runnable( ) {
 		public void run ( ) {

 			
 	  	    // MyAdapter mad=new MyAdapter(getApplicationContext(),android.R.layout.simple_expandable_list_item_1,new Object[]{});
 			//    listView.setAdapter((ListAdapter)mad); 
 			    
 			    String[] tag = null;
 			
 			   int[] tagcnt=new int[1];
 			   /*
				TAGINFO[] pTInfo=new TAGINFO[100];
				READER_ERR er=Jreader.TagInventory(new int[]{1}, 1, (short) 200, pTInfo, tagcnt);
				
				if(er==READER_ERR.MT_OK_ERR)
				{
					if(tagcnt[0]>0)
					{
						tag=new String[tagcnt[0]];
						for(int i=0;i<tagcnt[0];i++)
						{
							if(pTInfo[i]!=null)
							tag[i]=Reader.bytes_Hexstr(pTInfo[i].EpcId);
						}
					}
				}*/
				tagcnt[0]=0;
				synchronized (this)
				{
					READER_ERR er=Jreader.TagInventory_Raw(uants, 1, (short) 100, tagcnt);
					Log.d("debug read:",er.toString());
					
					if(er==READER_ERR.MT_OK_ERR)
					{
						if(tagcnt[0]>0)
						{
							soundPool.play(1,1, 1, 0, 0, 1);
							tag=new String[tagcnt[0]];
						for(int i=0;i<tagcnt[0];i++)
						{
							Log.d("get tag index:",String.valueOf(i));
							TAGINFO tfs=Jreader.new TAGINFO();
							if(PdaType==3)
							{
								try {
									Thread.sleep(10);
								} catch (InterruptedException e) {
									// TODO Auto-generated catch block
									e.printStackTrace();
								}
							}
							er=Jreader.GetNextTag(tfs);
							if(er==READER_ERR.MT_HARDWARE_ALERT_ERR_BY_TOO_MANY_RESET)
							{
								handler.removeCallbacks(runnable); 
								 
								 EditText et=(EditText)findViewById(R.id.editText_stblock);
				 				 et.setText("error:"+String.valueOf(er.value())+er.toString());
								button_read.setText("读");
							}
						
							Log.d("debug gettag:",er.toString());
							Log.d("debug tag:",Reader.bytes_Hexstr(tfs.EpcId));
							
							if(er==READER_ERR.MT_OK_ERR)
							{
								tag[i]=Reader.bytes_Hexstr(tfs.EpcId);
							 
							if(showType==1)
							{
								if(!Devaddrs.containsKey(tag[i]))
				       		       Devaddrs.put(tag[i],tfs);
							    else
								{ 
								  TAGINFO tf=Devaddrs.get(tag[i]);
								  tf.ReadCnt+=tfs.ReadCnt;
								  //Devaddrs.get(tag[i]);
								  //Devaddrs.put(tag[i], tf);
								}
							}
							}
						}
						}
						
					}
					else
					{
						 EditText et=(EditText)findViewById(R.id.editText_stblock);
		 				 et.setText("error:"+String.valueOf(er.value())+er.toString());
		 				 handler.postDelayed(this,0); 
	 			    	 return;
					}
					
					
				}
				
 			     if(tag==null)
 			    {
 			       tag=new String[0];
 			    }
 			    
 			   //player.play(); 
 			   //player.write(audioData, 0, audioBufSize * 10);  
 			   
 			     if(showType==1)
 			    	showlist2();
 			     else
 			        showlist(tag);
 			     
 			   
 			    EditText et=(EditText)findViewById(R.id.editText_stblock);
 				 et.setText("标签:"+String.valueOf(listView.getCount())+"个");
 				handler.postDelayed(this,0); 
 		}
 	};
 	 
	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.activity_main);
		
		Application app=getApplication();
		myapp=(MyApplication) app;  
		myapp.Jreader=new Reader();
		Jreader=new Reader();
		listView = (ListView) findViewById(R.id.listView1); 
		button_connect=(Button) this.findViewById(R.id.button_connect);
		button_read=(Button) this.findViewById(R.id.button_read);
		 button_read.setEnabled(false);
		button_discon=(Button) this.findViewById(R.id.button_disconnect);
		button_test=(Button) this.findViewById(R.id.button_test);
		button_setpow=(Button) this.findViewById(R.id.button_setpow);
		button_up=(Button) this.findViewById(R.id.button_up);
		button_down=(Button) this.findViewById(R.id.button_down);
		button_clear=(Button) this.findViewById(R.id.button_clear);
		button_op=(Button) this.findViewById(R.id.button_op);
		button_setregion=(Button) this.findViewById(R.id.button_setregion);
		button_setregion.setOnClickListener(new OnClickListener()
		{
			/*
			RG_NONE(0x0),
			RG_NA(0x01),
			RG_EU(0x02),
			RG_EU2(0X07),
			RG_EU3(0x08),
			RG_KR(0x03),
			RG_PRC(0x06),
			RG_PRC2(0x0A),
			RG_OPEN(0xFF);
北美：1,欧洲1:2,欧洲2:7,欧洲3:8,韩国：3,中国1:6,中国2:10,全频段：255

			*/
			@Override
			public void onClick(View arg0) {
				// TODO Auto-generated method stub
				EditText et1=(EditText)findViewById(R.id.editText_region);
			    String  p=et1.getText().toString();
				Region_Conf rcf1=Region_Conf.valueOf(Integer.valueOf(p));
				 
				 READER_ERR er=Jreader.ParamSet(Mtr_Param.MTR_PARAM_FREQUENCY_REGION,rcf1);
				 Toast.makeText(MainActivity.this, "返回："+er.toString(),Toast.LENGTH_SHORT).show();
				 if(er!=READER_ERR.MT_OK_ERR)
					{
						Toast.makeText(MainActivity.this, "北美:1,欧洲1:2,欧洲2:7,欧洲3:8,韩国:3,中国1:6,中国2:10,全频段:255",Toast.LENGTH_LONG).show();

					}
			}
			
		});
		button_setfre=(Button) this.findViewById(R.id.button_setfre);
		button_setfre.setOnClickListener(new OnClickListener()
		{

			@Override
			public void onClick(View arg0) {
				// TODO Auto-generated method stub
				HoptableData_ST hdst=Jreader.new HoptableData_ST();
				hdst.lenhtb=1;
				EditText et1=(EditText)findViewById(R.id.editText_fre);
			    String  p=et1.getText().toString();
				hdst.htb[0]=Integer.parseInt(p);
				 
				READER_ERR er=Jreader.ParamSet(Mtr_Param.MTR_PARAM_FREQUENCY_HOPTABLE,hdst);
				Toast.makeText(MainActivity.this, "参考设置范围860000-928750,返回:"+er.toString(),Toast.LENGTH_SHORT).show();
				
			}
			
		});
		button_op.setOnClickListener(new OnClickListener()
		{

			@Override
			public void onClick(View arg0) {
				// TODO Auto-generated method stub
				Intent intent = new Intent(MainActivity.this, OpActivity.class); 
				/*Bundle bd=new Bundle();
				SerialObject so=new SerialObject(Jreader);
				bd.putSerializable("reader", so);
				intent.putExtra("param", bd);*/
				startActivityForResult(intent, 10); 
			}
			
		});
		
		button_clear.setOnClickListener(new OnClickListener()
		{

			@Override
			public void onClick(View arg0) {
				// TODO Auto-generated method stub
				if(showType==1)
				{
					Devaddrs.clear();
					showlist2();
				}
				else
					showlist(new String[0]);
				
				EditText et=(EditText)findViewById(R.id.editText_stblock);
				 et.setText("标签:0个");
			}
			
		});
		button_up.setOnClickListener(new OnClickListener()
		{

			@Override
			public void onClick(View arg0) {
				// TODO Auto-generated method stub
				//上电
				switch(PdaType)
				{
					case 0:
					break;
					case 1:
						try
						{
					       module=Module.getInstance();
					       module.powerOn(3);
					       module.uartSwitch(3);
						}catch(ConfigurationException ce)
						{
							
						}
						break;
					case 2:
						commnandList.add("echo 1 >/sys/devices/platform/gpio_test/uart1power");
						@SuppressWarnings("unused")
						CommandResult result = ShellUtils.execCommand(commnandList,true);
						Toast.makeText(MainActivity.this, "返回："+String.valueOf(result.result),Toast.LENGTH_SHORT).show();
						break;
					case 3:
						if(scan==null)
						{try
						{
						   scan=new Scan();
						   Toast.makeText(MainActivity.this, "返回:gpio ok",Toast.LENGTH_SHORT).show();
						}
						catch(Exception ex)
						{
							Toast.makeText(MainActivity.this, "返回:gpio failed",Toast.LENGTH_SHORT).show();
							return;
						}
						}
						int re=scan.ctrl(0x01);
						Toast.makeText(MainActivity.this, "返回："+String.valueOf(re),Toast.LENGTH_SHORT).show();
						break;
				}

			}
			
		});
		button_down.setOnClickListener(new OnClickListener()
		{

			@Override
			public void onClick(View arg0) {
				// TODO Auto-generated method stub
				switch(PdaType)
				{
					case 0:
					break;
					case 1:
						try
						{
					       module=Module.getInstance();
					       module.powerOff(3);
					     
						}catch(ConfigurationException ce)
						{
							
						}
						break;
					case 2:
						commnandList.add("echo 1 >/sys/devices/platform/gpio_test/uart1power");
						@SuppressWarnings("unused")
						CommandResult result = ShellUtils.execCommand(commnandList,false);
						Toast.makeText(MainActivity.this, "返回："+String.valueOf(result.result),Toast.LENGTH_SHORT).show();
						break;
					case 3:
						if(scan==null)
						{try
						{
						   scan=new Scan();
						   Toast.makeText(MainActivity.this, "返回:gpio ok",Toast.LENGTH_SHORT).show();
						}
						catch(Exception ex)
						{
							Toast.makeText(MainActivity.this, "返回:gpio failed",Toast.LENGTH_SHORT).show();
							return;
						}
						}
						int re=scan.ctrl(0x0F);
						Toast.makeText(MainActivity.this, "返回："+String.valueOf(re),Toast.LENGTH_SHORT).show();
						break;
				}
			}
			
		});
		button_setpow.setOnClickListener(new OnClickListener()
		{

			@Override
			public void onClick(View arg0) {
				// TODO Auto-generated method stub
				EditText et1=(EditText)findViewById(R.id.editText4);
			    String  p=et1.getText().toString();
				AntPowerConf apcf=Jreader.new AntPowerConf();
				apcf.antcnt=myapp.antport;
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
					Toast.makeText(MainActivity.this, "成功",Toast.LENGTH_SHORT).show();
				}
				else
				{
					Toast.makeText(MainActivity.this, "失败",Toast.LENGTH_SHORT).show();
				}
			}
			
		});
		button_discon.setOnClickListener(new OnClickListener()
		{

			@Override
			public void onClick(View arg0) {
				// TODO Auto-generated method stub
				if(Jreader!=null)
				{ 
					myapp.Jreader.CloseReader();
					Jreader=null;
				  button_connect.setEnabled(true);
				  button_read.setEnabled(false);
				}
				
				if(PdaType==2)
				{  //ying fu tiao ma
					try {
					sp = new SerialPort(new File("/dev/ttyMT0"), 9600, 0);
					InputStream ism=sp.getInputStream();
					
					ism.read();
					ism.close();
					
				} catch (SecurityException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				} catch (IOException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}
					if(sp!=null)
					sp.close();
				}
			}
			
		});
		button_connect.setOnClickListener(new OnClickListener() 
		{

			@Override
			public void onClick(View arg0) {
				// TODO Auto-generated method stub
				
				//上电
				switch(PdaType)
				{
					case 0:
					break;
					case 1:
						try
						{
					       module=Module.getInstance();
					       module.powerOn(3);
					       module.uartSwitch(3);
						}catch(ConfigurationException ce)
						{
							
						}
						break;
					case 2:
						commnandList.add("echo 1 >/sys/devices/platform/gpio_test/uart1power");
						@SuppressWarnings("unused")
						CommandResult result = ShellUtils.execCommand(commnandList,true);
						Toast.makeText(MainActivity.this, "返回："+String.valueOf(result.result),Toast.LENGTH_SHORT).show();
						break;
					case 3:
						if(scan==null)
						{try
						{
						   scan=new Scan();
						   Toast.makeText(MainActivity.this, "返回:gpio ok",Toast.LENGTH_SHORT).show();
						}
						catch(Exception ex)
						{
							Toast.makeText(MainActivity.this, "返回:gpio failed",Toast.LENGTH_SHORT).show();
							return;
						}
						}
						int re=scan.ctrl(0x01);
						Toast.makeText(MainActivity.this, "返回："+String.valueOf(re),Toast.LENGTH_SHORT).show();
						break;
				}
			   myapp.PdaType=PdaType;
				
				EditText et1=(EditText)findViewById(R.id.editText2);
			    String  ip=et1.getText().toString();
			    
			    EditText et2=(EditText)findViewById(R.id.editText3);
			    int port=Integer.parseInt(et2.getText().toString());
			    
			    
				READER_ERR er=myapp.Jreader.InitReader_Notype(ip, port);
				Jreader=myapp.Jreader;
				//READER_ERR er=japi.InitReader("192.168.1.101",Reader_Type.MODULE_FOUR_ANTS);
				//READER_ERR er=japi.test("192.168.1.101", 4);
				if(er==READER_ERR.MT_OK_ERR)
				{
					myapp.address=ip;
					myapp.antport=port;
					Toast.makeText(MainActivity.this, "成功",Toast.LENGTH_SHORT).show();
					button_connect.setEnabled(false);
					button_read.setEnabled(true);
				}
				else
				{
					Toast.makeText(MainActivity.this, "失败",Toast.LENGTH_SHORT).show();
					return;
				}
				Log.d("debug init:",er.toString());
				
				Inv_Potls_ST ipst=Jreader.new Inv_Potls_ST();
				ipst.potlcnt=1;
				ipst.potls=new Inv_Potl[1];
				for(int i=0;i<ipst.potlcnt;i++)
				{
					Inv_Potl ipl=Jreader.new Inv_Potl();
					ipl.weight=30;
					ipl.potl=SL_TagProtocol.SL_TAG_PROTOCOL_GEN2;
					ipst.potls[0]=ipl;
				}
				
				er=Jreader.ParamSet(Mtr_Param.MTR_PARAM_TAG_INVPOTL, ipst);
				Log.d("debug setpotl:",er.toString());
				
				///*
				AntPowerConf apcf=Jreader.new AntPowerConf();
				apcf.antcnt=myapp.antport;
				for(int i=0;i<apcf.antcnt;i++)
				{
					AntPower jaap=Jreader.new AntPower();
					jaap.antid=i+1;
					jaap.readPower=2000;
					jaap.writePower=2000;
					apcf.Powers[i]=jaap; 
				}
				AntPowerConf apcf2=Jreader.new AntPowerConf();
				er=Jreader.ParamSet( Mtr_Param.MTR_PARAM_RF_ANTPOWER, apcf);
				
				er=Jreader.ParamGet( Mtr_Param.MTR_PARAM_RF_ANTPOWER, apcf2);
				for(int i=0;i<apcf2.antcnt;i++)
				{
					System.out.print("antid:"+apcf2.Powers[i].antid);
					System.out.print(" rp:"+apcf2.Powers[i].readPower);
					System.out.print(" wp:"+apcf2.Powers[i].writePower);
					System.out.println();
				}
				int[] val=new int[]{0};
				er=Jreader.ParamSet(Mtr_Param.MTR_PARAM_READER_IS_CHK_ANT, val);
				//*/
				
				Region_Conf rcf1=Region_Conf.RG_PRC;
				er=Jreader.ParamSet(Mtr_Param.MTR_PARAM_FREQUENCY_REGION,rcf1);
				
				HoptableData_ST hdst=Jreader.new HoptableData_ST();
				 
			}
			
		});
		
		button_read.setOnClickListener(new OnClickListener() 
		{

			@Override
			public void onClick(View arg0) {
				// TODO Auto-generated method stub
				String txt=button_read.getText().toString();
				if(txt.equals("读"))
				{
					
					handler.postDelayed(runnable,0); 
					button_read.setText("停");
				}
				else
				{
					handler.removeCallbacks(runnable); 
					if(PdaType==3)
					{
						try {
							Thread.sleep(500);
						} catch (InterruptedException e) {
							// TODO Auto-generated catch block
							e.printStackTrace();
						}
					}
					button_read.setText("读");
				}
			}
			
		});
		
		button_test.setOnClickListener(new OnClickListener() 
		{
			@Override
			public void onClick(View arg0) {
				// TODO Auto-generated method stub
				testrparams();
				testtran();
			}
		});
		
		soundPool= new SoundPool(10,AudioManager.STREAM_SYSTEM,5);

		soundPool.load(this,R.raw.beep,1);
	}

	public void testrparams()
	{
		HoptableData_ST hdst=Jreader.new HoptableData_ST();
		hdst.lenhtb=5;
		hdst.htb[0]=915250;
		hdst.htb[1]=916750;
		hdst.htb[2]=917250;
		hdst.htb[3]=925750;
		hdst.htb[4]=926750;
		READER_ERR er=Jreader.ParamSet(Mtr_Param.MTR_PARAM_FREQUENCY_HOPTABLE,hdst);
		
		HoptableData_ST hdst2=Jreader.new HoptableData_ST();
		er=Jreader.ParamGet(Mtr_Param.MTR_PARAM_FREQUENCY_HOPTABLE, hdst2);
		for(int i=0;i<hdst2.lenhtb;i++)
		{
			System.out.print("htb:"+i);
			System.out.println(" "+(hdst2.htb[i]));
		}
		
		//
		Region_Conf rcf1=Region_Conf.RG_NA;
		Region_Conf[] rcf2=new Region_Conf[1];
	
		er=Jreader.ParamSet(Mtr_Param.MTR_PARAM_FREQUENCY_REGION,rcf1);
		er=Jreader.ParamGet(Mtr_Param.MTR_PARAM_FREQUENCY_REGION,rcf2);
		
		int[] val1=new int[]{250};
		int[] val2=new int[]{-1};
		er=Jreader.ParamSet(Mtr_Param.MTR_PARAM_POTL_GEN2_BLF, val1);
		er=Jreader.ParamGet(Mtr_Param.MTR_PARAM_POTL_GEN2_BLF, val2);

		val1[0]=496;
		er=Jreader.ParamSet(Mtr_Param.MTR_PARAM_POTL_GEN2_MAXEPCLEN, val1);
		er=Jreader.ParamGet(Mtr_Param.MTR_PARAM_POTL_GEN2_MAXEPCLEN, val2);
		
		val1[0]=10;
		er=Jreader.ParamSet(Mtr_Param.MTR_PARAM_POTL_GEN2_Q, val1);
		er=Jreader.ParamGet(Mtr_Param.MTR_PARAM_POTL_GEN2_Q, val2);
		
		val1[0]=2;
		er=Jreader.ParamSet(Mtr_Param.MTR_PARAM_POTL_GEN2_SESSION, val1);
		er=Jreader.ParamGet(Mtr_Param.MTR_PARAM_POTL_GEN2_SESSION, val2);
		
		val1[0]=2;
		er=Jreader.ParamSet(Mtr_Param.MTR_PARAM_POTL_GEN2_TAGENCODING, val1);
		er=Jreader.ParamGet(Mtr_Param.MTR_PARAM_POTL_GEN2_TAGENCODING, val2);
		
		val1[0]=1;
		er=Jreader.ParamSet(Mtr_Param.MTR_PARAM_POTL_GEN2_TARGET, val1);
		er=Jreader.ParamGet(Mtr_Param.MTR_PARAM_POTL_GEN2_TARGET, val2);
		
		val1[0]=3;
		er=Jreader.ParamSet(Mtr_Param.MTR_PARAM_POTL_GEN2_TARI, val1);
		er=Jreader.ParamGet(Mtr_Param.MTR_PARAM_POTL_GEN2_TARI, val2);
		
		val1[0]=1;
		er=Jreader.ParamSet(Mtr_Param.MTR_PARAM_POTL_GEN2_WRITEMODE, val1);
		er=Jreader.ParamGet(Mtr_Param.MTR_PARAM_POTL_GEN2_WRITEMODE, val2);
		
		val1[0]=2;
		er=Jreader.ParamSet(Mtr_Param.MTR_PARAM_POTL_ISO180006B_BLF, val1);
		er=Jreader.ParamGet(Mtr_Param.MTR_PARAM_POTL_ISO180006B_BLF, val2);
		
		val1[0]=1;
		er=Jreader.ParamSet(Mtr_Param.MTR_PARAM_POTL_ISO180006B_DELIMITER, val1);
		er=Jreader.ParamGet(Mtr_Param.MTR_PARAM_POTL_ISO180006B_DELIMITER, val2);
		
		val1[0]=2;
		er=Jreader.ParamSet(Mtr_Param.MTR_PARAM_POTL_ISO180006B_MODULATION_DEPTH, val1);
		er=Jreader.ParamGet(Mtr_Param.MTR_PARAM_POTL_ISO180006B_MODULATION_DEPTH, val2);
		
		//er=Jreader.ParamSet(Mtr_Param.MTR_PARAM_POTL_SUPPORTEDPROTOCOLS, val1);
		//er=Jreader.ParamGet(Mtr_Param.MTR_PARAM_POTL_SUPPORTEDPROTOCOLS, val2);
		
		val1[0]=1;
		val2[0]=-1;
		er=Jreader.ParamSet(Mtr_Param.MTR_PARAM_POWERSAVE_MODE, val1);
		er=Jreader.ParamGet(Mtr_Param.MTR_PARAM_POWERSAVE_MODE, val2);

		//er=Jreader.ParamSet(Mtr_Param.MTR_PARAM_READER_AVAILABLE_ANTPORTS, val1);
		er=Jreader.ParamGet(Mtr_Param.MTR_PARAM_READER_AVAILABLE_ANTPORTS, val2);
		
		ConnAnts_ST cast=Jreader.new ConnAnts_ST();
		//er=Jreader.ParamSet(Mtr_Param.MTR_PARAM_READER_CONN_ANTS, val1);
		er=Jreader.ParamGet(Mtr_Param.MTR_PARAM_READER_CONN_ANTS, cast);

		
		Reader_Ip rip2=Jreader.new Reader_Ip();
		er=Jreader.ParamGet(Mtr_Param.MTR_PARAM_READER_IP, rip2);
		System.out.print("ip:"+rip2.ip.length+" ");
		System.out.println(new String(rip2.ip));
		System.out.println(new String(rip2.mask));
		System.out.println(new String(rip2.gateway));
		
		val1[0]=1;
		er=Jreader.ParamSet(Mtr_Param.MTR_PARAM_READER_IS_CHK_ANT, val1);
		er=Jreader.ParamGet(Mtr_Param.MTR_PARAM_READER_IS_CHK_ANT, val2);
		
		
		//er=Jreader.ParamSet(Mtr_Param.MTR_PARAM_READER_VERSION, val1);
		//er=Jreader.ParamGet(Mtr_Param.MTR_PARAM_READER_VERSION, val2);
		
		AntPowerConf apcf=Jreader.new AntPowerConf();
		apcf.antcnt=1;
		for(int i=0;i<apcf.antcnt;i++)
		{
			AntPower jaap=Jreader.new AntPower();
			jaap.antid=i+1;
			jaap.readPower=2800;
			jaap.writePower=2750;
			apcf.Powers[i]=jaap; 
		}
		AntPowerConf apcf2=Jreader.new AntPowerConf();
		er=Jreader.ParamSet(Mtr_Param.MTR_PARAM_RF_ANTPOWER, apcf);
		er=Jreader.ParamGet(Mtr_Param.MTR_PARAM_RF_ANTPOWER, apcf2);
		for(int i=0;i<apcf2.antcnt;i++)
		{
			System.out.print("antid:"+apcf2.Powers[i].antid);
			System.out.print(" rp:"+apcf2.Powers[i].readPower);
			System.out.print(" wp:"+apcf2.Powers[i].writePower);
			System.out.println();
		}
		
		val1[0]=100;
		er=Jreader.ParamSet(Mtr_Param.MTR_PARAM_RF_HOPTIME, val1);
		er=Jreader.ParamGet(Mtr_Param.MTR_PARAM_RF_HOPTIME, val2);
		
		val1[0]=1;
		er=Jreader.ParamSet(Mtr_Param.MTR_PARAM_RF_LBT_ENABLE, val1);
		er=Jreader.ParamGet(Mtr_Param.MTR_PARAM_RF_LBT_ENABLE, val2);
		
		
		//er=Jreader.ParamSet(Mtr_Param.MTR_PARAM_RF_MAXPOWER, val1);
		short[] valso=new short[1];
		er=Jreader.ParamGet(Mtr_Param.MTR_PARAM_RF_MAXPOWER, valso);
		System.out.println("max:"+valso[0]);
		
		//er=Jreader.ParamSet(Mtr_Param.MTR_PARAM_RF_MINPOWER, val1);
		er=Jreader.ParamGet(Mtr_Param.MTR_PARAM_RF_MINPOWER, valso);
		
		//er=Jreader.ParamSet(Mtr_Param.MTR_PARAM_RF_SUPPORTEDREGIONS, val1);
		//er=Jreader.ParamGet(Mtr_Param.MTR_PARAM_RF_SUPPORTEDREGIONS, val2);
		
		//er=Jreader.ParamSet(Mtr_Param.MTR_PARAM_RF_TEMPERATURE, val1);
		er=Jreader.ParamGet(Mtr_Param.MTR_PARAM_RF_TEMPERATURE, val2);
		
		EmbededData_ST edst = Jreader.new EmbededData_ST();
		edst.startaddr=0;
		edst.bank=2;
		//bytecnt=0 取消嵌入数据
		edst.bytecnt=2;
		edst.accesspwd=null;
		er=Jreader.ParamSet(Mtr_Param.MTR_PARAM_TAG_EMBEDEDDATA, edst);
		
		EmbededData_ST edst2 = Jreader.new EmbededData_ST();
		er=Jreader.ParamGet(Mtr_Param.MTR_PARAM_TAG_EMBEDEDDATA, edst2);
		
		er=Jreader.ParamSet(Mtr_Param.MTR_PARAM_TAG_EMBEDEDDATA, null);
		
		EmbededSecureRead_ST esrst=Jreader.new EmbededSecureRead_ST();
		esrst.accesspwd=1280;
		esrst.address=2;
		esrst.ApIndexBitsNumInEpc=1;
		esrst.ApIndexStartBitsInEpc=3;
		esrst.bank=1;
		//blkcnt =0 取消。
		esrst.blkcnt=2;
		esrst.pwdtype=1;
		esrst.tagtype=2;
		EmbededSecureRead_ST esrst2=Jreader.new EmbededSecureRead_ST();
		er=Jreader.ParamSet(Mtr_Param.MTR_PARAM_TAG_EMDSECUREREAD, esrst);
		er=Jreader.ParamGet(Mtr_Param.MTR_PARAM_TAG_EMDSECUREREAD, esrst2);
		er=Jreader.ParamSet(Mtr_Param.MTR_PARAM_TAG_EMDSECUREREAD, null);
		
		TagFilter_ST tfst=Jreader.new TagFilter_ST();
		tfst.bank=1;
		tfst.fdata=new byte[]{(byte) 0xE2,(byte) 0x00};
		//flen 0 为取消过滤
		tfst.flen=2;
		tfst.isInvert=0;
		tfst.startaddr=2;
		TagFilter_ST tfst2=Jreader.new TagFilter_ST();
		
		er=Jreader.ParamSet(Mtr_Param.MTR_PARAM_TAG_FILTER, tfst);
		er=Jreader.ParamGet(Mtr_Param.MTR_PARAM_TAG_FILTER, tfst2);
		er=Jreader.ParamSet(Mtr_Param.MTR_PARAM_TAG_FILTER, null);
		
		Inv_Potls_ST ipst=Jreader.new Inv_Potls_ST();
		ipst.potlcnt=1;
		ipst.potls=new Inv_Potl[1];
		for(int i=0;i<ipst.potlcnt;i++)
		{
			Inv_Potl ipl=Jreader.new Inv_Potl();
			ipl.weight=30;
			ipl.potl=SL_TagProtocol.SL_TAG_PROTOCOL_GEN2;
			ipst.potls[0]=ipl;
		}
		
		Inv_Potls_ST ipst2=Jreader.new Inv_Potls_ST();
		er=Jreader.ParamSet(Mtr_Param.MTR_PARAM_TAG_INVPOTL, ipst);
		er=Jreader.ParamGet(Mtr_Param.MTR_PARAM_TAG_INVPOTL, ipst2);
		for(int i=0;i<ipst2.potlcnt;i++)
		System.out.println(ipst2.potls[i].potl);
		
		val1[0]=1;
		val2[0]=0;
		er=Jreader.ParamSet(Mtr_Param.MTR_PARAM_TAG_SEARCH_MODE, val1);
		er=Jreader.ParamGet(Mtr_Param.MTR_PARAM_TAG_SEARCH_MODE, val2);
		
		val1[0]=1;
		val2[0]=0;
		er=Jreader.ParamSet(Mtr_Param.MTR_PARAM_TAGDATA_RECORDHIGHESTRSSI, val1);
		er=Jreader.ParamGet(Mtr_Param.MTR_PARAM_TAGDATA_RECORDHIGHESTRSSI, val2);

		val1[0]=1;
		val2[0]=0;
		er=Jreader.ParamSet(Mtr_Param.MTR_PARAM_TAGDATA_UNIQUEBYANT, val1);
		er=Jreader.ParamGet(Mtr_Param.MTR_PARAM_TAGDATA_UNIQUEBYANT, val2);

		val1[0]=1;
		val2[0]=0;
		er=Jreader.ParamSet(Mtr_Param.MTR_PARAM_TAGDATA_UNIQUEBYEMDDATA, val1);
		er=Jreader.ParamGet(Mtr_Param.MTR_PARAM_TAGDATA_UNIQUEBYEMDDATA, val2);
		
		val1[0]=300;
		val2[0]=0;
		er=Jreader.ParamSet(Mtr_Param.MTR_PARAM_TRANS_TIMEOUT, val1);
		er=Jreader.ParamGet(Mtr_Param.MTR_PARAM_TRANS_TIMEOUT, val2);
		
		val1[0]=1;
		val2[0]=0;
		er=Jreader.ParamSet(Mtr_Param.MTR_PARAM_TRANSMIT_MODE, val1);
		er=Jreader.ParamGet(Mtr_Param.MTR_PARAM_TRANSMIT_MODE, val2);
	}
	public void  testtran()
	{
		byte[] hex=new byte[]{(byte) 0xA2,(byte) 0xC8,(byte) 0xD4,(byte) 0xE5};
		int len=4;
		char[] str=new char[4*2];
	 	Jreader.Hex2Str(hex, len, str);
		String hstr = "";
		for(int i=0;i<8;i++)
		hstr+=(char)str[i];
		System.out.println(hstr);
		
		String buf="00111100";
	 
		byte[] binarybuf=new byte[1];
		String buf2="abcdef08";
		byte[] hexbuf=new byte[4];
		Jreader.Str2Binary(buf, 8, binarybuf);
		
		Jreader.Str2Hex(buf2, 8, hexbuf);
	}
	public void testcustomcmd()
	{
		//m4 qt
		IMPINJM4QtPara CustomPara=Jreader.new IMPINJM4QtPara();
		CustomPara.TimeOut=800;
		CustomPara.CmdType=1;
		CustomPara.MemType=2;
		CustomPara.PersistType=3;
		CustomPara.RangeType=4;
		CustomPara.AccessPwd=new byte[]{0x11,0x22,0x33,0x44};
		
		IMPINJM4QtResult CustomRet=Jreader.new IMPINJM4QtResult();
		Jreader.CustomCmd(1, CustomCmdType.IMPINJ_M4_Qt, CustomPara, CustomRet);
		
		//allen h3
		ALIENHiggs3BlockReadLockPara CustomPara2=Jreader.new ALIENHiggs3BlockReadLockPara();
		CustomPara2.AccessPwd=new byte[]{0x55,0x66,0x77,(byte) 0x88};
		CustomPara2.BlkBits=6;
		CustomPara2.TimeOut=890;
		Jreader.CustomCmd(1, CustomCmdType.ALIEN_Higgs3_BlockReadLock, CustomPara2, null);
		
		//nexp eas
		NXPChangeEASPara CustomPara3=Jreader.new NXPChangeEASPara();
		CustomPara3.AccessPwd=new byte[]{(byte) 0x99,(byte) 0xaa,(byte) 0xbb,(byte) 0xcc};
		CustomPara3.isSet=1;
		CustomPara3.TimeOut=900;
		Jreader.CustomCmd(1, CustomCmdType.NXP_ChangeEAS, CustomPara3, null);

		//nxp easl
		NXPEASAlarmPara CustomPara4=Jreader.new NXPEASAlarmPara();
		CustomPara4.DR=7;
		CustomPara4.MC=11;
		CustomPara4.TimeOut=950;
		CustomPara4.TrExt=17;
 
		NXPEASAlarmResult CustomRet2=Jreader.new NXPEASAlarmResult();
		Jreader.CustomCmd(1, CustomCmdType.NXP_EASAlarm, CustomPara4, CustomRet2);

		//basetype
		Jreader.CustomCmd_BaseType(1, 1, new byte[]{0x11,(byte) 0x99,(byte) 0xbb}, new byte[]{});

	}
	public void testreadandwrite()
	{
		/*
		 * READER_ERR WriteTagData(int ant,char bank,int address, byte[] data, int datalen, byte[] accesspasswd,short timeout);
		 * ant 操作的单天线
		 * bank 表示区域 0表示保留区 1表示epc区 2表示tid区 3表示user区
		 * address 表示地址块， 注意epc区从第二块开始
		 * data 写的数据
		 * datalen 表示写的数据长度
		 * accesspwd 表示密码，默认"00000000" 8个十六进制字符
		 * timeout 操作超时时间
		 */
		
		String pwd="12345678";
		byte[] data=new byte[]{0x00,0x11,0x22,0x33,0x44,0x55,0x66,0x77,(byte) 0x88,(byte) 0x99,(byte) 0xaa,(byte) 0xbb};
		//写数据
		READER_ERR er=Jreader.WriteTagData(1, (char)1, 2, data, 6, pwd.getBytes(), (short)1000);
		
		byte[] datar=new byte[12];
		//读数据
		/*
		 * READER_ERR GetTagData(int ant,char bank, int address, int blkcnt,byte[] data, byte[] accesspasswd, short timeout);
		 * ant 操作的单天线
		 * bank 表示区域 0表示保留区 1表示epc区 2表示tid区 3表示user区
		 * address 表示地址块， 注意epc区从第二块开始
		 * blkcnt 表示读块数
		 * data 存放数据的字节，应该不小于blkcnt*2
		 * accesspwd 表示密码，默认"00000000" 8个十六进制字符
		 * timeout 操作超时时间
		 */
		er=Jreader.GetTagData(1, (char)1, 2, 6, datar, null, (short)1000);
		String str1="";
	
		for(int i=0;i<12;i++)
		{
			str1+=Integer.toHexString(datar[i]&0xff);
		}
		System.out.println(er.toString()+" "+str1.toUpperCase());
		
		byte[] data2=new byte[]{(byte) 0xFF,0x01,0x22,0x03,0x44,0x05,0x66,0x07,(byte) 0x88,(byte) 0x09,(byte) 0xaa,(byte) 0x0b};

		er=Jreader.WriteTagEpcEx(1, data2, 12, null, (short)1000);
		
		er=Jreader.GetTagData(1, (char)1, 2, 6, datar, null, (short)1000);
		
		str1="";
		
		for(int i=0;i<12;i++)
		{
			str1+=Integer.toHexString(datar[i]&0xff);
		}
		System.out.println(er.toString()+" "+str1.toUpperCase());

	}
	
	public void testblockop()
	{
		 String pwd="11000000";
		  byte[] data=new byte[4];
	      Jreader.Str2Hex(pwd, pwd.length(), data);
		//擦除块
		READER_ERR er=Jreader.BlockErase(1, (char)1, 2, 12, data, (short)1000);
		
		//永久锁块
		 Jreader.BlockPermaLock(1, 1, 2, 6, new byte[]{(byte) 0xff,(byte) 0xff}, data, (short)1000);
	
	}
	public void testinventory2()
	{
		int[] tagcnt=new int[1];
		TAGINFO taginfo = Jreader.new TAGINFO();
		READER_ERR er=Jreader.TagInventory_Raw(new int[]{1}, 1, (short)1000, tagcnt);
	    er=Jreader.GetNextTag(taginfo);
	    if(taginfo!=null)
	    	System.out.println("inv2_epc:"+Reader.bytes_Hexstr(taginfo.EpcId));

		byte[] outbuf=new byte[800];
		
		er=Jreader.TagInventory_Raw(new int[]{1}, 1, (short)1000, tagcnt);
		er=Jreader.GetNextTag_BaseType(outbuf);
		
	}
	public void testdataonreader()
	{
		byte[] data3=new byte[100];
		READER_ERR er=Jreader.ReadDataOnReader(0, data3, 100);
		 er=Jreader.SaveDataOnReader(0, data3, 100);
		
		//擦除读写器上数据
		 er=Jreader.EraseDataOnReader();
	}
	
	public void testkilltag()
	{
		  String pwd="11000000";
		  byte[] data=new byte[4];
	      Jreader.Str2Hex(pwd, pwd.length(), data);
		  READER_ERR er=Jreader.KillTag(1, data, (short) 1000);
	}
	
	public void testlocktag()
	{
		 String pwd="12340000";
		 // READER_ERR er=Jreader.Lock180006BTag(1, 2, 6, (short) 1000);
		  byte[] data=new byte[4];
	      Jreader.Str2Hex(pwd, pwd.length(), data);
		 
			//写数据
		  READER_ERR er=Jreader.WriteTagData(1, (char)0, 2, data, 2, null, (short)1000);
		  er=Jreader.LockTag(1, (byte)Lock_Obj.LOCK_OBJECT_BANK1.value(), (short)Lock_Type.BANK1_LOCK.value(), data, (short)1000);
		  
		//写数据
		  er=Jreader.WriteTagData(1, (char)1, 2, new byte[]{0x11,0x22}, 2, null, (short)1000);
		  System.out.println("no pwd write"+er.toString());
		  
		//写数据
		  er=Jreader.WriteTagData(1, (char)1, 2, new byte[]{0x11,0x22}, 2, data, (short)1000);
		  System.out.println("pwd write"+er.toString());
		  
		  er=Jreader.LockTag(1, (byte)Lock_Obj.LOCK_OBJECT_BANK1.value(), (short)Lock_Type.BANK1_UNLOCK.value(), data, (short)1000);
	}
	public void testsetip()
	{
		Reader_Ip rip=Jreader.new Reader_Ip();
		 
		rip.ip="192.168.1.101".getBytes();
		rip.mask="255.255.255.0".getBytes();
		rip.gateway="192.168.1.1".getBytes();
		//*/
		
		READER_ERR er=Jreader.ParamSet(Mtr_Param.MTR_PARAM_READER_IP, rip);
		
	}
	@Override
	public boolean onCreateOptionsMenu(Menu menu) {
		// Inflate the menu; this adds items to the action bar if it is present.
		getMenuInflater().inflate(R.menu.main, menu);
		return true;
	}
   
	@Override
	public void onStop()
	{
		switch(PdaType)
		{
			case 0:
			break;
			case 1:
				try
				{
			       module=Module.getInstance();
			       module.powerOff(3);
			     
				}catch(ConfigurationException ce)
				{
					
				}
				break;
			case 2:
				commnandList.add("echo 1 >/sys/devices/platform/gpio_test/uart1power");
				@SuppressWarnings("unused")
				CommandResult result = ShellUtils.execCommand(commnandList,false);
				//Toast.makeText(MainActivity.this, "返回："+String.valueOf(result.result),Toast.LENGTH_SHORT).show();
				break;
			case 3:
				if(scan==null)
				{try
				{
				   scan=new Scan();
				   //Toast.makeText(MainActivity.this, "返回:gpio ok",Toast.LENGTH_SHORT).show();
				}
				catch(Exception ex)
				{
					//Toast.makeText(MainActivity.this, "返回:gpio failed",Toast.LENGTH_SHORT).show();
					return;
				}
				}
				scan.ctrl(0x0F);
				//Toast.makeText(MainActivity.this, "返回："+String.valueOf(re),Toast.LENGTH_SHORT).show();
				break;
		}
		
		
		super.onStop();
	}
	
	@Override
	public boolean onKeyDown(int keyCode, KeyEvent event) {
		// TODO Auto-generated method stub
		//中间扫描键 右侧扫描键 左侧扫描键
		//Toast.makeText(MainActivity.this, "按钮键值:"+String.valueOf(keyCode),Toast.LENGTH_SHORT).show();

		if (keyCode==139||keyCode==140||keyCode==141) {
			String txt=button_read.getText().toString();
			if(txt.equals("读"))
			{
				handler.postDelayed(runnable,0); 
				button_read.setText("停");
			}
			else
			{
				handler.removeCallbacks(runnable); 
				button_read.setText("读");
			}
		}
	 
		if(keyCode==138)
		{
			synchronized (this)
			{
				AntPowerConf apcf=Jreader.new AntPowerConf();
				AntPowerConf apcf2=Jreader.new AntPowerConf();
				READER_ERR er=Jreader.ParamGet(Mtr_Param.MTR_PARAM_RF_ANTPOWER, apcf2);
				short st=apcf2.Powers[0].readPower;
				if(st>=3000)
				{
					Toast.makeText(MainActivity.this, "已经最大功率",Toast.LENGTH_SHORT).show();
				}
				
				apcf.antcnt=1;
				st+=100;
				for(int i=0;i<apcf.antcnt;i++)
				{
					AntPower jaap=Jreader.new AntPower();
					jaap.antid=i+1;
					jaap.readPower=st;
					jaap.writePower=st;
					apcf.Powers[i]=jaap; 
				}
				
				 er=Jreader.ParamSet(Mtr_Param.MTR_PARAM_RF_ANTPOWER, apcf);
			    if(er==READER_ERR.MT_HARDWARE_ALERT_ERR_BY_TOO_MANY_RESET.MT_OK_ERR)
			    	Toast.makeText(MainActivity.this, "设置:"+String.valueOf(st),Toast.LENGTH_SHORT).show();
			    else
			    	Toast.makeText(MainActivity.this, "设置失败",Toast.LENGTH_SHORT).show();


			}
		}
		
		if(keyCode==135)
		{
			synchronized (this)
			{
				synchronized (this)
				{
					AntPowerConf apcf=Jreader.new AntPowerConf();
					AntPowerConf apcf2=Jreader.new AntPowerConf();
					READER_ERR er=Jreader.ParamGet(Mtr_Param.MTR_PARAM_RF_ANTPOWER, apcf2);
					short st=apcf2.Powers[0].readPower;
					if(st<=500)
					{
						Toast.makeText(MainActivity.this, "已经最大功率",Toast.LENGTH_SHORT).show();
					}
					
					apcf.antcnt=1;
					st-=100;
					for(int i=0;i<apcf.antcnt;i++)
					{
						AntPower jaap=Jreader.new AntPower();
						jaap.antid=i+1;
						jaap.readPower=st;
						jaap.writePower=st;
						apcf.Powers[i]=jaap; 
					}
					
					 er=Jreader.ParamSet(Mtr_Param.MTR_PARAM_RF_ANTPOWER, apcf);
				    if(er==READER_ERR.MT_OK_ERR)
				    	Toast.makeText(MainActivity.this, "设置:"+String.valueOf(st),Toast.LENGTH_SHORT).show();
				    else
				    	Toast.makeText(MainActivity.this, "设置失败",Toast.LENGTH_SHORT).show();


				}
			}
		}
		return super.onKeyDown(keyCode, event);
	}
}
