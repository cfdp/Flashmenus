package components 
{
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	
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