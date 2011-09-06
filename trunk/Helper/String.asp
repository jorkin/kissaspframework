<%
if APP_ = "" or isNull(APP_) then 
	response.write ("No direct script access allowed")
	response.end
end if
'*************************************************************
'	class		: A String operating class
'	File Name	: String.asp
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

class Kiss_String

	''****************************************************************************
	'''' @����˵��: ���ַ�����Ϊchar������
	'''' @����˵��:  - str [string]: ��Ҫת�����ַ���
	'''' @����ֵ:   - [Array] Char������
	''****************************************************************************
	public function toCharArray(byVal str)
	 redim charArray(len(str))
	 for i = 1 to len(str)
	  charArray(i-1) = Mid(str,i,1)
	 next
	 toCharArray = charArray
	end function

	''****************************************************************************
	'''' @����˵��: ��һ������ת����һ���ַ���
	'''' @����˵��:  - arr [Array]: ��Ҫת��������
	'''' @����ֵ:   - [string] �ַ���
	''****************************************************************************
	public function arrayToString(byVal arr)
	 for i = 0 to UBound(arr)
	  strObj = strObj & arr(i)
	 next
	 arrayToString = strObj
	end function

	''****************************************************************************
	'''' @����˵��: ���Դ�ַ���str�Ƿ���chars��ͷ
	'''' @����˵��:  - str [string]: Դ�ַ���
	'''' @����˵��:  - chars [string]: �Ƚϵ��ַ�/�ַ���
	'''' @����ֵ:   - [bool]
	''****************************************************************************
	public function startsWith(byVal str, chars)
	 if Left(str,len(chars)) = chars then
	  startsWith = true
	 else
	  startsWith = false
	 end if
	end function

	''****************************************************************************
	'''' @����˵��: ���Դ�ַ���str�Ƿ���chars��β
	'''' @����˵��:  - str [string]: Դ�ַ���
	'''' @����˵��:  - chars [string]: �Ƚϵ��ַ�/�ַ���
	'''' @����ֵ:   - [bool]
	''****************************************************************************
	public function endsWith(byVal str, chars)
	 if Right(str,len(chars)) = chars then
	  endsWith = true
	 else
	  endsWith = false
	 end if
	end function

	''****************************************************************************
	'''' @����˵��: ����N���ַ���str
	'''' @����˵��:  - str [string]: Դ�ַ���
	'''' @����˵��:  - n [int]: ���ƴ���
	'''' @����ֵ:   - [string] ���ƺ���ַ���
	''****************************************************************************
	public function clone(byVal str, n)
	 for i = 1 to n
	  value = value & str
	 next
	 clone = value
	end function

	''****************************************************************************
	'''' @����˵��: ɾ��Դ�ַ���str��ǰN���ַ�
	'''' @����˵��:  - str [string]: Դ�ַ���
	'''' @����˵��:  - n [int]: ɾ�����ַ�����
	'''' @����ֵ:   - [string] ɾ������ַ���
	''****************************************************************************
	public function trimStart(byVal str, n)
	 value = Mid(str, n+1)
	 trimStart = value
	end function

	''****************************************************************************
	'''' @����˵��: ɾ��Դ�ַ���str�����N���ַ���
	'''' @����˵��:  - str [string]: Դ�ַ���
	'''' @����˵��:  - n [int]: ɾ�����ַ�����
	'''' @����ֵ:   - [string] ɾ������ַ���
	''****************************************************************************
	public function trimend(byVal str, n)
	 value = Left(str, len(str)-n)
	 trimend = value
	end function

	''****************************************************************************
	'''' @����˵��: ����ַ�character�Ƿ���Ӣ���ַ� A-Z or a-z
	'''' @����˵��:  - character [char]: �����ַ�
	'''' @����ֵ:   - [bool] �����Ӣ���ַ�,����TRUE,��֮ΪFALSE
	''****************************************************************************
	public function isAlphabetic(byVal character)
	 asciiValue = cint(asc(character))
	 if (65 <= asciiValue and asciiValue <= 90) or (97 <= asciiValue and asciiValue <= 122) then
	  isAlphabetic = true
	 else
	  isAlphabetic = false
	 end if
	end function

	''****************************************************************************
	'''' @����˵��: ��str�ַ������д�Сдת��
	'''' @����˵��:  - str [string]: Դ�ַ���
	'''' @����ֵ:   - [string] ת������ַ���
	''****************************************************************************
	public function swapCase(str)
	 for i = 1 to len(str)
	  current = mid(str, i, 1)
	  if isAlphabetic(current) then
	   high = asc(ucase(current))
	   low = asc(lcase(current))
	   sum = high + low
	   return = return & chr(sum-asc(current))
	  else
	   return = return & current
	  end if
	 next
	 swapCase = return
	end function

	''****************************************************************************
	'''' @����˵��: ��Դ�ַ���str��ÿ�����ʵĵ�һ����ĸת���ɴ�д
	'''' @����˵��:  - str [string]: Դ�ַ���
	'''' @����ֵ:   - [string] ת������ַ���
	''****************************************************************************
	public function capitalize(str)
	 words = split(str," ")
	 for i = 0 to ubound(words)
	  if not i = 0 then
	   tmp = " "
	  end if
	  tmp = tmp & ucase(left(words(i), 1)) & right(words(i), len(words(i))-1)
	  words(i) = tmp
	 next
	 capitalize = arrayToString(words)
	end function

	''****************************************************************************
	'''' @����˵��: ��Դ�ַ�Str���е�''����Ϊ''''
	'''' @����˵��:  - str [string]: Դ�ַ���
	'''' @����ֵ:   - [string] ת������ַ���
	''****************************************************************************
	public function checkstr(Str)
	 if Trim(Str)="" Or IsNull(str) then
	  checkstr=""
	 else
	  checkstr=Replace(Trim(Str),"''","''''")
	 end if
	end function

	''****************************************************************************
	'''' @����˵��: ���ַ����е�str�е�HTML������й���
	'''' @����˵��:  - str [string]: Դ�ַ���
	'''' @����ֵ:   - [string] ת������ַ���
	''****************************************************************************
	public function HtmlEncode(str)
	 if Trim(Str)="" Or IsNull(str) then
	  HtmlEncode=""
	 else
	  str=Replace(str,">",">")
	  str=Replace(str,"<","<")
	  str=Replace(str,Chr(32)," ")
	  str=Replace(str,Chr(9)," ")
	  str=Replace(str,Chr(34),"""")
	  str=Replace(str,Chr(39),"'")
	  str=Replace(str,Chr(13),"")
	  str=Replace(str,Chr(10) & Chr(10), "</p><p>")
	  str=Replace(str,Chr(10),"<br> ")
	  HtmlEncode=str
	 end if
	end function

	''****************************************************************************
	'''' @����˵��: ����Դ�ַ���Str�ĳ���(һ�������ַ�Ϊ2���ֽڳ�)
	'''' @����˵��:  - str [string]: Դ�ַ���
	'''' @����ֵ:   - [Int] Դ�ַ����ĳ���
	''****************************************************************************
	public function strLen(Str)
	 if Trim(Str)="" Or IsNull(str) then
	  strlen=0
	 else
	  dim P_len,x
	  P_len=0
	  StrLen=0
	  P_len=Len(Trim(Str))
	  for x=1 To P_len
	   if Asc(Mid(Str,x,1))<0 then
		StrLen=Int(StrLen) + 2
	   else
		StrLen=Int(StrLen) + 1
	   end if
	  next
	 end if
	end function

	''****************************************************************************
	'''' @����˵��: ��ȡԴ�ַ���Str��ǰLenNum���ַ�(һ�������ַ�Ϊ2���ֽڳ�)
	'''' @����˵��:  - str [string]: Դ�ַ���
	'''' @����˵��:  - LenNum [int]: ��ȡ�ĳ���
	'''' @����ֵ:   - [string]: ת������ַ���
	''****************************************************************************
	public function CutStr(Str,LenNum)
	 dim P_num
	 dim I,X
	 if StrLen(Str)<=LenNum then
	  Cutstr=Str
	 else
	  P_num=0
	  X=0
	  Do While Not P_num > LenNum-2
	   X=X+1
	   if Asc(Mid(Str,X,1))<0 then
		P_num=Int(P_num) + 2
	   else
		P_num=Int(P_num) + 1
	   end if
	   Cutstr=Left(Trim(Str),X)&"..."
	  Loop
	 end if
	end function

end class
%>