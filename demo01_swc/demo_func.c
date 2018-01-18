

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/stat.h> 
#include <unistd.h> 
#include <stdarg.h>

#include "AS3/AS3.h"



#define AS3_PACKAGE_NAME "as3package:kevin.democ"


// 测试as调用c的接口

void as3_test01() __attribute__((used,
	annotate("as3sig:public function as3_test01():int"),
	annotate(AS3_PACKAGE_NAME)));

void as3_test02()  __attribute__((used,
	annotate("as3sig:public function as3_test02(signstr:String, buflen:int ):int"),
	annotate(AS3_PACKAGE_NAME)));
	
void as3_test03()  __attribute__((used,
	annotate("as3sig:public function as3_test03(bufbytes:int, buflen:int ):int"),
	annotate(AS3_PACKAGE_NAME)));

// 04修改传入的一个AS中的int指针，05使用修改过的值
void as3_test04()  __attribute__((used,
	annotate("as3sig:public function as3_test04(hdptr:int):int"),
	annotate(AS3_PACKAGE_NAME)));

void as3_test05()  __attribute__((used,
	annotate("as3sig:public function as3_test05(hd:int):int"),
	annotate(AS3_PACKAGE_NAME)));

void as3_test06() __attribute__((used,
	annotate("as3sig:public function as3_test06(num:int):int"),
	annotate(AS3_PACKAGE_NAME)));

void as3_trace(char* str);
int test_param(char *sign, int len);
int test_buf(char *buf, int len);

// 测试trace函数
void as3_test01()
{
	int ret = 12;
//	char tmp[15] = {0};

	as3_tracef("mystr = %d\n", ret);
//	as3_trace(tmp);

	AS3_Return(ret);
}

// 验证AS传入的参数。
void as3_test02()
{
	int ret = -1;
	char *sign = NULL;
	int  len = 0;

	AS3_MallocString(sign, signstr);

	inline_as3(
		"%0 = buflen;\n"
		: "=r"(len) : 
	);

	ret = test_param(sign, len);

	if(sign) free(sign);
	AS3_Return(ret);	
}

// 测试修改AS传入的内存块数据，并确定返回的数据是修改过的。
void as3_test03()
{
	int ret = -1;
	char *buf = NULL;
	int  buflen = 0;

	inline_as3(
		"%0 = bufbytes;\n"
		"%1 = buflen;\n"
		: "=r"(buf), "=r"(buflen) : 
	);
	if(buf)
	{
		ret = test_buf(buf, buflen);
	}

	AS3_Return(ret);
}

// 04修改传入的一个AS中的int指针，05使用修改过的值
void as3_test04()
{
	int ret = 101;
	int *phd = NULL;

	inline_as3(
		"%0 = hdptr;\n"
		: "=r"(phd) : 
	);
	*phd = ret;

	AS3_Return(ret);	
}

//as3_test05(hd:int):int
void as3_test05()
{
	int hd = 0;

	inline_as3(
		"%0 = hd;\n"
		: "=r"(hd) : 
	);

	AS3_Return(hd);	
}

int g_num = 0;
// 测试多个worker对于全局变量的读取
//as3_test06(num:int):int
void as3_test06()
{
	int n = 0;
	int last_n = g_num;

	inline_as3(
		"%0 = num;\n"
		: "=r"(n) : 
	);

	as3_tracef("recv:%d, last=%d\n", n, last_n);

	g_num = n;
	AS3_Return(last_n);	
}

//======================================================//

void as3_trace(char* str)
{
    AS3_DeclareVar(myString, String);
    AS3_CopyCStringToVar(myString, str, strlen(str));
    AS3_Trace(myString);
}

void as3_tracef(const char* format, ...)
{
	char sztmp[512];
    va_list vl;
    va_start(vl, format);
    sprintf(sztmp, format, vl);
    as3_trace(sztmp);
    va_end(vl);
}

int test_param(char *sign, int len)
{
	printf("sign=%s, len=%d\n", sign, len);
	if(len>0)
		return 0;
	else
		return -10;
}

int test_buf(char *buf, int len)
{
	if(len>0)
	{
		int i = 0;
		for(i=0; i<len; i++)
		{
			buf[i] += 1;
		}
		return 0;
	}
	else
		return -1;
}