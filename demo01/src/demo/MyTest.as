package demo
{
	import flash.net.SharedObject;
	import flash.utils.ByteArray;

	// 测试字符串，byteArray，本地存储的操作
	public class MyTest
	{
		var _userName:String = "Hello ABC";
		var _userCount:int = 0;
		var _userData:ByteArray;
		var _outData:ByteArray;
		
		public function MyTest()
		{
			_userData = new ByteArray;
			var i:int = 0;
			for(i=10; i<20; ++i)
			{
				_userData.writeInt(i);
			}	
			_userCount = _userData.length;
		}
		
		public function test():void
		{
			// test share object
			load_shared("hello");
			save_shared("hello");
//			clear_shared("hello");
			load_shared("hello");
			
			test_bytes();
			
			var url:String = "http://192.168.2.166:80/path/my01.m3u8?mediaid=123456&url=http://192.168.3.102:6666";
			parse_url(url);			
		}
		
		public function parse_url(url:String):void
		{
			trace(url);
			
			var idx:int = url.indexOf("?", 0);
			if(idx>0)
			{
				var tag1:String = "mediaid=";
				var tag2:String = "url=";
				
				var i1:int = url.indexOf(tag1, idx);
				var i2:int = url.indexOf(tag2, idx);
				
				var strid:String = url.substring(i1+tag1.length, i2-1);
				var urldrm:String = url.substring(i2+tag2.length, url.length);
				
				trace("id=" + i1 + " url=" + i2);
				trace("strid=" + strid + " urldrm=" + urldrm);		
				
			}
		}
		
		public function save_shared(sharename:String):void
		{
			trace("save_shared:" + sharename);

			var my_so:SharedObject = SharedObject.getLocal(sharename);
			my_so.data.userName = _userName;
			my_so.data.userData = _userData;
			my_so.data.userCount = _userCount;
			
			my_so.flush();
			for (var prop in my_so.data) {
				trace(prop+": " + my_so.data[prop]);
			}
			
			trace("");
		}

		public function load_shared(sharename:String):void
		{
			trace("load_shared:" + sharename);

			var my_so:SharedObject = SharedObject.getLocal(sharename);
			
			for (var prop in my_so.data) {
				trace(prop+": " + my_so.data[prop]);
			}
			
			var bytes:ByteArray = my_so.data.userData;
			if(bytes != null)
			{
				var i:int = 0;
				bytes.position = 0;
				for(i=0; i<bytes.length; ++i)
				{
					trace("[" + i + "]:" + bytes.readByte());
				}				
			}
			
			trace("");
		}		
		public function clear_shared(sharename:String):void
		{
			trace("clear_shared:" + sharename);
			var my_so:SharedObject = SharedObject.getLocal(sharename);
			my_so.clear();
			trace("");
		}		
		
		
		public function test_bytes():void
		{
			test_bytes_byte();
			test_bytes_copy();
			test_bytes2str();
			
			return;
		}

		private function test_bytes_byte():void
		{
			trace("test_bytes_byte:");
			
			var bytes:ByteArray = new ByteArray();
			var i:int = 0;
			
			trace("bytes position="+  bytes.position + " length=" + bytes.length);
			for(i=0; i<10; ++i)
			{
				bytes.writeByte(i);
			}
			trace("bytes position="+  bytes.position + " length=" + bytes.length);
			
			bytes.position = 0;
			for(i=0; i<10; ++i)
			{
				trace("[]:" + bytes.readByte());
			}
			
			trace("");
		}
		
		public function test_bytes_copy():void
		{
			trace("test_bytes_copy:");
			// 内存数据复制
			var bytes:ByteArray = new ByteArray();
			trace("bytes.position=" + bytes.position + " bytes.length=" + bytes.length);
			
			bytes.writeUTFBytes("Hello World!"); 
			trace("bytes.position=" + bytes.position + " bytes.length=" + bytes.length);
			trace(bytes);
			
			var outs:ByteArray = new ByteArray();
			bytes.position = 0;
			trace("bytes.position=" + bytes.position + " bytes.length=" + bytes.length);
			bytes.readBytes(outs); //是从bytes的position位置开始复制数据
			trace("bytes.position=" + bytes.position + " bytes.length=" + bytes.length);
			trace("outs.position=" + outs.position + " outs.length=" + outs.length);
			trace(outs);			
			trace("");
		}
		
		public function test_bytes2str():void
		{
			trace("test_bytes2str:");
			
			var b1:ByteArray = new ByteArray();
			var i:int = 0;
			for(i=0; i<10; i++)
			{
				b1[i]=i;
			}
			
			// 字符串与内存数据互转。只有字符串可以这样转，二进制不行
			var s1:String = ByteArray2String(b1);
			trace("string1:" + s1);
			
			var b2:ByteArray = String2ByteArray(s1);
			trace("bytes2:" + b2);
			
			trace("");
		}
		
		public static function String2ByteArray(str:String):ByteArray
		{
			var bytes:ByteArray;
			if ( str ) {
				bytes = new ByteArray();
				bytes.writeUTFBytes(str);
			}
			return bytes;
		}
		
		public function ByteArray2String(bytes:ByteArray):String
		{
			var str:String;
			if ( bytes ) {
				bytes.position = 0;
				str = bytes.readUTFBytes(bytes.length);
			}
			return str;
		}
		
	}
}