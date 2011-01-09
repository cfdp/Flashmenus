package core 
{
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFieldAutoSize;
	
	/**
	 * ...
	 * @author Rene Skou
	 */
	public class Newsbox extends MovieClip 
	{
		
		public function Newsbox() 
		{
			this.addEventListener(MouseEvent.MOUSE_DOWN, newsboxMouseDown);
			this.addEventListener(MouseEvent.MOUSE_UP, newsboxMouseUp);
			this.buttonMode = true;
			this.useHandCursor = true;
			roomtext.buttonMode = true;
			roomtext.useHandCursor = true;
			roomtext.mouseChildren = false;
			roomtext.newsheading.autoSize = TextFieldAutoSize.LEFT;
			
			var textFormat:TextFormat = new TextFormat();
			textFormat.bold = true;
			textFormat.size = 12;
			roomtext.newsheading.defaultTextFormat = textFormat;
			
		}
		private function newsboxMouseDown(event:MouseEvent):void
		{
			this.startDrag();
		}
		private function newsboxMouseUp(event:MouseEvent):void
		{
			this.stopDrag();
		}
		
	}

}