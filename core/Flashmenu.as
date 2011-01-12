package core 
{
	
	import components.Mediabox_beta2.Mediabox;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import utilis.xml.Xmlloader;
	
	
	
	/**
	 * ...
	 * @author Rene Skou
	 * @description Flashmenu for Cyberhus 2011
	 */
	public class Flashmenu extends MovieClip
	{
		private var xmlLoaderObj:Xmlloader
		private var baseurl:String;
		private var progressOutput:TextField;
		//contstructor 
		public function Flashmenu() 
		{
			//start loading the base xml file
			loadxml();
			var mediaobj:Mediabox = new Mediabox();
			mediaobj.x = 20;
			mediaobj.y = 40;
			addChild(mediaobj);
			
		}
		//loading the base xml for the menu
		private function loadxml():void
		{
			baseurl = "http://udvikling.cyberhus.dk/";
			var xmlUrl:String = baseurl+"fmitems/1053";
			xmlLoaderObj = new Xmlloader(xmlUrl);
			xmlLoaderObj.addEventListener(Xmlloader.XMLLOADED, xmlIsLoaded);
			xmlLoaderObj.addEventListener(Xmlloader.NOXML, noXmlIsLoaded);
			xmlLoaderObj.addEventListener(Xmlloader.PROGRESS, progresupdate);
			
		}
		//Base xml is loaded then load the individual menu items xml
		private function xmlIsLoaded (event:Event):void
		{
			
			
			for ( var i:Number = 0; i <countXmlItems; i++)
			{
				var loader:Xmlloader = new Xmlloader(baseurl + xmlLoaderObj.xmlObject..node[i].node_data_field_text_field_text+".xml");
				loader.addEventListener(Xmlloader.XMLLOADED, loaded);
				loader.addEventListener(Xmlloader.NOXML, noXmlIsLoaded);
				loader.addEventListener(Xmlloader.PROGRESS, progresupdate);
				
				
			}
			//create the object that places the swffiles form the base xml
			var ob:Fmswf = new Fmswf(xmlLoaderObj.xmlObject,baseurl);
			addChild(ob);

		
		}
		//updating the loadprogress
		private function progresupdate (e:Event):void
		{
			createProgressIndicator();
		}
		
		//handle the xml files if they are not loaded
		private function noXmlIsLoaded (event:Event):void
		{
			
		}
		//handle menu xml files when they are loaded
		private function loaded(e:Event):void
		{
			
			
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
			progressOutput.text = "Loading";
			addChild(progressOutput);
			
		}

		// count how many menu items there are in the base xml file
		private function get countXmlItems():Number
		{
			return xmlLoaderObj.xmlObject..node.length();
		}
		
	}

}