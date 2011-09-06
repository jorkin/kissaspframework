<%
if APP_ = "" or isNull(APP_) then 
	response.write ("No direct script access allowed")
	response.end
end if
'*************************************************************
'	class		: A database to excel class
'	File Name	: DbtoExcel.asp
'	Version		: 0.2.0
'	Author		: Andy Cai
'	License		: Dual licensed under the MIT (MIT-LICENSE.txt)
'				  and GPL (GPL-LICENSE.txt) licenses.
'	Date		: 2007-11-1
'*************************************************************


'*************************************************************
'	Sample of usage of the class
'*************************************************************

'*** code

'*************************************************************
'	Initialize the class
'*************************************************************

class Kiss_DbtoExcel
	' ע��:�˰汾������ʱֻ֧��һ��ת��һ�����ݱ���һ�����ݱ�ֻ�ܶ�Ӧһ��Excel�ļ������ת��һ�����ݱ�󲻸���TargetFile�������򽫸�����ǰ�ı����ݣ�������
	' ʹ�÷�������ϸ�Ķ������ע��˵��!!
	''/***************************************************************************
	''/*
	''/*������ʹ�ô�������������װ��Office��Excel�����򣬷���ʹ��ʱ���ܲ���ת������
	''/*      �˰汾������ʱֻ֧��һ��ת��һ�����ݱ���һ�����ݱ�ֻ�ܶ�Ӧһ��Excel�ļ���
	''/*      ���ת��һ�����ݱ�󲻸���TargetFile�������򽫸�����ǰ�ı����ݣ�������
	''/*�÷���
	''/*����һ����Access���ݿ��ļ� TO Excel���ݿ��ļ���
	''/*1��������Դ���ݿ��ļ�SourceFile����ѡ����Ŀ�����ݿ��ļ�TargetFile����ѡ��
	''/*2����ʹ��Transfer("Դ����","�ֶ��б�","ת������")����ת������
	''/*���ӣ�
	''/*   dim sFile,tFile,Objclass,sResult
	''/*   sFile=Server.MapPath("data/data.mdb")
	''/*   tFile=Server.Mappath(".")&"\back.xls"
	''/*   set Objclass=New DataBaseToExcel
	''/*   Objclass.SourceFile=sFile
	''/*   Objclass.TargetFile=tFile
	''/*   sResult=Objclass.Transfer("table1","","")
	''/*   if sResult then
	''/*      Response.Write "ת�����ݳɹ���"
	''/*   else
	''/*      Response.Write "ת������ʧ�ܣ�"
	''/*   end if
	''/*   set Objclass=Nothing
	''/*
	''/*�����������������ݿ��ļ� To Excel���ݿ��ļ�)
	''/*1������Ŀ�����ݿ��ļ�TargetFile
	''/*2������Adodb.Connection����
	''/*3����ʹ��Transfer("Դ����","�ֶ��б�","ת������")����ת������
	''/*���ӣ�(�ڴ�ʹ��Access������Դ�����ӣ������ʹ����������Դ��
	''/*   dim Conn,ConnStr,tFile,Objclass,sResult
	''/*   tFile=Server.Mappath(".")&"\back.xls"
	''/*   set Conn=Server.CreateObject("ADODB.Connection")
	''/*   ConnStr="Provider=Microsoft.Jet.OLEDB.4.0;Data Source=" & Server.MapPath("data/data.mdb")
	''/*   Conn.Open ConnStr
	''/*   set Objclass=New DataBaseToExcel
	''/*   set Objclass.Conn=Conn        ''�˴��ؼ�
	''/*   Objclass.TargetFile=tFile
	''/*   sResult=Objclass.Transfer("table1","","")
	''/*   if sResult then
	''/*      Response.Write "ת�����ݳɹ���"
	''/*   else
	''/*      Response.Write "ת������ʧ�ܣ�"
	''/*   end if
	''/*   set Objclass=Nothing
	''/*   Conn.Close
	''/*   set Conn=Nothing
	''/*  
	''/*˵����TargetFile����һ��Ҫ���ã��������ļ���ַ�����Ե�ַ����
	''/*      ���������SourceFile��һ��Ҫ����Conn�����������Ա�ѡ֮һ��������Ȩ��Conn
	''/*      ������Transfer("Դ���ݱ���","�ֶ��б�","ת������")
	''/*           ���ֶ��б�ת����������ʽ��SQL�ġ��ֶ��б�,����ѯ��������ʽ��ͬ
	''/*            "�ֶ��б�"Ϊ�����������ֶΣ�����ѯ������Ϊ�����ȡ��������
	''/***************************************************************************
	private s_Conn
	private objExcelApp,objExcelSheet,objExcelBook
	private sChar,endChar
	''/***************************************************************************
	''/*             ȫ�ֱ���
	''/*�ⲿֱ��ʹ�ã�[Obj].SourceFile=Դ�ļ���   [Obj].TargetFile=Ŀ���ļ���
	''/***************************************************************************
	public SourceFile,TargetFile

	private sub class_Initialize
		   sChar="ABCDEFGHIJKLNMOPQRSTUVWXYZ"
			  objExcelApp=Null
		   s_Conn=Null
	end sub
	private sub class_Terminate
		   if IsObject(s_Conn) And Not IsNull(s_Conn) then
				 s_Conn.Close
				 set s_Conn=Nothing
			  end if
		   CloseExcel
	end sub

	''/***************************************************************************
	''/*             ����/����Conn����
	''/*˵������������Ϊ���������ݿ�(�磺MSSQL����ACCESS���ݿ������ת�ƶ����õ�
	''/***************************************************************************
	public property set Conn(sNewValue)
		  if Not IsObject(sNewValue) then
			  s_Conn=Null
		   else
			  set s_Conn=sNewValue
		   end if
	end property
	public property get Conn
		  if IsObject(s_Conn) then
			  set Conn=s_Conn
		   else
			  s_Conn=Null
		   end if
	end property

	''/***************************************************************************
	''/*             ����ת��
	''/*�������ܣ�ת��Դ���ݵ�TargetFile���ݿ��ļ�
	''/*����˵��������SQL����Select Into In����ת��
	''/*�������أ�����һЩ״̬����true = ת�����ݳɹ�   false = ת������ʧ��
	''/*����������sTableName = Դ���ݿ�ı���
	''/*         sCol = Ҫת�����ݵ��ֶ��б���ʽ��ͬSelect ���ֶ��б��ʽ��ͬ
	''/*         sSql = ת������ʱ������ ͬSQL����Where ��������ʽһ��
	''/***************************************************************************
	public function Transfer(sTableName,sCol,sSql)
	On Error Resume next
	dim SQL,Rs
	dim iFieldsCount,iMod,iiMod,iCount,i
		   if TargetFile="" then         ''û��Ŀ�걣���ļ���ת��ʧ��
			  Transfer=false
				exit function
		   end if
		  if Not InitConn then          ''������ܳ�ʼ��Conn������ת�����ݳ���
			  Transfer=false
				exit function
		   end if
		  if Not InitExcel then         ''������ܳ�ʼ��Excel������ת�����ݳ���
			  Transfer=false
				exit function
		   end if
		  if sSql<>"" then              ''������ѯ
			  sSql=" Where "&sSql
		   end if
		   if sCol="" then               ''�ֶ��б�,��","�ָ�
			  sCol="*"
		   end if
		   set Rs=Server.CreateObject("ADODB.Recordset")
		  SQL="SELECT "&sCol&" From ["&sTableName&"]"&sSql
		   Rs.Open SQL,s_Conn,1,1
		   if Err.Number<>0 then         ''������ת�����ݴ��󣬷���ת�����ݳɹ�
			  Err.Clear
			 Transfer=false
				set Rs=Nothing
				CloseExcel
				exit function
		   end if
		  iFieldsCount=Rs.Fields.Count
		  ''û�ֶκ�û�м�¼���˳�
		  if iFieldsCount<1 Or Rs.Eof then
			 Transfer=false
				set Rs=Nothing
				CloseExcel
				exit function
		  end if
		  ''��ȡ��Ԫ��Ľ�β��ĸ
		  iMod=iFieldsCount Mod 26
		  iCount=iFieldsCount \ 26
		  if iMod=0 then
			   iMod=26
			   iCount=iCount
		  end if
		  endChar=""
		  Do While iCount>0
			   iiMod=iCount Mod 26
			   iCount=iCount \ 26
			   if iiMod=0 then
					iiMod=26
				  iCount=iCount
			   end if
			   endChar=Mid(sChar,iiMod,1)&endChar
		  Loop
		  endChar=endChar&Mid(sChar,iMod,1)
		  dim sExe    ''�����ַ���

		  ''�ֶ����б�
		  i=1
		  sExe="objExcelSheet.Range(""A"&i&":"&endChar&i&""").Value = Array("
		  for iMod=0 To iFieldsCount-1
			  sExe=sExe&""""&Rs.Fields(iMod).Name
				if iMod=iFieldsCount-1 then
					 sExe=sExe&""")"
				else
				   sExe=sExe&""","
				end if
		  next
		  Execute sExe      ''д�ֶ���
		  if Err.Number<>0 then         ''������ת�����ݴ��󣬷���ת�����ݳɹ�
			 Err.Clear
			Transfer=false
			   Rs.Close
			   set Rs=Nothing
			   CloseExcel
			   exit function
		  end if
		  i=2
		  Do Until Rs.Eof
			   sExe="objExcelSheet.Range(""A"&i&":"&endChar&i&""").Value = Array("
			   for iMod=0 to iFieldsCount-1
				 sExe=sExe&""""&Rs.Fields(iMod).Value
				   if iMod=iFieldsCount-1 then
						sExe=sExe&""")"
					 else
					sExe=sExe&""","
					 end if
			   next
			   Execute sExe               ''д��i����¼
			   i=i+1
			   Rs.Movenext
		  Loop
		  if Err.Number<>0 then         ''������ת�����ݴ��󣬷���ת�����ݳɹ�
			 Err.Clear
			Transfer=false
			   Rs.Close
			   set Rs=Nothing
			   CloseExcel
			   exit function
		  end if
		  ''�����ļ�
		  objExcelBook.SaveAs  TargetFile
		  if Err.Number<>0 then         ''������ת�����ݴ��󣬷���ת�����ݳɹ�
			 Err.Clear
			Transfer=false
			   Rs.Close
			   set Rs=Nothing
			   CloseExcel
			   exit function
		  end if
		  Rs.Close
		  set Rs=Nothing
		  CloseExcel
		 Transfer=true
	end function

	''/***************************************************************************
	''/*             ��ʼ��Excel�������
	''/*
	''/***************************************************************************
	private function InitExcel()
	On Error Resume next
		   if Not IsObject(objExcelApp) Or IsNull(objExcelApp) then
				 set objExcelApp=Server.CreateObject("Excel.Application")
				 objExcelApp.DisplayAlerts = false
				 objExcelApp.Application.Visible = false
				 objExcelApp.WorkBooks.add
				 set objExcelBook=objExcelApp.ActiveWorkBook
			  set objExcelSheet = objExcelBook.Sheets(1)
				 if Err.Number<>0 then
				 CloseExcel
					  InitExcel=false
					  Err.Clear
					  exit function
				 end if
			  end if
			  InitExcel=true
	end function
	private sub CloseExcel
	On Error Resume next
		   if IsObject(objExcelApp) then
				 objExcelApp.Quit
				 set objExcelSheet=Nothing
				 set objExcelBook=Nothing
				 set objExcelApp=Nothing
			  end if
			objExcelApp=Null
	end sub

	''/***************************************************************************
	''/*             ��ʼ��Adodb.Connection�������
	''/*
	''/***************************************************************************
	private function InitConn()
	On Error Resume next
	dim ConnStr
		   if Not IsObject(s_Conn) Or IsNull(s_Conn) then
				 if SourceFile="" then
					InitConn=false
					  exit function
				 else
					set s_Conn=Server.CreateObject("ADODB.Connection")
					ConnStr="Provider=Microsoft.Jet.OLEDB.4.0;Data Source=" & SourceFile
					s_Conn.Open ConnStr
					  if Err.Number<>0 then
						 InitConn=false
						   Err.Clear
						   s_Conn=Null
						   exit function
					  end if
				 end if
			  end if
			  InitConn=true
	end function
end class
%>