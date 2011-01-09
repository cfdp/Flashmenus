/**
* cody by René Skou 2008
 * Loads content into the displaylist via the loader class 
*/



package utilis.loadcontent
{


	import flash.display.DisplayObject;
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.URLRequest;

	
	public class Swfloader extends Sprite
	{
		public var contentloader:Loader
		public var contentobject:DisplayObject;
		public static const ADDTOSTAGE:String = "addtostage";
		public static const INITREADY:String = "initready";

		public function Swfloader(urlpath:String)
		{
			contentloader = new Loader();
			contentloader.load(new URLRequest(urlpath));
			contentloader.contentLoaderInfo.addEventListener(Event.COMPLETE, completeListener);
			contentloader.contentLoaderInfo.addEventListener(Event.INIT, initListener);
			contentloader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, ioErrorListener);
		}
		private function initListener (e:Event):void
		{
			dispatchEvent(new Event(INITREADY));

		}
		private function completeListener(e:Event):void
		{
			
			addChild(contentloader.content);
			dispatchEvent(new Event(ADDTOSTAGE));
			contentobject = contentloader.content;
			

		}
		private function ioErrorListener(e:IOErrorEvent):void
		{

		}

	}
}