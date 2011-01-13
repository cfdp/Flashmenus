package components 
{
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFieldAutoSize;
	
	/**
	 * ...
	 * @author René Skou
	 */
	public class Textitems extends MovieClip 
	{
		
		public function Textitems() 
		{
			this.buttonMode = true;
			this.useHandCursor = true;
			this.mouseChildren = false;
			this.addEventListener(MouseEvent.MOUSE_OVER, mouseoverTextitem);
			this.addEventListener(MouseEvent.MOUSE_OUT, mouseoutTextitem);
			
			var tf:TextFormat = new TextFormat();
			tf.bold = true;
			tf.size = 10;
			tf.font = "Verdana";
			
			var textformat:TextFormat = new TextFormat();
			textformat.bold = false;
			textformat.size = 9;
			textformat.font = "Verdana";
			
			var _headline:TextField = headline;
			_headline.autoSize = TextFieldAutoSize.LEFT;
			_headline.defaultTextFormat = tf;
			
			var _type:TextField = type;
			_type.autoSize = TextFieldAutoSize.LEFT;
			_type.defaultTextFormat = textformat;
			
			var _date:TextField = date;
			_date.autoSize = TextFieldAutoSize.LEFT;
			_date.defaultTextFormat = textformat;
			
			var _readmore:TextField = readmore;
			_readmore.autoSize = TextFieldAutoSize.LEFT;
			_readmore.defaultTextFormat = textformat;
			
		}
		private function mouseoverTextitem(e:MouseEvent):void
		{
			dot.gotoAndStop(2);
			
		}
		private function mouseoutTextitem(e:MouseEvent):void
		{
			dot.gotoAndStop(1);
		}
		
	}

}