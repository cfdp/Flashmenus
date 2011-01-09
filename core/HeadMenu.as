/*** Code by Rene´Skou 
 *Cyberhusmenu - class for create headmenu. 
 *@Edit: Benjamin Christensen (cyberhus.dk) 05-08-09
 *@Description: Changed the HeadMenu class to use an 3000ms delay instead of 
 *1200ms to hide the textbox (line 117 at the moment of writing)
 * Date 19-10-2010 class changes so loaded swf's work properly by René Skou.
 *rewritten the codebase, all above dosn't apply anymore 03-12-2010 by René Skou.
***/
package core
{
	import com.google.analytics.components.GATrackerLibrary;
	import flash.display.MovieClip;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.external.ExternalInterface;
	import flash.filters.GlowFilter;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	import caurina.transitions.Tweener;
	import caurina.transitions.properties.FilterShortcuts;
	import swf.Linkbox;
	import swf.Titlelink;
	import com.google.analytics.AnalyticsTracker;
	import com.google.analytics.GATracker;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	

	
	import utilis.loadcontent.Swfloader;
	import utilis.xml.Xmlloader;

	public class HeadMenu extends Sprite
	{
		private var xmlob:Xmlloader;
		public var headarray:Array;
		private var orgrinx:Number;
		private var orgriny:Number;
		private var container:Sprite; // to hold the loaded swf in
		private var swfContent:Swfloader; // The class that loads the swf file.
		private var flashMenuLinkbox:MovieClip;
		private var linkboxExcist:Boolean;
		private var contentInfoObject:Xmlloader;
		private var xmlArgument:int;
		private var linkboxId:String;
		private var tracker:AnalyticsTracker;
		private var newsboxHeadline:MovieClip;
		private var toRoom:TextField;
		private var seneste:TextField;
		private var ft:TextFormat;
		private var baseurl:String;

		
		
		
		public function HeadMenu()
		{
			xmlConnection();
			FilterShortcuts.init();
			tracker = new GATracker(this, "UA-2898416-1", "AS3", false);
		}
		private function xmlConnection():void
		{
	
			var contentInfoXml:String = "http://udvikling.cyberhus.dk/fmitems/276.xml";
			baseurl = "http://udvikling.cyberhus.dk/";

			contentInfoObject = new Xmlloader(contentInfoXml);
			contentInfoObject.addEventListener(Xmlloader.XMLLOADED, contentInfoXmlLoaded);
			contentInfoObject.addEventListener(Xmlloader.NOXML, contentInfoXmlNoXml);
			

		}
		private function contentInfoXmlLoaded(e:Event):void
		{
			createHead();
			
			

		}
		private function contentInfoXmlNoXml(e:Event):void
		{
			
		}
		private function xmlExcist(e:Event):void
		{
			flashMenuLinkbox.senesteindlaeg.addEventListener(MouseEvent.CLICK, senesteindlaegHandler);
		}
		private function noXmlExcist(e:Event):void
		{
			
		}
		private function createHead():void
		{
			
			headarray = new Array();
			var staticGlow:GlowFilter = new GlowFilter(0xE815B9, 0.6, 8,8,3);
			
			for(var i:Number = 0; i <countMenuItems; i++)
			{
				
				container = new Sprite ();
				//here the x and y-position of the fmswf is fetched
				orgriny = contentInfoObject.xmlObject..node[i].node_data_field_text_field_swf_y;
				orgrinx = contentInfoObject.xmlObject..node[i].node_data_field_text_field_swf_x;
				container.x = orgrinx;
				container.y = orgriny;
				
				//here the read-more-text is fetched - but how do we send it along to the containerClickHandler?
				//do we need to write a custom event?
				//somevar = contentInfoObject.xmlObject..node[i].node_data_field_text_field_fm_read_more;
				
				//here the title of the fm item is given to the container
				container.name = contentInfoObject.xmlObject..node[i].node_title;
				headarray.push(container.name);
				swfContent = new Swfloader( baseurl + contentInfoObject.xmlObject..node[i].files_node_data_field_swffile_filepath);
				container.buttonMode = true;
				container.useHandCursor = true;
				container.mouseChildren = false;
				Tweener.addTween(container as MovieClip, { _filter:staticGlow, time:1 } );
				container.addEventListener(MouseEvent.MOUSE_OVER, containerClickHandler);
				container.addChild(swfContent);
				addChild(container);
				
	
			}	
		}
		private function containerClickHandler(event:MouseEvent):void
		{
			linkboxId = event.target.name;
			var mouseOverGlow:GlowFilter = new GlowFilter(0xE815B9, 0.8, 16, 16,1);
			Tweener.addTween(event.target, { _filter:mouseOverGlow, time:3 } );
			if (linkboxExcist)
			{
				Tweener.addTween(flashMenuLinkbox, { x:mouseX, time:1 } );
				Tweener.addTween(flashMenuLinkbox, { y:mouseY, time:1 } );
				toRoom.text = "Til " + event.target.name;
				seneste.text = "Seneste indlæg";

				
			}else {
			// here the Hoverbox is defined
			flashMenuLinkbox = new Linkbox();
			ft = new TextFormat ();
			ft.bold = false;
			ft.font = "Verdana";
			ft.color = 0x663300;
			ft.size = 10;
			toRoom = flashMenuLinkbox.tilvaerelset.linkboxText1;
			toRoom.autoSize = TextFieldAutoSize.LEFT;
			toRoom.defaultTextFormat = ft;
			seneste = flashMenuLinkbox.senesteindlaeg.linkboxText2;
			seneste.autoSize = TextFieldAutoSize.LEFT;
			seneste.defaultTextFormat = ft;
			flashMenuLinkbox.x = mouseX;
			flashMenuLinkbox.y = mouseY;
			
			//the title of the fm item is passed to the node-link in the Hoverbox
			toRoom.text = "Til " + event.target.name;
			seneste.text = "Tjek indlæg";
			flashMenuLinkbox.addEventListener(Event.ADDED_TO_STAGE, linkboxAddedToStage)
			flashMenuLinkbox.tilvaerelset.addEventListener(MouseEvent.CLICK, tilvaerelsetHandler);
			
			flashMenuLinkbox.tilvaerelset.buttonMode = true;
			flashMenuLinkbox.tilvaerelset.useHandCursor = true;
			flashMenuLinkbox.tilvaerelset.mouseChildren = false;
			
			flashMenuLinkbox.tilvaerelset.addEventListener(MouseEvent.MOUSE_OVER, tilvaerelsetover);
			flashMenuLinkbox.senesteindlaeg.addEventListener(MouseEvent.MOUSE_OVER, tilvaerelset1over);
			flashMenuLinkbox.tilvaerelset.addEventListener(MouseEvent.MOUSE_OUT, tilvaerelsetout);
			flashMenuLinkbox.senesteindlaeg.addEventListener(MouseEvent.MOUSE_OUT, tilvaerelset1out);
			
			flashMenuLinkbox.senesteindlaeg.buttonMode = true;
			flashMenuLinkbox.senesteindlaeg.useHandCursor = true;
			flashMenuLinkbox.senesteindlaeg.mouseChildren = false;
			addChild(flashMenuLinkbox);
			}

			xmlob = new Xmlloader(baseurl + contentInfoObject.xmlObject..node[headarray.indexOf(linkboxId)].node_data_field_text_field_text + ".xml");
			xmlob.addEventListener(Xmlloader.XMLLOADED, xmlExcist);
			xmlob.addEventListener(Xmlloader.NOXML, noXmlExcist);
			
		}
		private function tilvaerelsetout(e:MouseEvent):void
		{
			
			toRoom.setTextFormat(ft);
		}
		private function tilvaerelsetover(e:MouseEvent):void
		{
			var format:TextFormat = new TextFormat();
			format.color = 0xFF0000;
			
			toRoom.setTextFormat(format);
			
			
			
		}
		private function tilvaerelset1out(e:MouseEvent):void
		{
			seneste.setTextFormat(ft);
			
		}
		private function tilvaerelset1over(e:MouseEvent):void
		{
			var format:TextFormat = new TextFormat();
			format.color = 0xFF0000;
			seneste.setTextFormat(format);
			
			
			
			
		}
		private function tilvaerelsetHandler(e:MouseEvent):void
		{
			navigateToURL(new URLRequest(baseurl+linkboxId));
		}
		private function senesteindlaegHandler(e:MouseEvent):void
		{
			
			newsboxHeadline = newsmedia.roomtext;
			
			Tweener.addTween(newsboxHeadline, { x:100, time:1, onComplete:function() { Tweener.addTween(newsboxHeadline, { 
				x:37, 
				time:1} );}} );
				
					newsmedia.link1.titletext.text = xmlob.xmlObject..node[0].node_title;
					newsmedia.link2.titletext.text = xmlob.xmlObject..node[1].node_title;
					newsmedia.link3.titletext.text = xmlob.xmlObject..node[2].node_title;
					newsmedia.roomtext.newsheading.text = contentInfoObject.xmlObject..node[headarray.indexOf(linkboxId)].node_title;
					newsmedia.link1.addEventListener(MouseEvent.CLICK, link1Handler);
					newsmedia.link2.addEventListener(MouseEvent.CLICK, link2Handler);
					newsmedia.link3.addEventListener(MouseEvent.CLICK, link3Handler);
				
				
		}

		private function link1Handler(e:MouseEvent):void
		{
			navigateToURL(new URLRequest("http://udvikling.cyberhus.dk/node/" + contentInfoObject.xmlObject..node[0].nid));
		}
		private function link2Handler(e:MouseEvent):void
		{
			navigateToURL(new URLRequest("http://udvikling.cyberhus.dk/node/" + contentInfoObject.xmlObject..node[1].nid));
		}
		private function link3Handler(e:MouseEvent):void
		{
			navigateToURL(new URLRequest("http://udvikling.cyberhus.dk/node/" + contentInfoObject.xmlObject..node[2].nid));
		}
		private function linkboxAddedToStage(event:Event):void
		{
			linkboxExcist = stage.contains(flashMenuLinkbox);
		}

		private function get countMenuItems():Number
		{
			return contentInfoObject.xmlObject..node.length();
		}
		
		
	}
}