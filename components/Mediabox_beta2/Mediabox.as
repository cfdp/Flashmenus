package components.Mediabox_beta2 
{
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import caurina.transitions.Tweener;
	
	
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
		private var undertitle:TextField;
		private var ungeblog:MovieClip;
		private var starway:MovieClip;
		
		public function Mediabox() 
		{
			setupitems();
		}
		//adds listener to items and mouse action
		private function setupitems ():void
		{
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
			
			//titletext fields
			titletext = titlename;
			//undertitle = undername;
			
			titletext.selectable = false;
			//undertitle.selectable = false;
			
		}
		//mouse event when client click the itembox
		private function mouseclickItembox (e:MouseEvent):void
		{
			Tweener.addTween(titletext, { x:10, time:1,onComplete:function(){Tweener.addTween(titletext, {x:54.5,time:1})} } );
		}
		// eventhandler for starway and ungeblog movieclip
		private function mouseclickUngeStar (e:MouseEvent):void
		{
			
		}

	}

}