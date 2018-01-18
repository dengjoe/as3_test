package demo
{
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.system.MessageChannel;
	import flash.system.Worker;
	import flash.system.WorkerDomain;
	import flash.utils.setInterval;
	
	import kevin.democ.as3_test06;
	
	public class Worker01
	{
		private var _sprite : Sprite;
		protected var mainToWorker:MessageChannel;
		protected var workerToMain:MessageChannel;
		protected var worker:Worker;

		
		public function Worker01(sprite:Sprite)
		{
			_sprite = sprite;
		}
		
		public function begin_work():void
		{
			
			if(Worker.current.isPrimordial) // Start Main thread
			{
				//Create worker from our own loaderInfo.bytes
				worker = WorkerDomain.current.createWorker(_sprite.loaderInfo.bytes);
				
				//Create messaging channels for 2-way messaging
				mainToWorker = Worker.current.createMessageChannel(worker);
				workerToMain = worker.createMessageChannel(Worker.current);
				
				//Inject messaging channels as a shared property
				worker.setSharedProperty("toWorker", mainToWorker);
				worker.setSharedProperty("toMain", workerToMain);
				
				var ret:int = as3_test06(2);
				trace("as3_test06 ret=" + ret);
				
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
				var ret:int = as3_test06(5);
				trace("as3_test06 ret=" + ret);

				//Inside of our worker, we can use static methods to 
				//access the shared messgaeChannel's
				mainToWorker = Worker.current.getSharedProperty("toWorker");
				workerToMain = Worker.current.getSharedProperty("toMain");
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
				
	}
}