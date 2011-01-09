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
			//staticGlow defines the static state of the fmswf
			var staticGlow:GlowFilter = new GlowFilter(0xE815B9, 0.6, 8,8,1);
			
			Tweener.addTween(this, { _filter:staticGlow, time:1 } );
			
			this.addEventListener(MouseEvent.MOUSE_OUT, movieclipMouseOut);
			
		}

		private function movieclipMouseOut(event:MouseEvent):void
		{
			var mouseOutGlow:GlowFilter = new GlowFilter(0xE815B9, 0.5, 8, 8, 1);
			Tweener.addTween(event.target, { _filter:mouseOutGlow, time:1 } );
			
		}

	}
		
	}

