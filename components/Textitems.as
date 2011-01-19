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
	 * the text object that's holds teh 3 text fields for the mediabox
	 */
	public class Textitems extends MovieClip 
	{
		private var headlineTextformat:TextFormat;
		private var tf:TextFormat;
		private var _headline:TextField;
		
		//setting up the text elements in the constructor
		public function Textitems() 
		{
			this.buttonMode = true;
			this.useHandCursor = true;
			this.mouseChildren = false;
			this.addEventListener(MouseEvent.MOUSE_OVER, mouseoverTextitem);
			this.addEventListener(MouseEvent.MOUSE_OUT, mouseoutTextitem);
			
			tf= new TextFormat();
			tf.bold = true;
			tf.size = 10;
			tf.font = "Verdana";
			tf.color = 0x000000;
			
			var textformat:TextFormat = new TextFormat();
			textformat.bold = false;
			textformat.size = 9;
			textformat.font = "Verdana";
			
			headlineTextformat = new TextFormat();
			headlineTextformat.color = 0x00A7FF;
			
			_headline = headline;
			
			_headline.defaultTextFormat = tf;
			
			
			
			var _type:TextField = type;
			_type.autoSize = TextFieldAutoSize.LEFT;
			_type.defaultTextFormat = textformat;
			
			var _date:TextField = date;
			_date.autoSize = TextFieldAutoSize.LEFT;
			_date.defaultTextFormat = textformat;
			
			

			
		}
		//mouse over and out functions for the text object that makes another color in the dot and sets the textformat.
		private function mouseoverTextitem(e:MouseEvent):void
		{
			dot.gotoAndStop(2);
			_headline.setTextFormat(headlineTextformat);
			
		}
		private function mouseoutTextitem(e:MouseEvent):void
		{
			dot.gotoAndStop(1);
			_headline.setTextFormat(tf);
		}
		
	}

}