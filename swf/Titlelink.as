package swf 
{
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	
	/**
	 * ...
	 * @author René Skou
	 */
	public class Titlelink extends MovieClip 
	{
		
		public function Titlelink() 
		{
			this.addEventListener(MouseEvent.MOUSE_OVER, mouseOverHandler);
			this.addEventListener(MouseEvent.MOUSE_OUT, mouseOutHandler);
			this.buttonMode = true;
			this.useHandCursor = true;
			this.mouseChildren = false;
			
			
		}
		private function mouseOverHandler(e:MouseEvent):void
		{
			gotoAndStop(2);
		}
		private function mouseOutHandler(e:MouseEvent):void
		{
			gotoAndStop(1);
		}
		
	}

}