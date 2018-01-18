package demo
{
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.text.engine.ElementFormat;
	import flash.text.engine.FontDescription;
	import flash.text.engine.FontLookup;
	import flash.text.engine.TextBlock;
	import flash.text.engine.TextElement;
	import flash.text.engine.TextLine;

	public class ShowMessage
	{
		private var _stage : Stage;
		private var _sprite : Sprite;
		
		public function ShowMessage(sprite:Sprite)
		{
			_sprite = sprite;
			_stage = sprite.stage;
		}

		// color:  0x000000，黑色(默认)。0xFF0000 为红色，0x00FF00 为绿色。
		public function draw_text(txt:String, ypos:Number, fontcolor:uint, fontsize:Number):void
		{		
			var fontDescription:FontDescription = new FontDescription();  
			fontDescription.fontLookup = FontLookup.EMBEDDED_CFF;  
			fontDescription.fontName = "hwxk";  
			
			var format:ElementFormat = new ElementFormat(fontDescription);  
			format.fontSize = fontsize;  
			format.color = fontcolor; 
			
			var textElement:TextElement = new TextElement(txt, format);  
			var textBlock:TextBlock = new TextBlock();  
			textBlock.content = textElement;  
			
			createLines(textBlock, ypos);  
		}
		
		private function createLines(textBlock:TextBlock, ypos:Number):void  
		{  
			var textLine:TextLine = textBlock.createTextLine(null, _stage.width);  
			if(textLine)  
			{  
				textLine.y = ypos;  
				_sprite.addChild(textLine);  
			} 
	
		}
		
	}
}