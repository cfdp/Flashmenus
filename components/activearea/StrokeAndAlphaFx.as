package
{
	
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import caurina.transitions.Tweener;
	/**
	 * ...
	 * @author Rene Skou
	 */
	public class StrokeAndAlphaFx extends MovieClip 
	{
		private var activeArea:MovieClip;
		
		public function StrokeAndAlphaFx() 
		{

				
			activeArea = this;
			activeArea.alpha = 0.5;
			activeArea.addEventListener(MouseEvent.MOUSE_OVER, mouseOverItem);
			activeArea.addEventListener(MouseEvent.MOUSE_OUT, mouseOutItem);

			
			Tweener.addTween(activeArea , { alpha:0.4, time:1.3, transition:"easeOutSine", onComplete:function() { fadeOut(activeArea); } } );
			
			function fadeIn (mc:Object):void
			{
				Tweener.addTween(mc, { alpha:0.4, time:1.3, transition:"easeOutSine", onComplete:function() { fadeOut(activeArea); }} );
			}
			function fadeOut (mc:Object):void
			{
				Tweener.addTween(mc, { alpha:0.1, time:1.3, transition:"easeInSine", onComplete:function() { fadeIn(activeArea); }} );
			}
			

			
		}
		private function mouseOverItem (e:MouseEvent):void
		{
			Tweener.pauseTweens(activeArea);
			activeArea.alpha = 1;
			MovieClip(e.target).gotoAndStop(2);
		}
		private function mouseOutItem (e:MouseEvent):void
		{
			Tweener.resumeTweens(activeArea);
			MovieClip(e.target).gotoAndStop(1);
		}

		
	}

}