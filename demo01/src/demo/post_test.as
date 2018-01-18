package demo
{
	import flash.events.Event;
	import flash.net.URLLoader;
	import flash.net.URLVariables;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.net.URLLoaderDataFormat;
	import flash.events.*;
	import flash.net.*;
	
	public class post_test
	{
		public static var _response : String;
		
		public function post_test():void {
		}
		
		public function test():void {
			var url:String = "http://116.76.254.184:19060/ott/v2/epg/doGetProgramListByFilter";
			var data:String = "testdata";
			//as_http_post(url, data);
			
			as_http_get("http://192.168.2.166/html/test.zip");
		}
		
		public static function as_http_post(url:String, data:String):void 
		{
			var _request:URLRequest = new URLRequest();
			_request.url = url;
			_request.method = URLRequestMethod.POST;
			_request.data = data;
			_response = "";
			
			var loader:URLLoader = new URLLoader();
			loader.addEventListener(Event.COMPLETE,completeHandler);
			try
			{
				loader.load(_request);
			}
			catch(error:Error)
			{
				trace("url loader error:" + error);
			}
		}

		public static function as_http_get(url:String):void 
		{
			var _request:URLRequest = new URLRequest();
			_request.url = url;
			_request.method = URLRequestMethod.GET;
			
			var loader:URLLoader = new URLLoader();
			loader.addEventListener(Event.COMPLETE,completeHandler);
			loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler);
			loader.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
			try
			{
				loader.load(_request);				
			}
			catch(error:Error)
			{
				trace("url loader error:" + error);
			}
		}
		
		public static function completeHandler(evt:Event):void 
		{
//			_response = evt.target.data;
//			trace(_response);
		
//			var vars:URLVariables = new URLVariables(loader.data);
//			trace("The answer is " + vars.answer);			
			
			var loader:URLLoader = URLLoader(evt.target);
			trace("completeHandler: " + loader.data);

			switch(loader.dataFormat) 
			{
				case URLLoaderDataFormat.TEXT :
					trace("completeHandler (text): " + loader.data);
					break;
				case URLLoaderDataFormat.BINARY :
					trace("completeHandler (binary): " + loader.data);
					break;
				case URLLoaderDataFormat.VARIABLES :
					trace("completeHandler (variables): " + loader.data);
					break;
			}

		}
		
		private static function securityErrorHandler (e:Event):void
		{
			trace("securityErrorHandler:" + e);
		}
		private static function ioErrorHandler(e:Event):void
		{
			trace("ioErrorHandler: " + e);
		}

	}
}