package
{
	import flash.net.NetConnection;
	import flash.net.NetStream;
	import flash.net.URLStream;
	import flash.net.URLRequest;
	import flash.net.NetStreamAppendBytesAction;
	
	import flash.events.ErrorEvent;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.Event;
	import flash.events.NetStatusEvent;
	import flash.events.SecurityErrorEvent;	
	import flash.events.HTTPStatusEvent;
	import flash.events.TimerEvent;
	
	import flash.utils.ByteArray;
	import flash.utils.Timer;
	
	public class AlpNetStream extends NetStream
	{
		/** Timer used to check buffer and position. **/
		private var _timer : Timer;
		/** Util for loading the media. **/
		private var _streamloader : URLStream;
		
		private var _bytesLoaded: int;
		
		public function AlpNetStream(connection:NetConnection)
		{
			super(connection);
			super.bufferTime = 0.1;
			
			_timer = new Timer(50, 0);
			_timer.addEventListener(TimerEvent.TIMER, _checkLoading);
		}
		
		override public function play(...args) : void 
		{
			var _playStart : Number;
			_bytesLoaded = 0;
			
			if (args.length >= 2) {
				_playStart = Number(args[1]);
			} else {
				_playStart = -1;
			}
			
			trace("AlpNetStream:play(" + args[0]  +", " + _playStart + ")");

			if (_streamloader == null) {
				_streamloader = new URLStream;
				_streamloader.addEventListener(IOErrorEvent.IO_ERROR, _loadErrorHandler);
				_streamloader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, _loadErrorHandler);
				_streamloader.addEventListener(ProgressEvent.PROGRESS, _loadProgressHandler);
				_streamloader.addEventListener(HTTPStatusEvent.HTTP_STATUS, _loadHTTPStatusHandler);
				_streamloader.addEventListener(Event.COMPLETE, _loadCompleteHandler);
			}	
			
			try {
				_streamloader.load(new URLRequest(args[0]));
			} 
			catch (error : Error) 
			{
				trace("load " + args[0] + " error:" + error.message);
			}
			
			super.close();
			super.play(null);
			super.appendBytesAction(NetStreamAppendBytesAction.RESET_SEEK);
//			super.pause();
		}
		
		private function _loadErrorHandler(event : ErrorEvent) : void 
		{
			trace("_loadErrorHandler event:" + event.type + " "+ event.text);			
		}

		private function _loadHTTPStatusHandler(event : HTTPStatusEvent) : void 
		{
			trace("_loadHTTPStatusHandler event:" + event.type + " "+ event.status);
		}
		
		private function _loadProgressHandler(event : ProgressEvent) : void 
		{
			if (event.bytesLoaded > _bytesLoaded	// prevent EOF error race condition
				&& _streamloader.bytesAvailable > 0) 
			{  
				var data : ByteArray = new ByteArray();
				_streamloader.readBytes(data);
				
				trace("event.bytesLoaded=" + event.bytesLoaded + "  _streamloader=" + data.length);
				_bytesLoaded += data.length;
				
				// 在这里处理mp4流的demux和drm解密；也可以先保存入一个buffer，再在定时器函数中解密
				
				data.position = 0;
				super.appendBytes(data);
			}		
		}
		
		private function _loadCompleteHandler(event : Event) : void 
		{
			trace("_loadCompleteHandler event:" + event.type);
		}
		
		// 也可以在这里处理mp4流的demux和drm解密
		private function _checkLoading(e : Event) : void 
		{
		}
		
	}
}