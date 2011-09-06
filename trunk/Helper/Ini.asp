<%
if APP_ = "" or isNull(APP_) then 
	response.write ("No direct script access allowed")
	response.end
end if
'*************************************************************
'	class		: A ini class
'	File Name	: Ini.asp
'	Version		: 0.2.0
'	Author		: Andy Cai
'	License		: Dual licensed under the MIT (MIT-LICENSE.txt)
'				  and GPL (GPL-LICENSE.txt) licenses.
'	Date		: 2007-11-1
'*************************************************************


'*************************************************************
'	Sample of usage of the class
'*************************************************************

''============================= ����˵�� =========================
''=      ini.openFile = �ļ�·����ʹ������·�������ⲿ���壩  =
''=      ini.Codeset  = �������ã�Ĭ��Ϊ GB2312               =
''=      ini.Istrue   = ����ļ��Ƿ����������ڣ�              =
''============================= ����˵�� =========================
''=      isGroup(����)            ������Ƿ����       =
''=      isNode(����,�ڵ���)            ���ڵ��Ƿ����     =
''=      getGroup(����)            ��ȡ����Ϣ           =
''=      countGroup()            ͳ��������           =
''=      readNode(����,�ڵ���)            ��ȡ�ڵ�����         =
''=      writeGroup(����)            ������               =
''=      writeNode(��,�ڵ�,�ڵ�����)      ����/���½ڵ�����    =
''=      deleteGroup(����)            ɾ����               =
''=      deleteNode(����,�ڵ���)      ɾ���ڵ�             =
''=      save()                  �����ļ�             =
''=      close()                  ����ڲ����ݣ��ͷţ� =
''================================================================

dim ini
set ini = New Kiss_ini
ini.openFile = Server.MapPath("Config.ini")
'' Write data to .ini file
ini.writeNode("SiteConfig","SiteName","Leadbbs������̳")
ini.writeNode("SiteConfig","Mail","leadbbs@leadbbs.com")
ini.save()
'' Read data from .ini file
Response.Write("վ�����ƣ�" & ini.readNode("SiteConfig","SiteName"))

'*************************************************************
'	Initialize the class
'*************************************************************

class Kiss_ini
	''==================================================
    private Stream            ''// Stream ����
    private FilePath      ''// �ļ�·��
   
    public Content            ''// �ļ�����
    public Istrue            ''// �ļ��Ƿ����
    public IsAnsi            ''// ��¼�Ƿ������
    public Codeset            ''// ���ݱ���
	''==================================================
   
    ''// ��ʼ��
    private sub class_Initialize()
          set Stream      = Server.CreateObject("ADODB.Stream")
          Stream.Mode      = 3
          Stream.Type      = 2
          Codeset            = "gbk"
          IsAnsi            = true
          Istrue            = true
    end sub
   
    ''// ��������ת��Ϊ�ַ���
    private function Bytes2bStr(bStr)
          if Lenb(bStr)=0 then
                Bytes2bStr = ""
                exit function
          end if
         
          dim BytesStream,StringReturn
          set BytesStream = Server.CreateObject("ADODB.Stream")
          With BytesStream
                .Type        = 2
                .Open
                .WriteText   bStr
                .Position    = 0
                .Charset     = Codeset
                .Position    = 2
                StringReturn = .ReadText
                .close
          end With
          Bytes2bStr       = StringReturn
          set BytesStream       = Nothing
          set StringReturn = Nothing
    end function
   
    ''// �����ļ�·��
    property let openFile(iniFilePath)
          FilePath = iniFilePath
          Stream.Open
          On Error Resume next
          Stream.LoadFromFile(FilePath)
          ''// �ļ�������ʱ���ظ� Istrue
          if Err.Number<>0 then
                Istrue = false
                Err.Clear
          end if
          Content = Stream.ReadText(Stream.Size)
          if Not IsAnsi then Content=Bytes2bStr(Content)
    end property
   
    ''// ������Ƿ����[����:����]
    public function isGroup(GroupName)
          if Instr(Content,"["&GroupName&"]")>0 then
                isGroup = true
          else
                isGroup = false
          end if
    end function
   
    ''// ��ȡ����Ϣ[����:����]
    public function getGroup(GroupName)
          dim TempGroup
          if Not isGroup(GroupName) then exit function
          ''// ��ʼѰ��ͷ����ȡ
          TempGroup = Mid(Content,Instr(Content,"["&GroupName&"]"),Len(Content))
          ''// �޳�β��
          if Instr(TempGroup,VbCrlf&"[")>0 then TempGroup=Left(TempGroup,Instr(TempGroup,VbCrlf&"[")-1)
          if Right(TempGroup,1)<>Chr(10) then TempGroup=TempGroup&VbCrlf
          getGroup = TempGroup
    end function
   
    ''// ���ڵ��Ƿ����[����:����,�ڵ���]
    public function isNode(GroupName,NodeName)
          if Instr(getGroup(GroupName),NodeName&"=") then
                isNode = true
          else
                isNode = false
          end if
    end function
   
    ''// ������[����:����]
    public sub writeGroup(GroupName)
          if Not isGroup(GroupName) And GroupName<>"" then
                Content = Content & "[" & GroupName & "]" & VbCrlf
          end if
    end sub
   
    ''// ��ȡ�ڵ�����[����:����,�ڵ���]
    public function readNode(GroupName,NodeName)
          if Not isNode(GroupName,NodeName) then exit function
          dim TempContent
          ''// ȡ����Ϣ
          TempContent = getGroup(GroupName)
          ''// ȡ��ǰ�ڵ�����
          TempContent = Right(TempContent,Len(TempContent)-Instr(TempContent,NodeName&"=")+1)
          TempContent = Replace(Left(TempContent,Instr(TempContent,VbCrlf)-1),NodeName&"=","")
          readNode = ReplaceData(TempContent,0)
    end function
   
    ''// д��ڵ�����[����:����,�ڵ���,�ڵ�����]
    public sub writeNode(GroupName,NodeName,NodeData)
          ''// �鲻����ʱд����
          if Not isGroup(GroupName) then writeGroup(GroupName)
         
          ''// Ѱ��λ�ò�������
          ''/// ��ȡ��
          dim TempGroup : TempGroup = getGroup(GroupName)
         
          ''/// ����β��׷��
          dim NewGroup
          if isNode(GroupName,NodeName) then
                NewGroup = Replace(TempGroup,NodeName&"="&ReplaceData(readNode(GroupName,NodeName),1),NodeName&"="&ReplaceData(NodeData,1))
          else
                NewGroup = TempGroup & NodeName & "=" & ReplaceData(NodeData,1) & VbCrlf
          end if
         
          Content = Replace(Content,TempGroup,NewGroup)
    end sub
   
    ''// ɾ����[����:����]
    public sub deleteGroup(GroupName)
          Content = Replace(Content,getGroup(GroupName),"")
    end sub
   
   
    ''// ɾ���ڵ�[����:����,�ڵ���]
    public sub deleteNode(GroupName,NodeName)
          dim TempGroup
          dim NewGroup
          TempGroup = getGroup(GroupName)
          NewGroup = Replace(TempGroup,NodeName&"="&readNode(GroupName,NodeName)&VbCrlf,"")
          if Right(NewGroup,1)<>Chr(10) then NewGroup = NewGroup&VbCrlf
          Content = Replace(Content,TempGroup,NewGroup)
    end sub
   
    ''// �滻�ַ�[ʵ��:�滻Ŀ��,����������]
    ''      �ַ�ת��[��ֹ�ؼ����ų���]
    ''      [            --->      {(@)}
    ''      ]            --->      {(#)}
    ''      =            --->      {($)}
    ''      �س�      --->      {(1310)}
    public function ReplaceData(Data_Str,IsIn)
          if IsIn then
                ReplaceData = Replace(Replace(Replace(Data_Str,"[","{(@)}"),"]","{(#)}"),"=","{($)}")
                ReplaceData = Replace(ReplaceData,Chr(13)&Chr(10),"{(1310)}")
          else
                ReplaceData = Replace(Replace(Replace(Data_Str,"{(@)}","["),"{(#)}","]"),"{($)}","=")
                ReplaceData = Replace(ReplaceData,"{(1310)}",Chr(13)&Chr(10))
          end if
    end function
   
    ''// �����ļ�����
    public sub save()
          With Stream
                .close
                .Open
                .WriteText Content
                .saveToFile FilePath,2
          end With
    end sub
   
    ''// �رա��ͷ�
    public sub close()
          set Stream = Nothing
          set Content = Nothing
    end sub
   
end class

%>