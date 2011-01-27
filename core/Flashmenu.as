package core 
{
	
	
	import br.com.stimuli.loading.BulkLoader;
	import br.com.stimuli.loading.BulkProgressEvent;
	import components.Mediabox_beta2.Mediabox;
	import flash.display.MovieClip;
	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import utilis.xml.Htmldecoder;
	import flash.events.MouseEvent;
	import flash.net.navigateToURL;
	import flash.net.URLRequest;
	import com.google.analytics.AnalyticsTracker;
	import com.google.analytics.GATracker;
	

	
	
	
	/**
	 * ...
	 * @author Rene Skou
	 * @description Flashmenu for Cyberhus 2011
	 * Whats the idea?
     * The visual metaphor of a house serves to build the image of the "safeplace" on the internet that Cyberhus strives to be. 
	 * The focus on the visual at the same time seeks to welcome users that prefer images to words.
     * The purpose of using Flash menus in Cyberhus, is to extend the visual metaphor of the house to 
	 * integrate navigation and browsing in order to make it a natural part of the visual experience of exploring a house.
     * Each 3D-rendered scene is then transformed into the front page of a theme-specific subsection of the site eg. counselling in "Stuen".
     * Integrating content dynamically from our CMS-system into the Flash-menu empowers us to emphasize content on the front pages 
	 * of Cyberhus in a visually pleasing way that - hopefully - invites the user to interaction.
	 * The main file for the Flashmenu, it takes care of all the loading that needs to be done
	 */
	public class Flashmenu extends MovieClip
	{

		private var baseurl:String;
		private var progressOutput:TextField;
		private var basexmlloader:BulkLoader;
		private var basexml:XML;
		private var roomxmlloader:BulkLoader;
		private var roomxml:XML;
		private var mediaobj:Mediabox;
		private var defaultxml:XML;
		private var movieclipArray:Array;
		private var tracker:AnalyticsTracker;
		import flash.external.ExternalInterface;


		//contstructor 
		public function Flashmenu() 
		{
			//Google analytics tracker object.
			tracker = new GATracker(this, "UA-2898416-1", "AS3", false);
			
			//start loading the base xml file
			loadxml();
			mediaobj = new Mediabox();
			mediaobj.x = 20;
			mediaobj.y = 20;
			addChild(mediaobj);

			
		}
		//loading the base xml for the menu
		private function loadxml():void
		{
			//for offline testing/debugging
			var test:Boolean = false;
			if (test)
			{
				baseurl = "http://udvikling.cyberhus.dk/";
				var startxml:String = "fmitems/276";
				var defaultxml:String = "fmblandet/alle";
			}else {
				baseurl = ExternalInterface.call("baseurl");
				startxml = ExternalInterface.call("startxml");
				defaultxml = ExternalInterface.call("defaultxml");
			}
			// end of test stament

			
			
			basexmlloader = new BulkLoader("main-site");
			basexmlloader.add(baseurl + startxml, { id:"basexml", type:"xml" } );
			basexmlloader.add(baseurl + defaultxml, { id:"defaultmediaboxcontent", type:"xml" } );
			basexmlloader.addEventListener(BulkProgressEvent.COMPLETE, onAllItemsloaded);
			basexmlloader.addEventListener(BulkProgressEvent.PROGRESS, allRoomProgress);
			basexmlloader.addEventListener(BulkLoader.ERROR, onError);
			basexmlloader.start();

			//trace(buildingSiteText.length());
		}
		/*when the base xml is loaded start to load roomxml files from basexml
		 * it loops through the basexml file and adds all the roomxml files to
		 * the loading process and adds a id for later reference
		 */
		private function onAllItemsloaded (e:Event):void
		{
			basexml = basexmlloader.getXML("basexml");
			
			defaultxml = basexmlloader.getXML("defaultmediaboxcontent");
			setupMediaText();
			roomxmlloader = new BulkLoader("roomxml");
			
			for (var i:Number = 0; i < countXmlItems; i++)
			{
				
				roomxmlloader.add(baseurl + basexml..node[i].files_node_data_field_swffile_filepath, { id:"roomswf" + i} );
			}
			roomxmlloader.addEventListener(BulkProgressEvent.COMPLETE, allRoomItemsLoaded);
			roomxmlloader.addEventListener(BulkProgressEvent.PROGRESS, allRoomProgress);
			roomxmlloader.addEventListener(BulkLoader.ERROR, onError);
			roomxmlloader.start();
			
		}
		/*Handles error events if the xml is not loaded*/
		private function onError (e:ErrorEvent):void
		{
			MovieClip(mediaobj.textitem1).visible = false;
			MovieClip(mediaobj.textitem2).visible = false;
			MovieClip(mediaobj.textitem3).visible = false;
			TextField(mediaobj.msgarea.messagecontainer).text = "Ingen data til rådighed";
		}
		/*fires when ALL items are loaded
		 * creating an instance of the fmswf class and passes the parameters to it
		 * push the swf in a array container*/
		private function allRoomItemsLoaded(e:Event):void
		{
			movieclipArray = new Array();
			for (var i:Number = 0; i < countXmlItems; i++)
			{
				movieclipArray.push(roomxmlloader.getMovieClip("roomswf" + i));
			}
			var placeFmswf:Fmswf = new Fmswf(basexml, baseurl, movieclipArray,mediaobj);
			addChild(placeFmswf);
			mediaobj.titlename.text = "Ungeblogs";
			mediaobj.undertitle.text = "Sundhed og velvære";
			

		}
		/*passses the progress information to the mediabox so the user can follow and see the progress*/
		private function allRoomProgress(e:BulkProgressEvent):void
		{
			
			mediaobj.titlename.text = "Henter elementer " + e.itemsLoaded + " / " + e.itemsTotal;
			
			
		}

		//creating the textfield for show the load progress

		private function createRoomId():void
		{
			
		}
		/*Set the default text for the mediabox
		 * 
		 * */
		private function setupMediaText():void
		{
			

			mediaobj.setTextitem0(defaultxml..node[0].node_title, setTextDate(0), defaultxml..node[0].node_type);
			mediaobj.setTextitem1(defaultxml..node[1].node_title, setTextDate(1), defaultxml..node[1].node_type);
			mediaobj.setTextitem2(defaultxml..node[2].node_title, setTextDate(2), defaultxml..node[2].node_type);
			MovieClip(mediaobj.textitem1).addEventListener(MouseEvent.CLICK, textitem1clickhandler);
			MovieClip(mediaobj.textitem2).addEventListener(MouseEvent.CLICK, textitem2clickhandler);
			MovieClip(mediaobj.textitem3).addEventListener(MouseEvent.CLICK, textitem3clickhandler);
			

		}
		private function textitem1clickhandler(e:MouseEvent):void
		{
			navigateToURL(new URLRequest(baseurl +"node/"+ defaultxml..node[0].nid),"_self");
		}
		private function textitem2clickhandler(e:MouseEvent):void
		{
			navigateToURL(new URLRequest(baseurl +"node/"+ defaultxml..node[1].nid),"_self");
		}
		private function textitem3clickhandler(e:MouseEvent):void
		{
			navigateToURL(new URLRequest(baseurl +"node/"+ defaultxml..node[2].nid),"_self");
		}
		private function setTextDate(num:int):String
		{
			
			var unixtime:Number = defaultxml..node[num].node_created;
			var data:String = "ingen Data";
			
			if (isNaN(unixtime))
			{
				
				return data;
				
			}else {
				
				
				var newdate:Date = new Date();
				newdate.setTime(unixtime * 1000);
				var textdate:String = newdate.getDate() + "." + "0" + (newdate.getMonth() + 1) + "." + newdate.getFullYear();
				return textdate;
	
			}
			
		}

		

		/*count how many menu items there are in the base xml file
		 * this function also serves as number container for loops
		 * */
		private function get countXmlItems():Number
		{
			return basexml..node.length();
		}
		
	}

}