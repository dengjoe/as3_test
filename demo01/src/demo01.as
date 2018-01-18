package
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.system.MessageChannel;
	import flash.system.Worker;
	import flash.system.WorkerDomain;
	import flash.text.Font;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.engine.ElementFormat;
	import flash.text.engine.FontDescription;
	import flash.text.engine.FontLookup;
	import flash.text.engine.TextBlock;
	import flash.text.engine.TextElement;
	import flash.text.engine.TextLine;
	import flash.utils.ByteArray;
	import flash.utils.setInterval;
	
	import demo.MyTest;
	import demo.PopWin;
	import demo.ShowMessage;
	import demo.Worker01;
	import demo.ctest;
	import demo.post_test;

	
	public class demo01 extends Sprite
	{
		protected var mainToWorker:MessageChannel;
		protected var workerToMain:MessageChannel;
		protected var worker:Worker;
		
		public function demo01()
		{
			//HelloWorldWorker();
			
//			draw_text("你好，hello！", 0);
//			test_text("你好，good！", 50);

			var wk:Worker01 = new Worker01(this);
			wk.begin_work();
			
//			var post:post_test = new post_test();
//			post.test();

//			var ct:ctest = new ctest();
//			ct.test_cfunc();
			
//			var mytest:MyTest = new MyTest;
//			mytest.test();
			
//			var pop:PopWin = new PopWin;

		}
	

		public function HelloWorldWorker():void
		{
			
			if(Worker.current.isPrimordial) // Start Main thread
			{
				//Create worker from our own loaderInfo.bytes
				worker = WorkerDomain.current.createWorker(this.loaderInfo.bytes);
				
				//Create messaging channels for 2-way messaging
				mainToWorker = Worker.current.createMessageChannel(worker);
				workerToMain = worker.createMessageChannel(Worker.current);
				
				//Inject messaging channels as a shared property
				worker.setSharedProperty("mainToWorker", mainToWorker);
				worker.setSharedProperty("workerToMain", workerToMain);
				
				//监听来自worker的事件
				workerToMain.addEventListener(Event.CHANNEL_MESSAGE, onWorkerToMain);
				
				//Start worker (re-run document class)
				worker.start();
				
				//Set an interval that will ask the worker thread to do some math
				setInterval(function()
				{
					//mainToWorker.send("HELLO");
					//trace("[Main] HELLO");
					
					mainToWorker.send("ADD");
					trace("[Main] ADD 2 + 2?");
					mainToWorker.send(2);
					mainToWorker.send(2);
					
				}, 1000);
				
			} 
			else // Start Worker thread 
			{
				//Inside of our worker, we can use static methods to 
				//access the shared messgaeChannel's
				mainToWorker = Worker.current.getSharedProperty("mainToWorker");
				workerToMain = Worker.current.getSharedProperty("workerToMain");
				//Listen for messages from the server
				mainToWorker.addEventListener(Event.CHANNEL_MESSAGE, onMainToWorker);
			}
		}
		
		//Messages to the Main thread
		protected function onMainToWorker(event:Event):void 
		{
			var msg:* = mainToWorker.receive();
			
			if(msg == "HELLO")
			{	//When the main thread sends us HELLO, we'll send it back WORLD
				workerToMain.send("WORLD");
			}
			else if(msg == "ADD")
			{
				//Receive the 2 numbers and add them together, return the result to the main thread
				var result:int = mainToWorker.receive() + mainToWorker.receive();
				workerToMain.send(result);
			}
		}
		
		//Messages to the worker thread
		protected function onWorkerToMain(event:Event):void 
		{
			trace("[Worker] " + workerToMain.receive());
		}
		
		private function draw_text(txt:String, ypos:Number):void
		{
			var dmsg : ShowMessage = new ShowMessage(this);
			dmsg.draw_text(txt, ypos, 0xFF0000, 18);
			dmsg.draw_text(txt, ypos+18+2, 0x000000, 20);
			dmsg.draw_text(txt, ypos+18+20+4, 0xFF0000, 24);
			trace("draw text end");
		}
		
		
		private function test_text(txt:String, ypos:Number):void
		{		
			var fontDescription:FontDescription = new FontDescription();  
			fontDescription.fontLookup = FontLookup.EMBEDDED_CFF;  
			fontDescription.fontName = "hwxk";  
			
			var format:ElementFormat = new ElementFormat(fontDescription);  
			format.fontSize = 20;  
			format.color = 0xFF0000; //默认值为 0x000000，黑色。0xFF0000 为红色，0x00FF00 为绿色。
			
			var textElement:TextElement = new TextElement(txt, format);  
			var textBlock:TextBlock = new TextBlock();  
			textBlock.content = textElement;  
			
			createLines(textBlock, ypos);  
			trace("createLines ok");
		}
		
		private function createLines(textBlock:TextBlock, ypos:Number):void  
		{  
			var yPos:Number = ypos;  
			var textLine:TextLine = textBlock.createTextLine(null, 200);  
			while(textLine)  
			{  
				addChild(textLine);  
				yPos += textLine.height+2;  
				textLine.y = yPos;  
				textLine = textBlock.createTextLine(textLine, 200);  
			} 
		}
		
// only available in AIR, not flash		
//		import flash.filesystem.FileStream;
//		import flash.filesystem.File;
//		private function test_file():void
//		{
//			var stream:FileStream = new FileStream();
//			var file:File = new File('d:/demo.srt');//绑定一个文件
//			stream.open(file, FileMode.READ);//读取文件
//			trace(stream.readMultiByte(stream.bytesAvailable,'utf-8'));
//			stream.close();
//		}

//		import flash.net.InterfaceAddress;
//		import flash.net.NetworkInfo;
//		import flash.net.NetworkInterface;
//		
//		public function GetAddressList():void
//		{
//			var networkInfo:NetworkInfo = NetworkInfo.networkInfo;
//			var interfaces:Vector.<NetworkInterface> = networkInfo.findInterfaces();
//			
//			if( interfaces != null )
//			{
//				trace( "Interface count: " + interfaces.length );
//				for each ( var interfaceObj:NetworkInterface in interfaces )
//				{
//					trace( "\nname: "             + interfaceObj.name );
//					trace( "display name: "     + interfaceObj.displayName );
//					trace( "mtu: "                 + interfaceObj.mtu );
//					trace( "active?: "             + interfaceObj.active );
//					trace( "parent interface: " + interfaceObj.parent );
//					trace( "hardware address: " + interfaceObj.hardwareAddress );
//					if( interfaceObj.subInterfaces != null )
//					{
//						trace( "# subinterfaces: " + interfaceObj.subInterfaces.length );
//					}
//					trace("# addresses: "     + interfaceObj.addresses.length );
//					for each ( var address:InterfaceAddress in interfaceObj.addresses )
//					{
//						trace( "  type: "           + address.ipVersion );
//						trace( "  address: "         + address.address );
//						trace( "  broadcast: "         + address.broadcast );
//						trace( "  prefix length: "     + address.prefixLength );
//					}
//				}        
//			}
//		}
		

	}
}