<%
if APP_ = "" or isNull(APP_) then 
	response.write ("No direct script access allowed")
	response.end
end if
'*************************************************************
'	class		: A fast connecting String class
'	File Name	: FastString.asp
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

class Kiss_FastString
	'************************************
	'��������
	'************************************
	'index --- �ַ���������±�
	'ub ------ ���ڵ��������������������
	'ar() ---- �ַ�������
	private index, ub, ar()
	'************************************
	'ʵ�� ��ʼ��/��ֹ
	'************************************
	private sub class_Initialize()
		redim ar(50)
		index = 0
		ub = 49
	end sub
	private sub class_Terminate()
		Erase ar
	end sub
	'************************************
	'�¼�
	'************************************
	'Ĭ���¼�������ַ���
	public Default sub Add(value)
		ar(index) = value
		index = index+1
		if index>ub then
			ub = ub + 50
			redim Preserve ar(ub)
		end if
	end sub
	'************************************
	'����
	'************************************
	'�������Ӻ���ַ���
	public function Dump
		redim preserve ar(index-1)
		Dump = join(ar,"") '�ؼ�����Ŷ^_^
	end function
end class
%> 