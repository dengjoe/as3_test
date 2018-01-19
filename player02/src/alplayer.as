package
{
	import flash.display.Sprite;
	import flash.media.Video;

	import flash.net.NetConnection;
	import flash.net.NetStream;
	import AlpNetStream;
	
	public class alplayer extends Sprite
	{
		private var _ns:AlpNetStream = null; 
		
		public function alplayer()
		{
			var nc:NetConnection = new NetConnection(); 
			nc.connect(null);	

			var client:Object = new Object();
			client.onMetaData = metaDataHandler;
			
			_ns = new AlpNetStream(nc); 
			_ns.client = client;

			var video:Video = new Video(this.stage.width, this.stage.height);
			video.x = 0;
			video.y = 0;
			video.smoothing = true;
			video.attachNetStream(_ns);
			addChild(video);

			play("http://192.168.3.103/ligang.f4v");
			//play("http://192.168.2.166/ligang.mp4");
		}
		
		public function play(url:String):void
		{
			_ns.play(url); 
		}
		
		private function metaDataHandler(infoObject:Object):void 
		{
			trace("metaData : " + infoObject);
		}

	}
}