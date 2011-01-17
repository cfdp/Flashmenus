package components.Mediabox_beta2 
{
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import caurina.transitions.Tweener;
	import flash.text.TextFormat;
	import flash.text.TextFieldAutoSize;
	
	
	/**
	 * ...
	 * @author Rene Skou
	 * @description class for showing dynamic created content by drupal cms system
	 */
	public class Mediabox extends MovieClip 
	{
		private var itembox1:MovieClip;
		private var itembox2:MovieClip;
		private var itembox3:MovieClip;
		private var titletext:TextField;
		private var ungeblog:MovieClip;
		private var starway:MovieClip;
		private var tf:TextFormat;
		private var _headline:String;

		
		public function Mediabox() 
		{
			setupitems();
		}
		//adds listener to items and mouse action
		private function setupitems ():void
		{
			tf = new TextFormat();
			tf.bold = true;
			tf.size = 12;
			tf.font = "Verdana";
			

			//tell the compiler they are movieclips
			itembox1 = textitem1;
			itembox2 = textitem2;
			itembox3 = textitem3;
			
			itembox1.addEventListener(MouseEvent.CLICK, mouseclickItembox);
			itembox2.addEventListener(MouseEvent.CLICK, mouseclickItembox);
			itembox3.addEventListener(MouseEvent.CLICK, mouseclickItembox);
			
			//ungeblog and starway setup
			starway = sway;
			ungeblog = ublog;
			
			starway.buttonMode = true;
			starway.useHandCursor = true;
			starway.mouseChildren = false;
			
			ungeblog.buttonMode = true;
			ungeblog.useHandCursor = true;
			ungeblog.mouseChildren = false;
			
			starway.addEventListener(MouseEvent.CLICK, mouseclickUngeStar);
			ungeblog.addEventListener(MouseEvent.CLICK, mouseclickUngeStar);
			

			titletext = titlename;
			titletext.selectable = false;
			titletext.autoSize = TextFieldAutoSize.CENTER;
			titletext.defaultTextFormat = tf;
			titletext.text = "Henter elementer 0 / 00";
			
			
			

			
		}
		//mouse event when client click the itembox
		private function mouseclickItembox (e:MouseEvent):void
		{
			
		}
		// eventhandler for starway and ungeblog movieclip
		private function mouseclickUngeStar (e:MouseEvent):void
		{
			
		}
		public function setTextitem1(hl:String):void
		{
			_headline = hl;
			itembox1.headline.text = _headline;
		}


	}

}