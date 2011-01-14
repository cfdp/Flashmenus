package core 
{
	
	import components.Hoverbox_beta2.Hoverbox;
	import components.Mediabox_beta2.Mediabox;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import caurina.transitions.Tweener;
	import flash.net.navigateToURL;
	import flash.net.URLRequest;
	/**
	 * ...
	 * @author Rene Skou
	 * @description class to handler the placement of fmswf items
	 */
	public class Fmswf extends Sprite
	{
		private var dataObject:XML;
		private var baseurl:String;
		private var movieclipArray:Array;
		private var linkbox:Hoverbox;
		private var movieclipId:String;
		private var hoverboxExcist:Boolean;
		private var movieclipIdArray:Array;
		private var mediabox:Mediabox;
		
		
		
		public function Fmswf(xmlobj:XML,burl:String,mcarray:Array,media:Mediabox) 
		{
			dataObject = xmlobj;
			baseurl = burl;
			movieclipArray = mcarray;
			hoverboxExcist = false;
			movieclipIdArray = new Array();
			mediabox = media;
			
			
			
			
			
			//for loop for generating the fmswf's and placing them on stage
			for (var i:Number = 0; i <countMenuItems; i++)
			{
				var fmswfContainer:Sprite = new Sprite();
				fmswfContainer.name = dataObject..node[i].node_title;
				movieclipIdArray.push(fmswfContainer.name);
				fmswfContainer.x = dataObject..node[i].node_data_field_text_field_swf_x;
				fmswfContainer.y = dataObject..node[i].node_data_field_text_field_swf_y;
				fmswfContainer.buttonMode = true;
				fmswfContainer.useHandCursor = true;
				fmswfContainer.mouseChildren = false;
				fmswfContainer.addChild(movieclipArray[i]);
				addChild(fmswfContainer);
				
				fmswfContainer.addEventListener(MouseEvent.MOUSE_OVER, fmswfContainerMouseOver);
				fmswfContainer.addEventListener(MouseEvent.CLICK, containerClickHandler);
			}
			
			
		}

		private function fmswfContainerMouseOver (event:MouseEvent):void
		{
			if (hoverboxExcist)
			{
				movieclipId = event.target.name;
				linkbox.setId(movieclipId);
				Tweener.addTween(linkbox, { x:mouseX, time:0.5, transition:"easeOutSine" } );
				Tweener.addTween(linkbox, { y:mouseY-5, time:0.5, transition:"easeOutSine" } );
				linkbox.mc_room.toroom.text = "Til " + event.target.name;
				linkbox.mc_latest.latest.text = "Læs mere";
			}else {
					movieclipId = event.target.name;
					linkbox = new Hoverbox(movieclipId,dataObject,baseurl);
					linkbox.addEventListener(Event.ADDED_TO_STAGE, hoverboxAddedHandler);
					Tweener.addTween(linkbox, { x:mouseX, time:0.5, transition:"easeOutSine" } );
					Tweener.addTween(linkbox, { y:mouseY-5, time:0.5, transition:"easeOutSine" } );
					linkbox.mc_room.toroom.text = "Til " + event.target.name;
					linkbox.mc_latest.latest.text = "Læs mere";
					linkbox.mc_latest.addEventListener(MouseEvent.CLICK, latestClickHandler);
					addChild(linkbox);
				}
			
		}
		private function latestClickHandler(e:MouseEvent):void
		{
			
		}
		private function containerClickHandler(e:MouseEvent):void
		{
			navigateToURL(new URLRequest(baseurl + dataObject..node[movieclipIdArray.indexOf(movieclipId)].node_data_field_anmeldelse_link_paakraevet_field_anmeldelse_link_paakraevet),"self");
		}
		private function hoverboxAddedHandler (e:Event):void
		{
			hoverboxExcist = stage.contains(linkbox);
		}
		//counting the nodes  so i know how many swf to generate in my for loop.
		private function get countMenuItems():Number
		{
			return dataObject..node.length();
		}
		
	}

}