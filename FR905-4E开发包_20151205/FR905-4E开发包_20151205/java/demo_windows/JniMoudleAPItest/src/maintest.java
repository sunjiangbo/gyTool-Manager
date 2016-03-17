import com.uhf.api.cls.Reader;
import com.uhf.api.cls.Reader.*;
 


public class maintest {

	/**
	 * @param args
	 */
	
	int AntCount=1;
	String ReaderAddr="com3";
	Reader Jreader;
	public maintest()
	{
		Jreader=new Reader();
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
		System.out.println("test tohexstr:"+hstr);
		
		String buf="0011110000001111";
	 
		byte[] binarybuf=new byte[2];
		String buf2="abcdef08";
		byte[] hexbuf=new byte[4];
		Jreader.Str2Binary(buf, buf.length(), binarybuf);
		System.out.println("test binary:");
		for(int i=0;i<binarybuf.length;i++)
			System.out.println(binarybuf[i]);
		
		Jreader.Str2Hex(buf2, 8, hexbuf);
		System.out.println("test hex:");
		for(int i=0;i<hexbuf.length;i++)
			System.out.println(hexbuf[i]);
	}
	
	public void testpsam()
	{
		int soltid=1;
		int coslen=2;
		byte[] cos=new byte[]{0x11,0x22,0x33,0x44,0x55,0x66,0x77,(byte) 0x88,(byte) 0x99,0x12,0x34};
		int[] cosresplen=new int[1];
		byte[] cosresp=new byte[cos.length+13];
		byte[] errcode=new byte[4];
		
		READER_ERR er=Jreader.PsamTransceiver(soltid, coslen, cos, cosresplen, cosresp,
				errcode, (short)1000);
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
		
		String pwd="00000000";
		byte[] data=new byte[]{0x00,0x11,0x22,0x33,0x44,0x55,0x66,0x77,(byte) 0x88,(byte) 0x99,(byte) 0xaa,(byte) 0xbb};
		  byte[] pwdb=new byte[4];
	      Jreader.Str2Hex(pwd, pwd.length(), pwdb);
		//写数据
		READER_ERR er=Jreader.WriteTagData(1, (char)1, 2, data, 6, pwdb, (short)1000);
		
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
	
	public void testinitreader()
	{
		//创建读写器
		/* 根据天线口连接读写器
		 *   src 是地址 ip地址或者串口号
		 *   rtype 是天线口数，4口天线传入4
		 *   返回类型：READER_ERR ,MT_OK_ERR表示正常，其他表示错误
		 */
		//READER_ERR er=Jreader.InitReader("com3",Reader_Type.MODULE_FOUR_ANTS);
		READER_ERR er=Jreader.InitReader_Notype(ReaderAddr,AntCount);
		System.out.println(er.toString());
		
		
		/*
		 * 构建天线组功率：AntPowerConf  
		 * 成员：
		 * AntPower数组
		 * antcnt表示天线个数
		 * AntPower类型 
		 * antid 天线号
		 * readPower 读功率
		 * writePower 写功率 
		 */
		
		AntPowerConf apcf=Jreader.new AntPowerConf();
		apcf.antcnt=AntCount;
		for(int i=0;i<apcf.antcnt;i++)
		{
			AntPower jaap=Jreader.new AntPower();
			jaap.antid=i+1;
			jaap.readPower=2800;
			jaap.writePower=2750;
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
		
		/*
		 * 设置是否检查天线
		 * 当参数值传入1的时候表示要检查，0表示不检查
		 */
		er=Jreader.ParamSet(Mtr_Param.MTR_PARAM_READER_IS_CHK_ANT, 0);
	}
	
	public void testinventory1()
	{
		/*
		   * 
		   * 设置频率，对于某天线设置频率表可以提搞读效果
		   * HoptableData_ST 天线频率表类
		   * lenhtb 表示频率表长度
		   * htb 数组int类型，表示具体频点
		HoptableData_ST hdst=Jreader.new HoptableData_ST();
		hdst.lenhtb=2;
		hdst.htb[0]=915250;
		hdst.htb[1]=915750;

		READER_ERR er=Jreader.ParamSet(Mtr_Param.MTR_PARAM_FREQUENCY_HOPTABLE,hdst);
		*/
		
		
		 /* ants 轮询使用的天线，即连接天线口的天线
		 * antcnt 使用的天线个数
		 * timeout 读标签的时间
		 * pTInfo 存放标签数据的数组
		 * tagcnt 存放标签的个数，只需传入一个元素的数组
		 */
		  int[] tagcnt=new int[1];
		  TAGINFO[] taginfo=new TAGINFO[200];
		  READER_ERR er=Jreader.TagInventory(new int[]{1}, 1, (short)1000, taginfo, tagcnt);
		  if(er==READER_ERR.MT_OK_ERR)
		  {
			  for(int i=0;i<tagcnt[0];i++)
			  {
				  
				  System.out.println("inv1_epc:"+Reader.bytes_Hexstr(taginfo[i].EpcId));
			  }
		  }
	}
	
	public void testinventory2()
	{
		int[] tagcnt=new int[1];
		TAGINFO taginfo = Jreader.new TAGINFO();
		READER_ERR er=Jreader.TagInventory_Raw(new int[]{1}, 1, (short)1000, tagcnt);
		for(int i=0;i<tagcnt[0];i++)
	    {
			er=Jreader.GetNextTag(taginfo);
	    if(taginfo!=null)
	    	System.out.println("inv2_epc:"+Reader.bytes_Hexstr(taginfo.EpcId));
	    }

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
		/*
		rip.ip=new byte[]{'1','9','2','.','1','6','8','.','1','.','1','0','1'};
		rip.mask=new byte[]{'2','5','5','.','2','5','5','.','2','5','5','.','0'};
		rip.gateway=new byte[]{'1','9','2','.','1','6','8','.','1','.','2','5','4'};
		//*/
		
		rip.ip="192.168.1.100".getBytes();
		rip.mask="255.255.255.0".getBytes();
		rip.gateway="192.168.1.1".getBytes();
		//*/
		
		READER_ERR er=Jreader.ParamSet(Mtr_Param.MTR_PARAM_READER_IP, rip);
		
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
	
	public void testgpio()
	{
		 READER_ERR er=Jreader.SetGPO(1, 1);
		 er=Jreader.SetGPO(2, 0);
		 er=Jreader.SetGPO(3, 0);
		 er=Jreader.SetGPO(4, 1);
		 
		 int[] val=new int[1];
		 er=Jreader.GetGPI(1, val);
		 er=Jreader.GetGPI(2, val);
		 er=Jreader.GetGPI(3, val);
		 er=Jreader.GetGPI(4, val);
	}
	
	
	public static void main(String[] args) {
		// TODO Auto-generated method stub
		
		maintest mt=new maintest();
         //测试初始化
	     mt.testinitreader();
	     //测试转换
	     //mt.testtran();
	     //测试gpio
	     //mt.testgpio();
	     //测试参数
	    //mt.testrparams();
	    //测试块操作
	    //mt.testblockop();
	    //测试特殊指令
	    //mt.testcustomcmd();
	    //测试读写器内部数据
	    //mt.testdataonreader();
	    //测试盘点方式1
	     //mt.testinventory1();
	    //测试盘点方式2
	    //mt.testinventory2();
	    //测试销毁密码
	    //mt.testkilltag();
	    //测试锁标签
	    //mt.testlocktag();
	    //测试读写标签
	     mt.testreadandwrite();
	    //测试改ip地址
	     //mt.testsetip();
	     
	     //测试psam
	     //mt.testpsam();
	     
		//关闭读写器
		mt.Jreader.CloseReader();
		System.out.println("test over");
	}

}
