package demo
{
	import flash.utils.ByteArray;
	
	import kevin.democ.CModule;
	import kevin.democ.as3_test01;
	import kevin.democ.as3_test02;
	import kevin.democ.as3_test03;
	import kevin.democ.as3_test04;
	import kevin.democ.as3_test05;

	// 测试和CrossBridge的c函数的数据通信
	public class ctest
	{
		public function ctest()
		{
		}

		public function test_cfunc():void
		{
			var ret:int = as3_test01();
			trace("as3_test01 ret=" + ret);
			
			var word:String = "Hello!";
			ret = as3_test02(word, 1);
			trace("as3_test02 ret=" + ret);
			
			
			test_func03();
			test_func04();
		}
		
		private function test_func03():void
		{
			var ret:int = 0;
			
			// 内存数据传给c函数,经c函数转换后再传回
			var b1:ByteArray = new ByteArray();
			var i:int = 0;
			for(i=0; i<10; i++)
			{
				b1[i]=i;
			}
			trace("b1:" + b1 + " b1[]=" + b1[0] + b1[1] + b1[2] + b1[3]);
			trace("b1.position=" + b1.position + " b1.length=" + b1.length);
			
			// 创建内存数据
			var b1Ptr:int = CModule.malloc(b1.length);
			CModule.writeBytes(b1Ptr, b1.length, b1);
			
			ret = as3_test03(b1Ptr, b1.length);
			trace("as3_test03 ret=" + ret);
			
			//再写入ByteArray中
			b1.position = 0;
			CModule.readBytes(b1Ptr, b1.length, b1);
			trace("b1:" + b1 + " b1[]=" + b1[0] + b1[1] + b1[2] + b1[3]);
			trace("b1.position=" + b1.position + " b1.length=" + b1.length);
			CModule.free(b1Ptr);			
		}
		
		private function test_func04():void
		{
			var ret:int = 0;
			var hd:int = 0;
			
			var hdptr:int = CModule.malloc(4);
			ret = as3_test04(hdptr);
			if(ret==0)
			{
				hd = CModule.read32(hdptr);		
			}
			CModule.free(hdptr);
			trace("as3_test04 ret=" + ret + " hd=" + hd);
			
			ret = as3_test05(hd);
			trace("as3_test05 ret=" + ret);
		}

	
	}
}