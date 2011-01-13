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


		//contstructor 
		public function Flashmenu() 
		{
			
			//start loading the base xml file
			loadxml();
			mediaobj = new Mediabox();
			mediaobj.x = 20;
			mediaobj.y = 40;
			addChild(mediaobj);

			
		}
		//loading the base xml for the menu
		private function loadxml():void
		{

			
			
			baseurl = "http://udvikling.cyberhus.dk/";
			var xmlUrl:String = baseurl + "fmitems/1053";
			basexmlloader = new BulkLoader("main-site");
			basexmlloader.add(xmlUrl, { id:"basexml",type:"xml" } );
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
			roomxmlloader = new BulkLoader("roomxml");
			
			for (var i:Number = 0; i < countXmlItems; i++)
			{
				roomxmlloader.add(baseurl + basexml..node[i].node_data_field_text_field_text, { id:basexml..node[i].node_title, type:"xml" } );
				roomxmlloader.add(baseurl + basexml..node[i].files_node_data_field_swffile_filepath, { id:"roompic" + i} );
			}
			roomxmlloader.addEventListener(BulkProgressEvent.COMPLETE, allRoomItemsLoaded);
			roomxmlloader.addEventListener(BulkProgressEvent.PROGRESS, allRoomProgress);
			roomxmlloader.start();
			
		}
		/*fires when ALL items are loaded*/
		private function allRoomItemsLoaded(e:Event):void
		{
			//removing the Textfield and setting the varibel to null making it ready for trash collection
			removeChild(progressOutput);
			progressOutput = null;
		
			
		}
		/*passses the progress information to the mediabox so the user can follow and see the progress*/
		private function allRoomProgress(e:BulkProgressEvent):void
		{
			
			mediaobj.titletext("Henter ting: " + e.itemsLoaded + " / " + e.itemsTotal);
			
		}

		//creating the textfield for show the load progress
		private function createProgressIndicator():void
		{

			progressOutput = new TextField();
			progressOutput.background = true;
			progressOutput.autoSize = TextFieldAutoSize.LEFT;
			var tf:TextFormat = new TextFormat();
			tf.bold = true;
			tf.font = "Verdana";
			tf.size = 12;
			progressOutput.defaultTextFormat = tf;
			progressOutput.text = "Henter ting: ";
			progressOutput.x = 70;
			progressOutput.y = 30;
			addChild(progressOutput);
			

			
		}
		private function createRoomId():void
		{
			
		}

		// count how many menu items there are in the base xml file
		private function get countXmlItems():Number
		{
			return basexml..node.length();
		}
		
	}

}