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
	import flash.display.SimpleButton;
	import flash.external.ExternalInterface;
	

	
	
	
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
			//mediaobj.preloader.bar.scaleX = 0;
			//mediaobj.preloader._txt.visible = false;
			MovieClip(mediaobj.sc.content.textitem1).visible = false;
			MovieClip(mediaobj.sc.content.textitem2).visible = false;
			MovieClip(mediaobj.sc.content.textitem3).visible = false;
			MovieClip(mediaobj.sc.content.textitem4).visible = false;
			MovieClip(mediaobj.sc.sb).visible = false;

			
			
			
			
			

			
		}
		//loading the base xml for the menu
		private function loadxml():void
		{
			/**for offline testing/debugging in a lokal environment set test varibel to true
			 * You can use the following numbers for testing on startxml and defaultxml, to test
			 * Against online content.
			 * 
			 * !! WHEN TESTING THE FRONTPAGE PASS ANOTHER NUMBER THEN 1196 ON THE DEFAULTXML STRING !!
			 * 
			 * forsiden: 		1196  movieclip frame name "frontpage"
			 * Nueh:     		1003  movieclip frame name "nueh"
			 * Lovstuen:  	 	 275  movieclip frame name "lov"
			 * Badeværlse: 	 	 274  movieclip frame name "bade"
			 * Lystværelse:	 	 276  movieclip frame name "lyst"
			 * stue:		 	 272  movieclip frame name "stue"
			 * Bibliotek:	 	 278  movieclip frame name "Bib"
			 * Mediehulen:	 	 283  movieclip frame name "medie"
			 * Kunstværksted:	 281  movieclip frame name "kunst"
			 * */
			var test:Boolean = false;
			if (test)
			{
				baseurl = "http://www.cyberhus.dk/";
				var startxml:String = "fmitems/281";
				var defaultxml:String = "fmblandet/281";
				
				
				
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
			
				MovieClip(mediaobj.sc.content.textitem1).visible = false;
				MovieClip(mediaobj.sc.content.textitem2).visible = false;
				MovieClip(mediaobj.sc.content.textitem3).visible = false;
				MovieClip(mediaobj.sc.content.textitem4).visible = false;
				MovieClip(mediaobj.sc.content.textitem5).visible = false;
				MovieClip(mediaobj.sc.content.textitem6).visible = false;
				MovieClip(mediaobj.sc.content.textitem7).visible = false;
				MovieClip(mediaobj.sc.content.textitem8).visible = false;
				MovieClip(mediaobj.sc.content.textitem9).visible = false;
				MovieClip(mediaobj.sc.content.textitem10).visible = false;
				
			
			
			TextField(mediaobj.msgarea.messagecontainer).text = "Ingen data til rådighed";
		}
		/*fires when ALL items are loaded
		 * creating an instance of the fmswf class and passes the parameters to it
		 * push the swf in a array container*/
		private function allRoomItemsLoaded(e:Event):void
		{
			MovieClip(mediaobj.preloader).visible = false;
			MovieClip(mediaobj.sc.sb).visible = true;
			MovieClip(mediaobj.sc.content.textitem1).visible = true;
			MovieClip(mediaobj.sc.content.textitem2).visible = true;
			MovieClip(mediaobj.sc.content.textitem3).visible = true;
			MovieClip(mediaobj.sc.content.textitem4).visible = true;
			MovieClip(mediaobj.sc.content.textitem5).visible = true;
			MovieClip(mediaobj.sc.content.textitem6).visible = true;
			MovieClip(mediaobj.sc.content.textitem7).visible = true;
			MovieClip(mediaobj.sc.content.textitem8).visible = true;
			MovieClip(mediaobj.sc.content.textitem9).visible = true;
			MovieClip(mediaobj.sc.content.textitem10).visible = true;
			
			
	
			movieclipArray = new Array();
			for (var i:Number = 0; i < countXmlItems; i++)
			{
				movieclipArray.push(roomxmlloader.getMovieClip("roomswf" + i));

				
			}
			var placeFmswf:Fmswf = new Fmswf(basexml, baseurl, movieclipArray,mediaobj,tracker);
			addChild(placeFmswf);
			TextField(mediaobj.titlename).htmlText = "<b>" + changeTitle(basexml..node[1].term_data_name) + "</b>";
			TextField(mediaobj.undertitle).htmlText = "Seneste indlæg";
			
			
			
			

		}
		/** Test to the title string.
		 * */
		private function changeTitle (str:String):String
		{
			if (str == "Forsiden") {
				return "Velkommen til Cyberhus";
			}else {
				return basexml..node[1].term_data_name;
			}
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
			trace("run setupmediatext");
			

			mediaobj.setTextitem0(defaultxml..node[0].node_title, setTextDate(0), defaultxml..node[0].node_type);
			mediaobj.setTextitem1(defaultxml..node[1].node_title, setTextDate(1), defaultxml..node[1].node_type);
			mediaobj.setTextitem2(defaultxml..node[2].node_title, setTextDate(2), defaultxml..node[2].node_type);
			mediaobj.setTextitem3(defaultxml..node[3].node_title, setTextDate(3), defaultxml..node[3].node_type);
			mediaobj.setTextitem4(defaultxml..node[4].node_title, setTextDate(4), defaultxml..node[4].node_type);
			mediaobj.setTextitem5(defaultxml..node[5].node_title, setTextDate(5), defaultxml..node[5].node_type);
			mediaobj.setTextitem6(defaultxml..node[6].node_title, setTextDate(6), defaultxml..node[6].node_type);
			mediaobj.setTextitem7(defaultxml..node[7].node_title, setTextDate(7), defaultxml..node[7].node_type);
			mediaobj.setTextitem8(defaultxml..node[8].node_title, setTextDate(8), defaultxml..node[8].node_type);
			mediaobj.setTextitem9(defaultxml..node[9].node_title, setTextDate(9), defaultxml..node[9].node_type);
			
			MovieClip(mediaobj.sc.content.textitem1).addEventListener(MouseEvent.CLICK, textitem1clickhandler);
			MovieClip(mediaobj.sc.content.textitem2).addEventListener(MouseEvent.CLICK, textitem2clickhandler);
			MovieClip(mediaobj.sc.content.textitem3).addEventListener(MouseEvent.CLICK, textitem3clickhandler);
			MovieClip(mediaobj.sc.content.textitem4).addEventListener(MouseEvent.CLICK, textitem4clickhandler);
			MovieClip(mediaobj.sc.content.textitem5).addEventListener(MouseEvent.CLICK, textitem5clickhandler);
			MovieClip(mediaobj.sc.content.textitem6).addEventListener(MouseEvent.CLICK, textitem6clickhandler);
			MovieClip(mediaobj.sc.content.textitem7).addEventListener(MouseEvent.CLICK, textitem7clickhandler);
			MovieClip(mediaobj.sc.content.textitem8).addEventListener(MouseEvent.CLICK, textitem8clickhandler);
			MovieClip(mediaobj.sc.content.textitem9).addEventListener(MouseEvent.CLICK, textitem9clickhandler);
			MovieClip(mediaobj.sc.content.textitem10).addEventListener(MouseEvent.CLICK, textitem10clickhandler);
			
			

		}
		private function textitem1clickhandler(e:MouseEvent):void
		{
			navigateToURL(new URLRequest(baseurl +"node/" + defaultxml..node[0].nid), "_self");
			//Gooogle tracker object.
			tracker.trackPageview("mediabox/" + defaultxml..node[0].term_data_name + defaultxml..node[0].node_title);
			
		}
		private function textitem2clickhandler(e:MouseEvent):void
		{
			navigateToURL(new URLRequest(baseurl +"node/" + defaultxml..node[1].nid), "_self");
			//Google tracker object.
			tracker.trackPageview("mediabox/" + defaultxml..node[1].term_data_name + defaultxml..node[1].node_title);
		}
		private function textitem3clickhandler(e:MouseEvent):void
		{
			navigateToURL(new URLRequest(baseurl +"node/" + defaultxml..node[2].nid), "_self");
			//Google tracker object.
			tracker.trackPageview("mediabox/" + defaultxml..node[2].term_data_name + defaultxml..node[2].node_title);
		}
		
		private function textitem4clickhandler(e:MouseEvent):void
		{
			var id:Number = 3;
			navigateToURL(new URLRequest(baseurl +"node/" + defaultxml..node[id].nid), "_self");
			//Gooogle tracker object.
			tracker.trackPageview("mediabox/" + defaultxml..node[id].term_data_name + defaultxml..node[id].node_title);
			
		}
		private function textitem5clickhandler(e:MouseEvent):void
		{
			var id:Number = 4;
			navigateToURL(new URLRequest(baseurl +"node/" + defaultxml..node[id].nid), "_self");
			//Gooogle tracker object.
			tracker.trackPageview("mediabox/" + defaultxml..node[id].term_data_name + defaultxml..node[id].node_title);
			
		}
		private function textitem6clickhandler(e:MouseEvent):void
		{
			var id:Number = 5;
			navigateToURL(new URLRequest(baseurl +"node/" + defaultxml..node[id].nid), "_self");
			//Gooogle tracker object.
			tracker.trackPageview("mediabox/" + defaultxml..node[id].term_data_name + defaultxml..node[id].node_title);
			
		}
		private function textitem7clickhandler(e:MouseEvent):void
		{
			var id:Number = 6;
			navigateToURL(new URLRequest(baseurl +"node/" + defaultxml..node[id].nid), "_self");
			//Gooogle tracker object.
			tracker.trackPageview("mediabox/" + defaultxml..node[id].term_data_name + defaultxml..node[id].node_title);
			
		}
		private function textitem8clickhandler(e:MouseEvent):void
		{
			var id:Number = 7;
			navigateToURL(new URLRequest(baseurl +"node/" + defaultxml..node[id].nid), "_self");
			//Gooogle tracker object.
			tracker.trackPageview("mediabox/" + defaultxml..node[id].term_data_name + defaultxml..node[id].node_title);
			
		}
		private function textitem9clickhandler(e:MouseEvent):void
		{
			var id:Number = 8;
			navigateToURL(new URLRequest(baseurl +"node/" + defaultxml..node[id].nid), "_self");
			//Gooogle tracker object.
			tracker.trackPageview("mediabox/" + defaultxml..node[id].term_data_name + defaultxml..node[id].node_title);
			
		}
		private function textitem10clickhandler(e:MouseEvent):void
		{
			var id:Number = 9;
			navigateToURL(new URLRequest(baseurl +"node/" + defaultxml..node[id].nid), "_self");
			//Gooogle tracker object.
			tracker.trackPageview("mediabox/" + defaultxml..node[id].term_data_name + defaultxml..node[id].node_title);
			
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
				
				var textdate:String = newdate.getDate() + "." + (newdate.getMonth() + 1) + "." + newdate.getFullYear();
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