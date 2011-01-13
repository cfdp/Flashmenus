package core 
{
	
	import br.com.stimuli.loading.BulkLoader;
	import br.com.stimuli.loading.BulkProgressEvent;
	import components.Mediabox_beta2.Mediabox;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;

	
	
	
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


		//contstructor 
		public function Flashmenu() 
		{
			
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

			
			
			baseurl = "http://udvikling.cyberhus.dk/";
			var xmlUrl:String = baseurl + "fmitems/1053";
			basexmlloader = new BulkLoader("main-site");
			basexmlloader.add(xmlUrl, { id:"basexml", type:"xml" } );
			basexmlloader.add(baseurl + "fmblandet/alle", { id:"defaultmediaboxcontent", type:"xml" } );
			basexmlloader.addEventListener(BulkProgressEvent.COMPLETE, onAllItemsloaded);
			basexmlloader.addEventListener(BulkProgressEvent.PROGRESS, allRoomProgress);
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
			roomxmlloader = new BulkLoader("roomxml");
			
			for (var i:Number = 0; i < countXmlItems; i++)
			{
				roomxmlloader.add(baseurl + basexml..node[i].node_data_field_text_field_text, { id:basexml..node[i].node_title, type:"xml" } );
				roomxmlloader.add(baseurl + basexml..node[i].files_node_data_field_swffile_filepath, { id:"roomswf" + i} );
			}
			roomxmlloader.addEventListener(BulkProgressEvent.COMPLETE, allRoomItemsLoaded);
			roomxmlloader.addEventListener(BulkProgressEvent.PROGRESS, allRoomProgress);
			roomxmlloader.start();
			
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
			var placeFmswf:Fmswf = new Fmswf(basexml, baseurl, movieclipArray);
			addChild(placeFmswf);
			setupMediaText();

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
			mediaobj.titlename.text = "Ungeblogs";
			mediaobj.undertitle.text = "Sundhed og velvære";
			mediaobj.textitem1.headline.text = defaultxml..node[0].node_title;
			mediaobj.textitem2.headline.text = defaultxml..node[1].node_title;
			mediaobj.textitem3.headline.text = defaultxml..node[2].node_title;
			mediaobj.textitem1.type.text = "Type: "+defaultxml..node[0].node_type;
			mediaobj.textitem2.type.text = "Type: "+defaultxml..node[1].node_type;
			mediaobj.textitem3.type.text = "Type: "+defaultxml..node[2].node_type;
			mediaobj.textitem1.readmore.text = "Læs mere";
			mediaobj.textitem2.readmore.text = "Læs mere";
			mediaobj.textitem3.readmore.text = "Læs mere";
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