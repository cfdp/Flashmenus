package core 
{
	
	import br.com.stimuli.loading.BulkLoader;
	import br.com.stimuli.loading.BulkProgressEvent;
	import components.Hoverbox_beta2.Hoverbox;
	import components.Mediabox_beta2.Mediabox;
	import flash.display.Sprite;
	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import caurina.transitions.Tweener;
	import flash.net.navigateToURL;
	import flash.net.URLRequest;

	import flash.text.TextField;

	import flash.display.MovieClip;
	import flash.text.TextField;
	

	/**
	 * ...
	 * @author Rene Skou
	 * @description class to handler the placement of fmswf items and instanciating mediabox and hoverbox.
	 * 
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
		private var latestXmlloader:BulkLoader;
		private var latestXmlIdArray:Array;
		private var latestXmlobjArray:Array;
		private var latestXmlObject:XML;
		private var mediacontenturl:String;
		
		
		
		public function Fmswf(xmlobj:XML,burl:String,mcarray:Array,media:Mediabox) 
		{
			dataObject = xmlobj;
			baseurl = burl;
			movieclipArray = mcarray;
			hoverboxExcist = false;
			movieclipIdArray = new Array();
			mediabox = media;
			latestXmlIdArray = new Array();
			latestXmlobjArray = new Array();
			latestXmlloader = new BulkLoader("latestinroom");
			latestXmlIdArray.push("empty");
			latestXmlobjArray.push("empty");

			
			
			
			
			
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

		/*Check to see if there is more than one instance of the hoverbox
		 * if there are one only add trasition and text*/
		private function fmswfContainerMouseOver (event:MouseEvent):void
		{
			if (hoverboxExcist)
			{
				movieclipId = event.target.name;
				linkbox.setId(movieclipId);
				Tweener.addTween(linkbox, { x:mouseX, time:0.5, transition:"easeOutSine" } );
				Tweener.addTween(linkbox, { y:mouseY-5, time:0.5, transition:"easeOutSine" } );
				linkbox.mc_room.toroom.text = "Til " + event.target.name;
				linkbox.mc_latest.latest.text = "Seneste nyheder";
			}else {
					movieclipId = event.target.name;
					linkbox = new Hoverbox(movieclipId,dataObject,baseurl);
					linkbox.addEventListener(Event.ADDED_TO_STAGE, hoverboxAddedHandler);
					Tweener.addTween(linkbox, { x:mouseX, time:0.5, transition:"easeOutSine" } );
					Tweener.addTween(linkbox, { y:mouseY-5, time:0.5, transition:"easeOutSine" } );
					linkbox.mc_room.toroom.text = "Til " + event.target.name;
					linkbox.mc_latest.latest.text = "Seneste nyheder";
					linkbox.mc_latest.addEventListener(MouseEvent.CLICK, latestClickHandler);
					linkbox.mc_room.addEventListener(MouseEvent.CLICK, containerClickHandler);
					addChild(linkbox);
				}
			
		}
		/*Function to handel loading of text for the mediabox
		 * it checks the id first to see if the xml object excist
		 * if the xml does not excist or the url is null it loads statics text from another xml object
		 * if non of the above checks true it throws an error
		 * */
		private function latestClickHandler(e:MouseEvent):void
		{
			mediacontenturl = baseurl + dataObject..node[movieclipIdArray.indexOf(movieclipId)].node_data_field_text_field_text;
			
			Tweener.addTween(TextField(mediabox.titlename), { x:58, time:1, onComplete:function():void {Tweener.addTween(TextField(mediabox.titlename),{x:8,time:1}) }} );
			
			if (checkId())
			{
				setLatestText();
			}else if (mediacontenturl != null) {
				
	
			latestXmlIdArray.push(movieclipId);
			latestXmlloader.add(mediacontenturl,{id:movieclipId,type:"xml"});
			latestXmlloader.addEventListener(BulkProgressEvent.COMPLETE, latestItemsloaded);
			latestXmlloader.addEventListener(BulkLoader.ERROR, onError);
			latestXmlloader.start();
				

			}else {
			
			MovieClip(mediabox.textitem1).visible = false;
			MovieClip(mediabox.textitem2).visible = false;
			MovieClip(mediabox.textitem3).visible = false;
			TextField(mediabox.msgarea.messagecontainer).text = dataObject..node[movieclipIdArray.indexOf(movieclipId)].node_revisions_body;
				
			}
			
		}

		//check the id of the hoverbox so the xml only gets loaded one time

		private function onError (e:ErrorEvent):void
		{
			MovieClip(mediabox.textitem1).visible = false;
			MovieClip(mediabox.textitem2).visible = false;
			MovieClip(mediabox.textitem3).visible = false;
			TextField(mediabox.msgarea.messagecontainer).text = "Ingen data til rådighed";
		}

		private function checkId():Boolean
		{
			if (latestXmlIdArray[latestXmlIdArray.indexOf(movieclipId)] === movieclipId)
			{
				return true;
			}else {
				return false;
				
			}
			
			
		}
		/*if the xmlobject is loaded is puts it in a array and setup the text
		 * */
		private function latestItemsloaded(e:Event):void
		{
			

			latestXmlobjArray.push(latestXmlloader.getXML(movieclipId));
			//Setting the varible to the xml object
			latestXmlObject = latestXmlobjArray[latestXmlIdArray.indexOf(movieclipId)];
			setLatestText();

		}
		//Setting text in mediabox when user clicks det link on the hoverbox
		private function setLatestText():void
		{
			//Setting the varible to the xml object
			latestXmlObject = latestXmlobjArray[latestXmlIdArray.indexOf(movieclipId)];

				TextField(mediabox.titlename).text = movieclipId;
				mediabox.setTextitem0(latestXmlObject..node[0].node_title, setTextDate(0), latestXmlObject..node[0].node_type);
				mediabox.setTextitem1(latestXmlObject..node[1].node_title, setTextDate(1), latestXmlObject..node[1].node_type);
				mediabox.setTextitem2(latestXmlObject..node[2].node_title, setTextDate(2), latestXmlObject..node[2].node_type);
				MovieClip(mediabox.textitem1).addEventListener(MouseEvent.CLICK, textitem1clickhandler);
				MovieClip(mediabox.textitem2).addEventListener(MouseEvent.CLICK, textitem2clickhandler);
				MovieClip(mediabox.textitem3).addEventListener(MouseEvent.CLICK, textitem3clickhandler);
				
				

			
			
		}
		private function textitem1clickhandler(e:MouseEvent):void
		{
			navigateToURL(new URLRequest(baseurl +"node/"+ latestXmlObject..node[0].nid),"_self");
		}
		private function textitem2clickhandler(e:MouseEvent):void
		{
			navigateToURL(new URLRequest(baseurl +"node/"+ latestXmlObject..node[1].nid),"_self");
		}
		private function textitem3clickhandler(e:MouseEvent):void
		{
			navigateToURL(new URLRequest(baseurl +"node/"+ latestXmlObject..node[2].nid),"_self");
		}
		/*Function to convert the unixtime stamp into a date object*/
		private function setTextDate(num:int):String
		{
			var newdate:Date = new Date();
			newdate.setTime(latestXmlObject..node[num].node_created * 1000);
			var textdate:String = newdate.getDate() + "." + "0" + (newdate.getMonth() + 1) + "." + newdate.getFullYear();
			return textdate;
			
		}
		/*handle the user click in the hoverbox and send the user to a new url*/
		private function containerClickHandler(e:MouseEvent):void
		{
			navigateToURL(new URLRequest(baseurl + dataObject..node[movieclipIdArray.indexOf(movieclipId)].node_data_field_anmeldelse_link_paakraevet_field_anmeldelse_link_paakraevet),"_self");
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