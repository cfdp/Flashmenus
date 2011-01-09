/**
* Code by Rene´Skou 
* Cyberhusmenu - class for create headmenu. 
* @Edit: Benjamin Christensen (cyberhus.dk) 05-08-09
* @Description: Changed the HeadMenu class to use an 3000ms delay instead of 
* 1200ms to hide the textbox (line 117 at the moment of writing)
 * Date 19-10-2010 class changes so loaded swf's work properly by René Skou.
*/
package core
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.external.ExternalInterface;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	import flash.utils.Timer;
	
	import utilis.loadcontent.Swfloader;
	import utilis.xml.Xmlloader;

	public class HeadMenu extends Sprite
	{
		private var xmlob:Xmlloader;
		public var headarray:Array;
		private var orgrinx:Number;
		private var orgriny:Number;
		private var menuunder:Undermenu;
		private var headnum:int;
		private var removeSubMenuTimer:Timer;
		private var container:Sprite; // to hold the loaded swf in
		private var swfContent:Swfloader; // The class that loads the swf file.
		
		
		public function HeadMenu()
		{
			xmlConnection();
		}
		private function xmlConnection():void
		{
			var xmlUrl:String;
			try
			{
				xmlUrl = ExternalInterface.call("goUrl");
				if(xmlUrl === null)
				{
					xmlUrl = "lystvaerelse.xml";
				}
			}
			catch(e:Error)
			{
				xmlUrl = "lystvaerelse.xml";
			}
			
			xmlob = new Xmlloader(xmlUrl);
			xmlob.addEventListener(Xmlloader.XMLLOADED, loadedHandler);
			xmlob.addEventListener(Xmlloader.NOXML, onXMLDATAHandler);

		}
		private function loadedHandler(e:Event):void
		{
			createHead();
			
		}
		private function onXMLDATAHandler(e:Event):void
		{
			
		}
		private function createHead():void
		{
			
			headarray = new Array();
			
			for(var i:Number = 0; i <headCount; i++)
			{
				/*** check to see if the @startbillede attribute is empty***/
				if(xmlob.xmlObject..@startbillede[i] == "")
				{
					/***If it is we use a dot and give it the right color ***/
					/*** Need to make a standart swf, if xml is empty - René Skou***/
				}
				else
				{
					/*** we've been told that our point is something other than the dot ***/
					swfContent = new Swfloader(xmlob.xmlObject..menu[i].@startbillede);
					
				}
				container = new Sprite ();
				orgriny = xmlob.xmlObject..position[i].@ypos;
				orgrinx = xmlob.xmlObject..position[i].@xpos;
				container.x = orgrinx+20;
				container.y = orgriny;
				container.name = xmlob.xmlObject..menu[i].@titel;
				headarray.push(container.name);
				container.addEventListener(MouseEvent.MOUSE_OVER, headOverListener,false,0,true);
				container.addEventListener(MouseEvent.CLICK, clickListener);
				container.buttonMode = true;
				container.useHandCursor = true;
				container.mouseChildren = true;
				container.addChild(swfContent);
				addChild(container);
				
			}

			
		}

		private function headOverListener(e:MouseEvent):void
		{	
		
			if(menuunder !== null && stage.contains(menuunder)){
				removeUnder(e);

				menuunder.underContainer.removeEventListener(MouseEvent.MOUSE_MOVE,resetTimer);
			}
			/*** Timer for removing the activated menus in case of idle ***/
			removeSubMenuTimer = new Timer(3000,1);
			removeSubMenuTimer.addEventListener(TimerEvent.TIMER,removeUnder);
			removeSubMenuTimer.start();
			menuunder = new Undermenu(headarray,e.target.name,textbox_x(e.target.name),textbox_y(e.target.name),e.target.height,xmlob.xmlObject);
			/*** To make sure the timer isnt triggered prematurely we set up some listeners to reset it***/
			menuunder.underContainer.addEventListener(MouseEvent.MOUSE_MOVE,resetTimer);
			e.currentTarget.addEventListener(MouseEvent.MOUSE_MOVE,resetTimer);
			addChild(menuunder);
			
		}
		private function resetTimer(e:MouseEvent):void
		{
			removeSubMenuTimer.reset();
			removeSubMenuTimer.start();
		}
		private function removeUnder(e:Event):void
		{
			if(menuunder !== null && stage.contains(menuunder)){
				removeChild(menuunder);
				menuunder.underContainer.removeEventListener(MouseEvent.MOUSE_MOVE,resetTimer);
				removeSubMenuTimer.removeEventListener(TimerEvent.TIMER,removeUnder);
				removeSubMenuTimer.stop();
			}
		}
		private function clickListener (e:MouseEvent):void
		{
			navigateToURL(new URLRequest(xmlob.xmlObject..menukategori[getnum(e.target.name)].@link),"_self");
		}
		
		private function get headCount():Number
		{
			return xmlob.xmlObject..menu.length();
		}
		private function getnum (name:String):Number
		{
			var num:uint = headarray.indexOf(name);
			return num;
		}
		private function textbox_x (name:String):Number
		{
			var num:uint = xmlob.xmlObject..textboxx[getnum(name)];
			return num;
		}
		private function textbox_y (name:String):Number
		{
			var num:uint = xmlob.xmlObject..textboxy[getnum(name)];
			return num;
		}
		
	}
}