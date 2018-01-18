package demo
{
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.geom.Rectangle;

	// 弹出窗口
	public class PopWin extends Sprite
	{
		private var sprite:Sprite;
		private var mytxt0:TextField;//这是提示框
		public  var mytxt1:TextField;//您现在可以拖动
		private var mytxt2:TextField;//确定
		private var grdraw0:Sprite;//背景
		private var grdraw1:Sprite;//提示内容
		private var grdraw2:Sprite;//确定按钮
		
		public function PopWin()
		{
			sprite=new Sprite();
			sprite.x = 100;
			sprite.y = 100;
			addChild(sprite);
			for (var i:uint; i<3; i++)
			{
				this["grdraw"+i]=new Sprite();
				this["mytxt"+i]=new TextField();
				this["grdraw" + i].mouseChildren = false;
			}
			drawrect();
			sprite.addEventListener(MouseEvent.MOUSE_DOWN,downHd);
			sprite.addEventListener(MouseEvent.MOUSE_UP,upHd);
			
			trace("PopWin run.");
		}
		
		private function downHd(e:MouseEvent):void
		{
			var tct:Rectangle = new Rectangle(-100,-100,249,198);
			sprite.alpha = 0.5;
			startDrag(false,tct);
		}
		
		private function upHd(e:MouseEvent):void
		{
			sprite.alpha = 1;
			stopDrag();
		}
		
		private function removedown(e:MouseEvent):void
		{
			removeChild(sprite);
			grdraw2.removeEventListener(MouseEvent.MOUSE_DOWN,removedown);
			sprite.removeEventListener(MouseEvent.MOUSE_DOWN,downHd);
			sprite.removeEventListener(MouseEvent.MOUSE_UP,upHd);
		}
		
		private function drawrect():void
		{
			//绘制背景
			grdraw0.graphics.lineStyle(1,0x000000);
			grdraw0.graphics.beginFill(0xcccc00);
			grdraw0.graphics.drawRect(0,0,300,200);
			grdraw0.graphics.endFill();
			sprite.addChild(grdraw0);
			
			//显示文本框（提示框）
			mytxt0.text = "错误提示";
			mytxt0.x = 20;
			mytxt0.y = 10;
			grdraw0.addChild(mytxt0);
			
			//绘制提示框
			grdraw1.graphics.lineStyle(1,0xFFCC33);
			grdraw1.graphics.beginFill(0xffffff);
			grdraw1.graphics.drawRect(10,40,280,100);
			grdraw1.graphics.endFill();
			sprite.addChild(grdraw1);
			//显示提示内容（您现在可以拖动）
			mytxt1.text = "您现在可以拖动";
			mytxt1.x = 20;
			mytxt1.y = 50;
			grdraw1.addChild(mytxt1);
			
			//绘制确定按钮
			grdraw2.graphics.lineStyle(1,0xFFCC33);
			grdraw2.graphics.beginFill(0xFF66FF);
			grdraw2.graphics.drawCircle(40,170,20);
			grdraw2.graphics.endFill();
			sprite.addChild(grdraw2);
			grdraw2.buttonMode = true;
			grdraw2.addEventListener(MouseEvent.MOUSE_DOWN,removedown);
			
			//显示确定按钮文本
			mytxt2.text = "确定";
			mytxt2.x = 25;
			mytxt2.y = 160;
			grdraw2.addChild(mytxt2);
		}
	}

}