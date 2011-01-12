package core 
{
	
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import utilis.loadcontent.Swfloader;
	/**
	 * ...
	 * @author Rene Skou
	 * @description class to handler the placement of fmswf items
	 */
	public class Fmswf extends Sprite
	{
		private var dataObject:XML;
		private var baseurl:String;
		
		public function Fmswf(xmlobj:XML,burl:String) 
		{
			dataObject = xmlobj;
			baseurl = burl;
			
			//for loop for generating the fmswf's and placing them on stage
			for (var i:Number = 0; i <countMenuItems; i++)
			{
				var fmswfContainer:Sprite = new Sprite();
				fmswfContainer.x = dataObject..node[i].node_data_field_text_field_swf_x;
				fmswfContainer.y = dataObject..node[i].node_data_field_text_field_swf_y;
				var fmswfContent:Swfloader = new Swfloader( baseurl+ dataObject..node[i].files_node_data_field_swffile_filepath);
				fmswfContainer.buttonMode = true;
				fmswfContainer.useHandCursor = true;
				fmswfContainer.mouseChildren = false;
				fmswfContainer.addChild(fmswfContent);
				addChild(fmswfContainer);
				
				fmswfContainer.addEventListener(MouseEvent.MOUSE_OVER, fmswfContainerMouseOver);
			}
			
		}

		private function fmswfContainerMouseOver (event:MouseEvent):void
		{
			
		}
		//counting the nodes  so i know how many swf to generate in my for loop.
		private function get countMenuItems():Number
		{
			return dataObject..node.length();
		}
		
	}

}