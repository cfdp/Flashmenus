package core 
{
	
	import br.com.stimuli.loading.BulkLoader;
	import br.com.stimuli.loading.BulkProgressEvent;
	import com.google.analytics.AnalyticsTracker;
	import components.Hoverbox_beta2.Hoverbox;
	import components.Mediabox_beta2.Mediabox;
	import flash.display.Sprite;
	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import caurina.transitions.Tweener;
	import flash.geom.Point;
	import flash.net.navigateToURL;
	import flash.net.URLRequest;
	import utilis.xml.Htmldecoder;
	import flash.filters.GlowFilter;

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
		private var fmswfContainer:MovieClip;
		private var itemId:Array;
		private var tracker:AnalyticsTracker;
		private var staticGlow:GlowFilter;
		
		
		
		public function Fmswf(xmlobj:XML,burl:String,mcarray:Array,media:Mediabox,gatracker:AnalyticsTracker) 
		{
			/** Instantiating varibles.
			 * */
			dataObject = xmlobj;
			//Baseurl to see the value se the Flashmenu class.
			baseurl = burl;
			movieclipArray = mcarray;
			tracker = gatracker;
			hoverboxExcist = false;
			movieclipIdArray = new Array();
			mediabox = media;
			latestXmlIdArray = new Array();
			latestXmlobjArray = new Array();
			latestXmlloader = new BulkLoader("latestinroom");
			latestXmlIdArray.push("empty");
			latestXmlobjArray.push("empty");
			itemId = new Array();
			//Instantiating a glow filter for the mediabox title field.
			staticGlow = new GlowFilter();
			staticGlow.color = 0xfff300;
			staticGlow.alpha = 0;
			staticGlow.strength = 3;
			staticGlow.blurX = 5;
			staticGlow.blurY = 5;

			
			
			
			
			
			//for loop for generating the fmswf's and placing them on stage
			for (var i:Number = 0; i <countMenuItems; i++)
			{
				fmswfContainer = new MovieClip();
				fmswfContainer.name = "item" + i;
				movieclipIdArray.push(dataObject..node[i].node_title);
				itemId.push(fmswfContainer.name);
				fmswfContainer.x = dataObject..node[i].node_data_field_text_field_swf_x;
				fmswfContainer.y = dataObject..node[i].node_data_field_text_field_swf_y;
				fmswfContainer.buttonMode = true;
				fmswfContainer.useHandCursor = true;
				//fmswfContainer.mouseChildren = true;
				fmswfContainer.addChild(movieclipArray[i]);
				addChild(fmswfContainer);
				MovieClip(movieclipArray[i]).addEventListener(MouseEvent.MOUSE_OVER, fmswfContainerMouseOver);
				fmswfContainer.addEventListener(MouseEvent.CLICK, containerClickHandler);
				if (mediabox.mBoundery.hitTestObject(fmswfContainer))
				{
					var num:Number = 424;
					Tweener.addTween(mediabox, { x:num, time:3 } );
				}else{
			
				
				}
				trace(mediabox.hitTestObject(fmswfContainer));
			}

			
			
		}


		/*Check to see if there is more than one instance of the hoverbox
		 * if there are one only add trasition and text*/
		private function fmswfContainerMouseOver (event:MouseEvent):void
		{
			
			
			movieclipId = event.target.parent.parent.name;
			
			var hoverXpos:Number = event.target.parent.parent.x;
			var hoverYpos:Number = event.target.parent.parent.y;
			
			//Check to se if the hoverbox ois outside the flashmovie area.
			var bounderyCheckX:Number 
			if (hoverXpos  > 570 ) {
				bounderyCheckX = hoverXpos - (hoverXpos-570);
			}else if (hoverXpos < 40) {
				bounderyCheckX = 40;
			}else {
				bounderyCheckX = hoverXpos;
			}
			
			mediacontenturl = baseurl + dataObject..node[itemId.indexOf(movieclipId)].node_data_field_text_field_text;

			
			if (hoverboxExcist)
			{
				movieclipId = event.target.parent.parent.name;
				linkbox.setId(movieclipId);
				Tweener.addTween(linkbox, { x:bounderyCheckX, time:0.5, transition:"easeOutSine" } );
				Tweener.addTween(linkbox, { y:hoverYpos, time:0.5, transition:"easeOutSine" } );
				setHoverboxHeadline(movieclipIdArray[itemId.indexOf(event.target.parent.parent.name)]);
				linkbox.mc_latest.latest.text = dataObject..node[itemId.indexOf(movieclipId)].node_data_field_text_field_fm_read_more;
			}else {
					movieclipId = event.target.parent.parent.name;
					linkbox = new Hoverbox(movieclipId,dataObject,baseurl);
					linkbox.addEventListener(Event.ADDED_TO_STAGE, hoverboxAddedHandler);
					Tweener.addTween(linkbox, { x:bounderyCheckX, time:0.5, transition:"easeOutSine" } );
					Tweener.addTween(linkbox, { y:hoverYpos, time:0.5, transition:"easeOutSine" } );
					setHoverboxHeadline(movieclipIdArray[itemId.indexOf(event.target.parent.parent.name)]);
					linkbox.mc_latest.latest.text = dataObject..node[itemId.indexOf(movieclipId)].node_data_field_text_field_fm_read_more;
					linkbox.mc_latest.addEventListener(MouseEvent.CLICK, latestClickHandler);
					
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
			
			MovieClip(mediabox.preloader.bar).gotoAndPlay(1);

			MovieClip(mediabox.preloader).visible = true;
			MovieClip(mediabox.sc.sb.thumb).y = 0;
			
			mediacontenturl = baseurl + dataObject..node[itemId.indexOf(movieclipId)].node_data_field_text_field_text;
			
			
			//Setting a glow filter on the title of the mediabox so the alpha value becomes avalible.
			TextField(mediabox.titlename).filters = [staticGlow];
			TextField(mediabox.undertitle).filters = [staticGlow];
			//Google tracker object
			tracker.trackPageview("hoverbox/" + dataObject..node[itemId.indexOf(movieclipId)].term_data_name + dataObject..node[itemId.indexOf(movieclipId)].node_title);

			
			if (checkId())
			{
				TextField(mediabox.msgarea.messagecontainer).visible = false;
				MovieClip(mediabox.preloader).visible = false;
				Tweener.addTween(TextField(mediabox.titlename), { alpha:0, time:0.1 } );
				Tweener.addTween(TextField(mediabox.undertitle), { alpha:0, time:0.1 } );
				MovieClip(mediabox.sc.sb).visible = true;
				setLatestText();

			}else if (dataObject..node[itemId.indexOf(movieclipId)].node_data_field_text_field_text != undefined) 
			{
				
								
				latestXmlloader.add(mediacontenturl,{id:movieclipId,type:"xml"});
				latestXmlloader.addEventListener(BulkProgressEvent.COMPLETE, latestItemsloaded);
				latestXmlloader.addEventListener(BulkProgressEvent.PROGRESS, onProgress);
				latestXmlloader.get(mediacontenturl).addEventListener(BulkLoader.ERROR, onError);
				latestXmlloader.addEventListener(BulkLoader.ERROR, onError);
				latestXmlloader.start();
				TextField(mediabox.msgarea.messagecontainer).visible = false;
				MovieClip(mediabox.sc.content.textitem1).visible = false;
				MovieClip(mediabox.sc.content.textitem2).visible = false;
				MovieClip(mediabox.sc.content.textitem3).visible = false;
				MovieClip(mediabox.sc.content.textitem4).visible = false;
				MovieClip(mediabox.sc.content.textitem5).visible = false;
				MovieClip(mediabox.sc.content.textitem6).visible = false;
				MovieClip(mediabox.sc.content.textitem7).visible = false;
				MovieClip(mediabox.sc.content.textitem8).visible = false;
				MovieClip(mediabox.sc.content.textitem9).visible = false;
				MovieClip(mediabox.sc.content.textitem10).visible = false;
				MovieClip(mediabox.preloader).visible = true;
				MovieClip(mediabox.sc.sb).visible = true;
				Tweener.addTween(TextField(mediabox.titlename), { alpha:0, time:0.1 } );
				Tweener.addTween(TextField(mediabox.undertitle), { alpha:0, time:0.1} );
				
				


			}else 
			{
				MovieClip(mediabox.sc.sb).visible = false;
				TextField(mediabox.msgarea.messagecontainer).visible = true;
				MovieClip(mediabox.sc.content.textitem1).visible = false;
				MovieClip(mediabox.sc.content.textitem2).visible = false;
				MovieClip(mediabox.sc.content.textitem3).visible = false;
				MovieClip(mediabox.sc.content.textitem4).visible = false;
				MovieClip(mediabox.sc.content.textitem5).visible = false;
				MovieClip(mediabox.sc.content.textitem6).visible = false;
				MovieClip(mediabox.sc.content.textitem7).visible = false;
				MovieClip(mediabox.sc.content.textitem8).visible = false;
				MovieClip(mediabox.sc.content.textitem9).visible = false;
				MovieClip(mediabox.sc.content.textitem10).visible = false;
				MovieClip(mediabox.preloader).visible = false;
				TextField(mediabox.msgarea.messagecontainer).multiline = true;
				TextField(mediabox.msgarea.messagecontainer).wordWrap = true;
				TextField(mediabox.msgarea.messagecontainer).htmlText = dataObject..node[itemId.indexOf(movieclipId)].node_revisions_body;
				Tweener.addTween(TextField(mediabox.titlename), { alpha:0, time:0.1, onComplete:function():void { Tweener.addTween(TextField(mediabox.titlename), { alpha:1, time:5 } ) }} );
				Tweener.addTween(TextField(mediabox.undertitle), { alpha:0, time:0.1, onComplete:function():void { Tweener.addTween(TextField(mediabox.undertitle), { alpha:1, time:5 } ) }} );
				TextField(mediabox.titlename).htmlText = "<b>"+ movieclipIdArray[itemId.indexOf(movieclipId)]+"<b>";
				TextField(mediabox.undertitle).text = dataObject..node[itemId.indexOf(movieclipId)].node_data_field_text_field_subtitle;	
			}
		}
		private function onProgress (e:BulkProgressEvent):void
		{
			
		}

		

		private function onError (e:ErrorEvent):void
		{
			MovieClip(mediabox.sc.content.textitem1).visible = false;
				MovieClip(mediabox.sc.content.textitem2).visible = false;
				MovieClip(mediabox.sc.content.textitem3).visible = false;
				MovieClip(mediabox.sc.content.textitem4).visible = false;
				MovieClip(mediabox.sc.content.textitem5).visible = false;
				MovieClip(mediabox.sc.content.textitem6).visible = false;
				MovieClip(mediabox.sc.content.textitem7).visible = false;
				MovieClip(mediabox.sc.content.textitem8).visible = false;
				MovieClip(mediabox.sc.content.textitem9).visible = false;
				MovieClip(mediabox.sc.content.textitem10).visible = false;
			TextField(mediabox.msgarea.messagecontainer).text = "Ingen data til rådighed";
		}
		private function onTypeError():void
		{
			MovieClip(mediabox.sc.content.textitem1).visible = false;
				MovieClip(mediabox.sc.content.textitem2).visible = false;
				MovieClip(mediabox.sc.content.textitem3).visible = false;
				MovieClip(mediabox.sc.content.textitem4).visible = false;
				MovieClip(mediabox.sc.content.textitem5).visible = false;
				MovieClip(mediabox.sc.content.textitem6).visible = false;
				MovieClip(mediabox.sc.content.textitem7).visible = false;
				MovieClip(mediabox.sc.content.textitem8).visible = false;
				MovieClip(mediabox.sc.content.textitem9).visible = false;
				MovieClip(mediabox.sc.content.textitem10).visible = false;
			MovieClip(mediabox.preloader).visible = false;
			Tweener.addTween(TextField(mediabox.titlename), { alpha:1, time:5 } );
			Tweener.addTween(TextField(mediabox.undertitle), { alpha:1, time:5} );
			TextField(mediabox.titlename).htmlText = "<b>"+ movieclipIdArray[itemId.indexOf(movieclipId)] + "</b>";
			TextField(mediabox.undertitle).text = dataObject..node[itemId.indexOf(movieclipId)].node_data_field_text_field_subtitle;
			TextField(mediabox.msgarea.messagecontainer).visible = true;
			TextField(mediabox.msgarea.messagecontainer).text = "Ingen data til rådighed";
		}

		//check the id of the hoverbox so the xml only gets loaded one time
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
			
			if (latestXmlloader.getXML(movieclipId) == "") {
				
				onTypeError();
				
			}else {
			latestXmlIdArray.push(movieclipId);

			MovieClip(mediabox.preloader).visible = false;
			
			latestXmlobjArray.push(latestXmlloader.getXML(movieclipId));
			//Setting the varible to the xml object
			latestXmlObject = latestXmlobjArray[latestXmlIdArray.indexOf(movieclipId)];
			if (latestXmlObject..node.length() == 0) {
				onTypeError();
			}else {
				setLatestText();
			}
			
				
			
			
			}
		
	

		}
		//Setting text in mediabox when user clicks det link on the hoverbox
		private function setLatestText():void
		{
			
			TextField(mediabox.msgarea.messagecontainer).text = "";
			MovieClip(mediabox.sc.content.textitem1).visible = true;
				MovieClip(mediabox.sc.content.textitem2).visible = true;
				MovieClip(mediabox.sc.content.textitem3).visible = true;
				MovieClip(mediabox.sc.content.textitem4).visible = true;
				MovieClip(mediabox.sc.content.textitem5).visible = true;
				MovieClip(mediabox.sc.content.textitem6).visible = true;
				MovieClip(mediabox.sc.content.textitem7).visible = true;
				MovieClip(mediabox.sc.content.textitem8).visible = true;
				MovieClip(mediabox.sc.content.textitem9).visible = true;
				MovieClip(mediabox.sc.content.textitem10).visible = true;
			//Setting the varible to the xml object
			latestXmlObject = latestXmlobjArray[latestXmlIdArray.indexOf(movieclipId)];
			
			Tweener.addTween(TextField(mediabox.titlename), { alpha:1, time:5 } );
			Tweener.addTween(TextField(mediabox.undertitle), { alpha:1, time:5 } );
			/** Test to see if all 3 nodes are loaded
			 * 
			 */
			if (latestXmlObject..node.length() == 1) {
				MovieClip(mediabox.sc.sb).visible = false;
				MovieClip(mediabox.sc.content.textitem2).visible = false;
				MovieClip(mediabox.sc.content.textitem3).visible = false;
				MovieClip(mediabox.sc.content.textitem4).visible = false;
				mediabox.setTextitem0(checkForText(latestXmlObject..node[0].node_title), checkForText(setTextDate(0)), checkForText(latestXmlObject..node[0].node_type));
				mediabox.setTextitem1("", "", "");
				mediabox.setTextitem2("", "", "");
				mediabox.setTextitem3("", "", "");
				mediabox.setTextitem4("", "", "");
				mediabox.setTextitem5("", "", "");
				mediabox.setTextitem6("", "", "");
				mediabox.setTextitem7("", "", "");
				mediabox.setTextitem8("", "", "");
				mediabox.setTextitem9("", "", "");
				MovieClip(mediabox.sc.content.textitem1).addEventListener(MouseEvent.CLICK, textitem1clickhandler);
				
			}else if (latestXmlObject..node.length() == 2) {
				MovieClip(mediabox.sc.sb).visible = false;
				MovieClip(mediabox.sc.content.textitem3).visible = false;
				MovieClip(mediabox.sc.content.textitem4).visible = false;
				mediabox.setTextitem0(checkForText(latestXmlObject..node[0].node_title), checkForText(setTextDate(0)), checkForText(latestXmlObject..node[0].node_type));
				mediabox.setTextitem1(checkForText(latestXmlObject..node[1].node_title), checkForText(setTextDate(1)), checkForText(latestXmlObject..node[1].node_type));
				mediabox.setTextitem2("", "", "");
				mediabox.setTextitem3("", "", "");
				mediabox.setTextitem4("", "", "");
				mediabox.setTextitem5("", "", "");
				mediabox.setTextitem6("", "", "");
				mediabox.setTextitem7("", "", "");
				mediabox.setTextitem8("", "", "");
				mediabox.setTextitem9("", "", "");
				MovieClip(mediabox.sc.content.textitem1).addEventListener(MouseEvent.CLICK, textitem1clickhandler);
				MovieClip(mediabox.sc.content.textitem2).addEventListener(MouseEvent.CLICK, textitem2clickhandler);
				
			}else if (latestXmlObject..node.length() == 3) {
				MovieClip(mediabox.sc.sb).visible = false;
				MovieClip(mediabox.sc.content.textitem4).visible = false;
				mediabox.setTextitem0(checkForText(latestXmlObject..node[0].node_title), checkForText(setTextDate(0)), checkForText(latestXmlObject..node[0].node_type));
				mediabox.setTextitem1(checkForText(latestXmlObject..node[1].node_title), checkForText(setTextDate(1)), checkForText(latestXmlObject..node[1].node_type));
				mediabox.setTextitem2(checkForText(latestXmlObject..node[2].node_title), checkForText(setTextDate(2)), checkForText(latestXmlObject..node[2].node_type));
				mediabox.setTextitem3("", "", "");
				mediabox.setTextitem4("", "", "");
				mediabox.setTextitem5("", "", "");
				mediabox.setTextitem6("", "", "");
				mediabox.setTextitem7("", "", "");
				mediabox.setTextitem8("", "", "");
				mediabox.setTextitem9("", "", "");
				MovieClip(mediabox.sc.content.textitem1).addEventListener(MouseEvent.CLICK, textitem1clickhandler);
				MovieClip(mediabox.sc.content.textitem2).addEventListener(MouseEvent.CLICK, textitem2clickhandler);
				MovieClip(mediabox.sc.content.textitem3).addEventListener(MouseEvent.CLICK, textitem3clickhandler);
			}else if (latestXmlObject..node.length() == 4) {
				MovieClip(mediabox.sc.sb).visible = false;
				mediabox.setTextitem0(checkForText(latestXmlObject..node[0].node_title), checkForText(setTextDate(0)), checkForText(latestXmlObject..node[0].node_type));
				mediabox.setTextitem1(checkForText(latestXmlObject..node[1].node_title), checkForText(setTextDate(1)), checkForText(latestXmlObject..node[1].node_type));
				mediabox.setTextitem2(checkForText(latestXmlObject..node[2].node_title), checkForText(setTextDate(2)), checkForText(latestXmlObject..node[2].node_type));
				mediabox.setTextitem3(checkForText(latestXmlObject..node[3].node_title), checkForText(setTextDate(3)), checkForText(latestXmlObject..node[3].node_type));
				mediabox.setTextitem4("", "", "");
				mediabox.setTextitem5("", "", "");
				mediabox.setTextitem6("", "", "");
				mediabox.setTextitem7("", "", "");
				mediabox.setTextitem8("", "", "");
				mediabox.setTextitem9("", "", "");
				MovieClip(mediaboxsc.content..textitem1).addEventListener(MouseEvent.CLICK, textitem1clickhandler);
				MovieClip(mediabox.sc.content.textitem2).addEventListener(MouseEvent.CLICK, textitem2clickhandler);
				MovieClip(mediabox.sc.content.textitem3).addEventListener(MouseEvent.CLICK, textitem3clickhandler);
				MovieClip(mediabox.sc.content.textitem4).addEventListener(MouseEvent.CLICK, textitem4clickhandler);
				
			}else if (latestXmlObject..node.length() == 5) {
				MovieClip(mediabox.sc.content.textitem6).visible = false;
				MovieClip(mediabox.sc.content.textitem7).visible = false;
				MovieClip(mediabox.sc.content.textitem8).visible = false;
				MovieClip(mediabox.sc.content.textitem9).visible = false;
				MovieClip(mediabox.sc.content.textitem10).visible = false;
				mediabox.setTextitem0(checkForText(latestXmlObject..node[0].node_title), checkForText(setTextDate(0)), checkForText(latestXmlObject..node[0].node_type));
				mediabox.setTextitem1(checkForText(latestXmlObject..node[1].node_title), checkForText(setTextDate(1)), checkForText(latestXmlObject..node[1].node_type));
				mediabox.setTextitem2(checkForText(latestXmlObject..node[2].node_title), checkForText(setTextDate(2)), checkForText(latestXmlObject..node[2].node_type));
				mediabox.setTextitem3(checkForText(latestXmlObject..node[3].node_title), checkForText(setTextDate(3)), checkForText(latestXmlObject..node[3].node_type));
				mediabox.setTextitem4(checkForText(latestXmlObject..node[4].node_title), checkForText(setTextDate(4)), checkForText(latestXmlObject..node[4].node_type));
				mediabox.setTextitem5("", "", "");
				mediabox.setTextitem6("", "", "");
				mediabox.setTextitem7("", "", "");
				mediabox.setTextitem8("", "", "");
				mediabox.setTextitem9("", "", "");
				MovieClip(mediabox.sc.content.textitem1).addEventListener(MouseEvent.CLICK, textitem1clickhandler);
				MovieClip(mediabox.sc.content.textitem2).addEventListener(MouseEvent.CLICK, textitem2clickhandler);
				MovieClip(mediabox.sc.content.textitem3).addEventListener(MouseEvent.CLICK, textitem3clickhandler);
				MovieClip(mediabox.sc.content.textitem4).addEventListener(MouseEvent.CLICK, textitem4clickhandler);
				MovieClip(mediabox.sc.content.textitem5).addEventListener(MouseEvent.CLICK, textitem5clickhandler);
				
			}else if (latestXmlObject..node.length() == 6) {
				MovieClip(mediabox.sc.content.textitem7).visible = false;
				MovieClip(mediabox.sc.content.textitem8).visible = false;
				MovieClip(mediabox.sc.content.textitem9).visible = false;
				MovieClip(mediabox.sc.content.textitem10).visible = false;
				mediabox.setTextitem0(checkForText(latestXmlObject..node[0].node_title), checkForText(setTextDate(0)), checkForText(latestXmlObject..node[0].node_type));
				mediabox.setTextitem1(checkForText(latestXmlObject..node[1].node_title), checkForText(setTextDate(1)), checkForText(latestXmlObject..node[1].node_type));
				mediabox.setTextitem2(checkForText(latestXmlObject..node[2].node_title), checkForText(setTextDate(2)), checkForText(latestXmlObject..node[2].node_type));
				mediabox.setTextitem3(checkForText(latestXmlObject..node[3].node_title), checkForText(setTextDate(3)), checkForText(latestXmlObject..node[3].node_type));
				mediabox.setTextitem4(checkForText(latestXmlObject..node[4].node_title), checkForText(setTextDate(4)), checkForText(latestXmlObject..node[4].node_type));
				mediabox.setTextitem5(checkForText(latestXmlObject..node[5].node_title), checkForText(setTextDate(5)), checkForText(latestXmlObject..node[5].node_type));
				mediabox.setTextitem6("", "", "");
				mediabox.setTextitem7("", "", "");
				mediabox.setTextitem8("", "", "");
				mediabox.setTextitem9("", "", "");
				MovieClip(mediabox.sc.content.textitem1).addEventListener(MouseEvent.CLICK, textitem1clickhandler);
				MovieClip(mediabox.sc.content.textitem2).addEventListener(MouseEvent.CLICK, textitem2clickhandler);
				MovieClip(mediabox.sc.content.textitem3).addEventListener(MouseEvent.CLICK, textitem3clickhandler);
				MovieClip(mediabox.sc.content.textitem4).addEventListener(MouseEvent.CLICK, textitem4clickhandler);
				MovieClip(mediabox.sc.content.textitem5).addEventListener(MouseEvent.CLICK, textitem5clickhandler);
				MovieClip(mediabox.sc.content.textitem6).addEventListener(MouseEvent.CLICK, textitem6clickhandler);
				
			}else if (latestXmlObject..node.length() == 7) {
					MovieClip(mediabox.sc.content.textitem8).visible = false;
				MovieClip(mediabox.sc.content.textitem9).visible = false;
				MovieClip(mediabox.sc.content.textitem10).visible = false;
				mediabox.setTextitem0(checkForText(latestXmlObject..node[0].node_title), checkForText(setTextDate(0)), checkForText(latestXmlObject..node[0].node_type));
				mediabox.setTextitem1(checkForText(latestXmlObject..node[1].node_title), checkForText(setTextDate(1)), checkForText(latestXmlObject..node[1].node_type));
				mediabox.setTextitem2(checkForText(latestXmlObject..node[2].node_title), checkForText(setTextDate(2)), checkForText(latestXmlObject..node[2].node_type));
				mediabox.setTextitem3(checkForText(latestXmlObject..node[3].node_title), checkForText(setTextDate(3)), checkForText(latestXmlObject..node[3].node_type));
				mediabox.setTextitem4(checkForText(latestXmlObject..node[4].node_title), checkForText(setTextDate(4)), checkForText(latestXmlObject..node[4].node_type));
				mediabox.setTextitem5(checkForText(latestXmlObject..node[5].node_title), checkForText(setTextDate(5)), checkForText(latestXmlObject..node[5].node_type));
				mediabox.setTextitem6(checkForText(latestXmlObject..node[6].node_title), checkForText(setTextDate(6)), checkForText(latestXmlObject..node[6].node_type));
				mediabox.setTextitem7("", "", "");
				mediabox.setTextitem8("", "", "");
				mediabox.setTextitem9("", "", "");
				MovieClip(mediabox.sc.content.textitem1).addEventListener(MouseEvent.CLICK, textitem1clickhandler);
				MovieClip(mediabox.sc.content.textitem2).addEventListener(MouseEvent.CLICK, textitem2clickhandler);
				MovieClip(mediabox.sc.content.textitem3).addEventListener(MouseEvent.CLICK, textitem3clickhandler);
				MovieClip(mediabox.sc.content.textitem4).addEventListener(MouseEvent.CLICK, textitem4clickhandler);
				MovieClip(mediabox.sc.content.textitem5).addEventListener(MouseEvent.CLICK, textitem5clickhandler);
				MovieClip(mediabox.sc.content.textitem6).addEventListener(MouseEvent.CLICK, textitem6clickhandler);
				MovieClip(mediabox.sc.content.textitem7).addEventListener(MouseEvent.CLICK, textitem7clickhandler);
				
			}else if (latestXmlObject..node.length() == 8) {
				MovieClip(mediabox.sc.content.textitem9).visible = false;
				MovieClip(mediabox.sc.content.textitem10).visible = false;
				mediabox.setTextitem0(checkForText(latestXmlObject..node[0].node_title), checkForText(setTextDate(0)), checkForText(latestXmlObject..node[0].node_type));
				mediabox.setTextitem1(checkForText(latestXmlObject..node[1].node_title), checkForText(setTextDate(1)), checkForText(latestXmlObject..node[1].node_type));
				mediabox.setTextitem2(checkForText(latestXmlObject..node[2].node_title), checkForText(setTextDate(2)), checkForText(latestXmlObject..node[2].node_type));
				mediabox.setTextitem3(checkForText(latestXmlObject..node[3].node_title), checkForText(setTextDate(3)), checkForText(latestXmlObject..node[3].node_type));
				mediabox.setTextitem4(checkForText(latestXmlObject..node[4].node_title), checkForText(setTextDate(4)), checkForText(latestXmlObject..node[4].node_type));
				mediabox.setTextitem5(checkForText(latestXmlObject..node[5].node_title), checkForText(setTextDate(5)), checkForText(latestXmlObject..node[5].node_type));
				mediabox.setTextitem6(checkForText(latestXmlObject..node[6].node_title), checkForText(setTextDate(6)), checkForText(latestXmlObject..node[6].node_type));
				mediabox.setTextitem7(checkForText(latestXmlObject..node[7].node_title), checkForText(setTextDate(7)), checkForText(latestXmlObject..node[7].node_type));
				mediabox.setTextitem8("", "", "");
				mediabox.setTextitem9("", "", "");
				MovieClip(mediabox.sc.content.textitem1).addEventListener(MouseEvent.CLICK, textitem1clickhandler);
				MovieClip(mediabox.sc.content.textitem2).addEventListener(MouseEvent.CLICK, textitem2clickhandler);
				MovieClip(mediabox.sc.content.textitem3).addEventListener(MouseEvent.CLICK, textitem3clickhandler);
				MovieClip(mediabox.sc.content.textitem4).addEventListener(MouseEvent.CLICK, textitem4clickhandler);
				MovieClip(mediabox.sc.content.textitem5).addEventListener(MouseEvent.CLICK, textitem5clickhandler);
				MovieClip(mediabox.sc.content.textitem6).addEventListener(MouseEvent.CLICK, textitem6clickhandler);
				MovieClip(mediabox.sc.content.textitem7).addEventListener(MouseEvent.CLICK, textitem7clickhandler);
				MovieClip(mediabox.sc.content.textitem8).addEventListener(MouseEvent.CLICK, textitem8clickhandler);
				
			}else if (latestXmlObject..node.length() == 9) {
				MovieClip(mediabox.sc.content.textitem10).visible = false;
				mediabox.setTextitem0(checkForText(latestXmlObject..node[0].node_title), checkForText(setTextDate(0)), checkForText(latestXmlObject..node[0].node_type));
				mediabox.setTextitem1(checkForText(latestXmlObject..node[1].node_title), checkForText(setTextDate(1)), checkForText(latestXmlObject..node[1].node_type));
				mediabox.setTextitem2(checkForText(latestXmlObject..node[2].node_title), checkForText(setTextDate(2)), checkForText(latestXmlObject..node[2].node_type));
				mediabox.setTextitem3(checkForText(latestXmlObject..node[3].node_title), checkForText(setTextDate(3)), checkForText(latestXmlObject..node[3].node_type));
				mediabox.setTextitem4(checkForText(latestXmlObject..node[4].node_title), checkForText(setTextDate(4)), checkForText(latestXmlObject..node[4].node_type));
				mediabox.setTextitem5(checkForText(latestXmlObject..node[5].node_title), checkForText(setTextDate(5)), checkForText(latestXmlObject..node[5].node_type));
				mediabox.setTextitem6(checkForText(latestXmlObject..node[6].node_title), checkForText(setTextDate(6)), checkForText(latestXmlObject..node[6].node_type));
				mediabox.setTextitem7(checkForText(latestXmlObject..node[7].node_title), checkForText(setTextDate(7)), checkForText(latestXmlObject..node[7].node_type));
				mediabox.setTextitem8(checkForText(latestXmlObject..node[8].node_title), checkForText(setTextDate(8)), checkForText(latestXmlObject..node[8].node_type));
				mediabox.setTextitem9("", "", "");
				MovieClip(mediabox.sc.content.textitem1).addEventListener(MouseEvent.CLICK, textitem1clickhandler);
				MovieClip(mediabox.sc.content.textitem2).addEventListener(MouseEvent.CLICK, textitem2clickhandler);
				MovieClip(mediabox.sc.content.textitem3).addEventListener(MouseEvent.CLICK, textitem3clickhandler);
				MovieClip(mediabox.sc.content.textitem4).addEventListener(MouseEvent.CLICK, textitem4clickhandler);
				MovieClip(mediabox.sc.content.textitem5).addEventListener(MouseEvent.CLICK, textitem5clickhandler);
				MovieClip(mediabox.sc.content.textitem6).addEventListener(MouseEvent.CLICK, textitem6clickhandler);
				MovieClip(mediabox.sc.content.textitem7).addEventListener(MouseEvent.CLICK, textitem7clickhandler);
				MovieClip(mediabox.sc.content.textitem8).addEventListener(MouseEvent.CLICK, textitem8clickhandler);
				MovieClip(mediabox.sc.content.textitem9).addEventListener(MouseEvent.CLICK, textitem9clickhandler);
				
			}else if (latestXmlObject..node.length() == 10) {
				mediabox.setTextitem0(checkForText(latestXmlObject..node[0].node_title), checkForText(setTextDate(0)), checkForText(latestXmlObject..node[0].node_type));
				mediabox.setTextitem1(checkForText(latestXmlObject..node[1].node_title), checkForText(setTextDate(1)), checkForText(latestXmlObject..node[1].node_type));
				mediabox.setTextitem2(checkForText(latestXmlObject..node[2].node_title), checkForText(setTextDate(2)), checkForText(latestXmlObject..node[2].node_type));
				mediabox.setTextitem3(checkForText(latestXmlObject..node[3].node_title), checkForText(setTextDate(3)), checkForText(latestXmlObject..node[3].node_type));
				mediabox.setTextitem4(checkForText(latestXmlObject..node[4].node_title), checkForText(setTextDate(4)), checkForText(latestXmlObject..node[4].node_type));
				mediabox.setTextitem5(checkForText(latestXmlObject..node[5].node_title), checkForText(setTextDate(5)), checkForText(latestXmlObject..node[5].node_type));
				mediabox.setTextitem6(checkForText(latestXmlObject..node[6].node_title), checkForText(setTextDate(6)), checkForText(latestXmlObject..node[6].node_type));
				mediabox.setTextitem7(checkForText(latestXmlObject..node[7].node_title), checkForText(setTextDate(7)), checkForText(latestXmlObject..node[7].node_type));
				mediabox.setTextitem8(checkForText(latestXmlObject..node[8].node_title), checkForText(setTextDate(8)), checkForText(latestXmlObject..node[8].node_type));
				mediabox.setTextitem9(checkForText(latestXmlObject..node[9].node_title), checkForText(setTextDate(9)), checkForText(latestXmlObject..node[9].node_type));
				MovieClip(mediabox.sc.content.textitem1).addEventListener(MouseEvent.CLICK, textitem1clickhandler);
				MovieClip(mediabox.sc.content.textitem2).addEventListener(MouseEvent.CLICK, textitem2clickhandler);
				MovieClip(mediabox.sc.content.textitem3).addEventListener(MouseEvent.CLICK, textitem3clickhandler);
				MovieClip(mediabox.sc.content.textitem4).addEventListener(MouseEvent.CLICK, textitem4clickhandler);
				MovieClip(mediabox.sc.content.textitem5).addEventListener(MouseEvent.CLICK, textitem5clickhandler);
				MovieClip(mediabox.sc.content.textitem6).addEventListener(MouseEvent.CLICK, textitem6clickhandler);
				MovieClip(mediabox.sc.content.textitem7).addEventListener(MouseEvent.CLICK, textitem7clickhandler);
				MovieClip(mediabox.sc.content.textitem8).addEventListener(MouseEvent.CLICK, textitem8clickhandler);
				MovieClip(mediabox.sc.content.textitem9).addEventListener(MouseEvent.CLICK, textitem9clickhandler);
				MovieClip(mediabox.sc.content.textitem10).addEventListener(MouseEvent.CLICK, textitem10clickhandler);
			}else if (latestXmlObject..node.length() < 1) {
				onTypeError();
			}
			
			

				TextField(mediabox.titlename).htmlText = "<b>"+ movieclipIdArray[itemId.indexOf(movieclipId)] + "</b>";
				TextField(mediabox.undertitle).htmlText = dataObject..node[itemId.indexOf(movieclipId)].node_data_field_text_field_subtitle;
				
				
				
		
				

			
			
		}
		private function checkForText(text:String):String
		{
			var testString:String = text;
			if (testString == "" || testString == null) {
				testString = "";
				return testString;
			}else {
				return testString;
			}
		}
			private function textitem1clickhandler(e:MouseEvent):void
		{
			MovieClip(mediabox.preloader.bar).gotoAndPlay(1);
			MovieClip(mediabox.sc.content.textitem1).visible = false;
			MovieClip(mediabox.sc.content.textitem2).visible = false;
			MovieClip(mediabox.sc.content.textitem3).visible = false;
			MovieClip(mediabox.sc.content.textitem4).visible = false;
			MovieClip(mediabox.sc.content.textitem5).visible = false;
			MovieClip(mediabox.sc.content.textitem6).visible = false;
			MovieClip(mediabox.sc.content.textitem7).visible = false;
			MovieClip(mediabox.sc.content.textitem8).visible = false;
			MovieClip(mediabox.sc.content.textitem9).visible = false;
			MovieClip(mediabox.sc.content.textitem10).visible = false;
			MovieClip(mediabox.preloader).visible = true;
			navigateToURL(new URLRequest(baseurl +"node/" + latestXmlObject..node[0].nid), "_self");
			tracker.trackPageview("mediabox/" + dataObject..node[0].term_data_name+"/" + dataObject..node[0].node_title);
		}
		private function textitem2clickhandler(e:MouseEvent):void
		{
			MovieClip(mediabox.preloader.bar).gotoAndPlay(1);
			MovieClip(mediabox.sc.content.textitem1).visible = false;
			MovieClip(mediabox.sc.content.textitem2).visible = false;
			MovieClip(mediabox.sc.content.textitem3).visible = false;
			MovieClip(mediabox.sc.content.textitem4).visible = false;
			MovieClip(mediabox.sc.content.textitem5).visible = false;
			MovieClip(mediabox.sc.content.textitem6).visible = false;
			MovieClip(mediabox.sc.content.textitem7).visible = false;
			MovieClip(mediabox.sc.content.textitem8).visible = false;
			MovieClip(mediabox.sc.content.textitem9).visible = false;
			MovieClip(mediabox.sc.content.textitem10).visible = false;
			MovieClip(mediabox.preloader).visible = true;
			navigateToURL(new URLRequest(baseurl +"node/" + latestXmlObject..node[1].nid), "_self");
			tracker.trackPageview("mediabox/" + dataObject..node[1].term_data_name +"/"+ dataObject..node[1].node_title);
		}
		private function textitem3clickhandler(e:MouseEvent):void
		{
			MovieClip(mediabox.preloader.bar).gotoAndPlay(1);
			MovieClip(mediabox.sc.content.textitem1).visible = false;
			MovieClip(mediabox.sc.content.textitem2).visible = false;
			MovieClip(mediabox.sc.content.textitem3).visible = false;
			MovieClip(mediabox.sc.content.textitem4).visible = false;
			MovieClip(mediabox.sc.content.textitem5).visible = false;
			MovieClip(mediabox.sc.content.textitem6).visible = false;
			MovieClip(mediabox.sc.content.textitem7).visible = false;
			MovieClip(mediabox.sc.content.textitem8).visible = false;
			MovieClip(mediabox.sc.content.textitem9).visible = false;
			MovieClip(mediabox.sc.content.textitem10).visible = false;
			MovieClip(mediabox.preloader).visible = true;
			navigateToURL(new URLRequest(baseurl +"node/" + latestXmlObject..node[2].nid), "_self");
			//Google tracker object.
			tracker.trackPageview("mediabox/" + dataObject..node[2].term_data_name +"/"+ dataObject..node[2].node_title);
		}
		private function textitem4clickhandler(e:MouseEvent):void
		{
			var id:Number = 3;
			MovieClip(mediabox.preloader.bar).gotoAndPlay(1);
			MovieClip(mediabox.sc.content.textitem1).visible = false;
			MovieClip(mediabox.sc.content.textitem2).visible = false;
			MovieClip(mediabox.sc.content.textitem3).visible = false;
			MovieClip(mediabox.sc.content.textitem4).visible = false;
			MovieClip(mediabox.sc.content.textitem5).visible = false;
			MovieClip(mediabox.sc.content.textitem6).visible = false;
			MovieClip(mediabox.sc.content.textitem7).visible = false;
			MovieClip(mediabox.sc.content.textitem8).visible = false;
			MovieClip(mediabox.sc.content.textitem9).visible = false;
			MovieClip(mediabox.sc.content.textitem10).visible = false;
			MovieClip(mediabox.preloader).visible = true;
			navigateToURL(new URLRequest(baseurl +"node/" + latestXmlObject..node[id].nid), "_self");
			//Google tracker object.
			tracker.trackPageview("mediabox/" + dataObject..node[id].term_data_name +"/"+ dataObject..node[id].node_title);
		}
		private function textitem5clickhandler(e:MouseEvent):void
		{
			var id:Number = 4;
			MovieClip(mediabox.preloader.bar).gotoAndPlay(1);
			MovieClip(mediabox.sc.content.textitem1).visible = false;
			MovieClip(mediabox.sc.content.textitem2).visible = false;
			MovieClip(mediabox.sc.content.textitem3).visible = false;
			MovieClip(mediabox.sc.content.textitem4).visible = false;
			MovieClip(mediabox.sc.content.textitem5).visible = false;
			MovieClip(mediabox.sc.content.textitem6).visible = false;
			MovieClip(mediabox.sc.content.textitem7).visible = false;
			MovieClip(mediabox.sc.content.textitem8).visible = false;
			MovieClip(mediabox.sc.content.textitem9).visible = false;
			MovieClip(mediabox.sc.content.textitem10).visible = false;
			MovieClip(mediabox.preloader).visible = true;
			navigateToURL(new URLRequest(baseurl +"node/" + latestXmlObject..node[id].nid), "_self");
			//Google tracker object.
			tracker.trackPageview("mediabox/" + dataObject..node[id].term_data_name +"/"+ dataObject..node[id].node_title);
		}
		private function textitem6clickhandler(e:MouseEvent):void
		{
			var id:Number = 5;
			MovieClip(mediabox.preloader.bar).gotoAndPlay(1);
			MovieClip(mediabox.sc.content.textitem1).visible = false;
			MovieClip(mediabox.sc.content.textitem2).visible = false;
			MovieClip(mediabox.sc.content.textitem3).visible = false;
			MovieClip(mediabox.sc.content.textitem4).visible = false;
			MovieClip(mediabox.sc.content.textitem5).visible = false;
			MovieClip(mediabox.sc.content.textitem6).visible = false;
			MovieClip(mediabox.sc.content.textitem7).visible = false;
			MovieClip(mediabox.sc.content.textitem8).visible = false;
			MovieClip(mediabox.sc.content.textitem9).visible = false;
			MovieClip(mediabox.sc.content.textitem10).visible = false;
			MovieClip(mediabox.preloader).visible = true;
			navigateToURL(new URLRequest(baseurl +"node/" + latestXmlObject..node[id].nid), "_self");
			//Google tracker object.
			tracker.trackPageview("mediabox/" + dataObject..node[id].term_data_name +"/"+ dataObject..node[id].node_title);
		}
		private function textitem7clickhandler(e:MouseEvent):void
		{
			var id:Number = 6;
			MovieClip(mediabox.preloader.bar).gotoAndPlay(1);
			MovieClip(mediabox.sc.content.textitem1).visible = false;
			MovieClip(mediabox.sc.content.textitem2).visible = false;
			MovieClip(mediabox.sc.content.textitem3).visible = false;
			MovieClip(mediabox.sc.content.textitem4).visible = false;
			MovieClip(mediabox.sc.content.textitem5).visible = false;
			MovieClip(mediabox.sc.content.textitem6).visible = false;
			MovieClip(mediabox.sc.content.textitem7).visible = false;
			MovieClip(mediabox.sc.content.textitem8).visible = false;
			MovieClip(mediabox.sc.content.textitem9).visible = false;
			MovieClip(mediabox.sc.content.textitem10).visible = false;
			MovieClip(mediabox.preloader).visible = true;
			navigateToURL(new URLRequest(baseurl +"node/" + latestXmlObject..node[id].nid), "_self");
			//Google tracker object.
			tracker.trackPageview("mediabox/" + dataObject..node[id].term_data_name +"/"+ dataObject..node[id].node_title);
		}
		private function textitem8clickhandler(e:MouseEvent):void
		{
			var id:Number = 7;
			MovieClip(mediabox.preloader.bar).gotoAndPlay(1);
			MovieClip(mediabox.sc.content.textitem1).visible = false;
			MovieClip(mediabox.sc.content.textitem2).visible = false;
			MovieClip(mediabox.sc.content.textitem3).visible = false;
			MovieClip(mediabox.sc.content.textitem4).visible = false;
			MovieClip(mediabox.sc.content.textitem5).visible = false;
			MovieClip(mediabox.sc.content.textitem6).visible = false;
			MovieClip(mediabox.sc.content.textitem7).visible = false;
			MovieClip(mediabox.sc.content.textitem8).visible = false;
			MovieClip(mediabox.sc.content.textitem9).visible = false;
			MovieClip(mediabox.sc.content.textitem10).visible = false;
			MovieClip(mediabox.preloader).visible = true;
			navigateToURL(new URLRequest(baseurl +"node/" + latestXmlObject..node[id].nid), "_self");
			//Google tracker object.
			tracker.trackPageview("mediabox/" + dataObject..node[id].term_data_name +"/"+ dataObject..node[id].node_title);
		}
		private function textitem9clickhandler(e:MouseEvent):void
		{
			var id:Number = 8;
			MovieClip(mediabox.preloader.bar).gotoAndPlay(1);
			MovieClip(mediabox.sc.content.textitem1).visible = false;
			MovieClip(mediabox.sc.content.textitem2).visible = false;
			MovieClip(mediabox.sc.content.textitem3).visible = false;
			MovieClip(mediabox.sc.content.textitem4).visible = false;
			MovieClip(mediabox.sc.content.textitem5).visible = false;
			MovieClip(mediabox.sc.content.textitem6).visible = false;
			MovieClip(mediabox.sc.content.textitem7).visible = false;
			MovieClip(mediabox.sc.content.textitem8).visible = false;
			MovieClip(mediabox.sc.content.textitem9).visible = false;
			MovieClip(mediabox.sc.content.textitem10).visible = false;
			MovieClip(mediabox.preloader).visible = true;
			navigateToURL(new URLRequest(baseurl +"node/" + latestXmlObject..node[id].nid), "_self");
			//Google tracker object.
			tracker.trackPageview("mediabox/" + dataObject..node[id].term_data_name +"/"+ dataObject..node[id].node_title);
		}
			private function textitem10clickhandler(e:MouseEvent):void
		{
			var id:Number = 9;
			MovieClip(mediabox.preloader.bar).gotoAndPlay(1);
			MovieClip(mediabox.sc.content.textitem1).visible = false;
			MovieClip(mediabox.sc.content.textitem2).visible = false;
			MovieClip(mediabox.sc.content.textitem3).visible = false;
			MovieClip(mediabox.sc.content.textitem4).visible = false;
			MovieClip(mediabox.sc.content.textitem5).visible = false;
			MovieClip(mediabox.sc.content.textitem6).visible = false;
			MovieClip(mediabox.sc.content.textitem7).visible = false;
			MovieClip(mediabox.sc.content.textitem8).visible = false;
			MovieClip(mediabox.sc.content.textitem9).visible = false;
			MovieClip(mediabox.sc.content.textitem10).visible = false;
			MovieClip(mediabox.preloader).visible = true;
			navigateToURL(new URLRequest(baseurl +"node/" + latestXmlObject..node[id].nid), "_self");
			//Google tracker object.
			tracker.trackPageview("mediabox/" + dataObject..node[id].term_data_name +"/"+ dataObject..node[id].node_title);
		}
		
		/*Function to convert the unixtime stamp into a date object*/
		private function setTextDate(num:int):String
		{
			var newdate:Date = new Date();
			newdate.setTime(latestXmlObject..node[num].node_created * 1000);
			var textdate:String = newdate.getDate() + "." + (newdate.getMonth() + 1) + "." + newdate.getFullYear();
			return textdate;

		}
		/*handle the user click in the hoverbox and send the user to a new url*/
		private function containerClickHandler(e:MouseEvent):void
		{
			MovieClip(mediabox.preloader.bar).gotoAndPlay(1);
			MovieClip(mediabox.sc.content.textitem1).visible = false;
			MovieClip(mediabox.sc.content.textitem2).visible = false;
			MovieClip(mediabox.sc.content.textitem3).visible = false;
			MovieClip(mediabox.sc.content.textitem4).visible = false;
			MovieClip(mediabox.sc.content.textitem5).visible = false;
			MovieClip(mediabox.sc.content.textitem6).visible = false;
			MovieClip(mediabox.sc.content.textitem7).visible = false;
			MovieClip(mediabox.sc.content.textitem8).visible = false;
			MovieClip(mediabox.sc.content.textitem9).visible = false;
			MovieClip(mediabox.sc.content.textitem10).visible = false;
			TextField(mediabox.msgarea.messagecontainer).visible = false;
			MovieClip(mediabox.preloader).visible = true;
			navigateToURL(new URLRequest(baseurl + dataObject..node[itemId.indexOf(movieclipId)].node_data_field_anmeldelse_link_paakraevet_field_anmeldelse_link_paakraevet), "_self");
			
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
		private function setHoverboxHeadline(str:String):void
		{
			var headline:String = str;
			
			TextField(linkbox.mc_room.toroom).htmlText = headline;
			
			if (TextField(linkbox.mc_room.toroom).textWidth > 93) {
				TextField(linkbox.mc_room.toroom).replaceText(18, 500, "");
				
			}else {
				TextField(linkbox.mc_room.toroom).htmlText = headline;
			}
		}
   /**
     * This method strips all the html tags (excepts those specifically allowed) 
     * from a String and returns the results.
     * 
     * <p>The second param allows for certain tags not to be stripped from the string
     * and are formatted as a String: <code>"<p><b><br>"</code>. This method has the same
     * API as PHP's <code>strip_tags</code> method.</p>
     *
     * @param str The String to strip it's tags
     * @param tags A string of tags allowed
     * @return A new string with the tags stripped
     */
    public function stripTags(str:String, tags:String=null):String
    {
        var pattern:RegExp = /<[^>]*>/gim;
        
        if (tags != null)
        {
            var getChars:RegExp = /(<)([^>]*)(>)/gim;
            var stripPattern:String = tags.replace(getChars, "$2|");
            stripPattern = stripPattern.substr(0, -1);
            stripPattern = "<(?!/?("+stripPattern+")(?=[^a-zA-Z0-9]))[^>]*/?>";
            pattern = new RegExp( stripPattern, "gim");
        }
        
        return str.replace(pattern, "");
    }


		
	}

}