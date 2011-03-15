package swf 
{
	import flash.display.MovieClip;
	import caurina.transitions.Tweener;
	import caurina.transitions.properties.FilterShortcuts;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.GlowFilter;
	
	/**
	 * ...
	 * @author Rene Skou
	 */
	public class MovieClipController extends MovieClip 
	{
		
		public function MovieClipController() 
		{
			
			
			FilterShortcuts.init();
			var staticGlow:GlowFilter = new GlowFilter(0xfff300, 0.6, 5,5,3);
			
			Tweener.addTween(this, { _filter:staticGlow, time:1 } );
			
			this.addEventListener(MouseEvent.MOUSE_OUT, movieclipMouseOut);
			
		}

		private function movieclipMouseOut(event:MouseEvent):void
		{
			var mouseOutGlow:GlowFilter = new GlowFilter(0xfff300, 0.5, 4, 4, 3);
			Tweener.addTween(event.target, { _filter:mouseOutGlow, time:1 } );
			
		}

	}
		
	}

