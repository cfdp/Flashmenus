package components.Hoverbox_beta2 
{
	import components.Mediabox_beta2.Mediabox;
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFieldAutoSize;
	
	/**
	 * ...
	 * @author René Skou
	 * A floating box with holds the 2 links the room and to show the 3 latest content items 
	 */
	public class Hoverbox extends MovieClip 
	{
		private var latestpost:TextField;
		private var getRoom:TextField;
		private var mcLatestpost:MovieClip;
		private var mcGetroom:MovieClip;
		private var textformat:TextFormat;
		private var textformatTitle:TextFormat;
		private var tf:TextFormat;
		private var movieclipId:String;
		private var xmlObject:XML;
		private var baseurl:String;
		
		public function Hoverbox(id:String,xmlobj:XML,burl:String) 
		{
			setupTextfields();
			movieclipId = id;
			xmlObject = xmlobj;
			baseurl = burl;
			MovieClip(preloader_circle).visible = false;
		}
		//setting up the text and textfields
		private function setupTextfields():void
		{
			textformat = new TextFormat();
			textformat.font = "Verdana";
			textformat.color = 0x823F0A;
			textformat.size = 9;
			
			textformatTitle = new TextFormat();
			textformatTitle.font = "Verdana";
			textformatTitle.color = 0x000000;
			textformatTitle.size = 9;
			
			tf = new TextFormat();
			tf.color = 0xE48515;
			
			latestpost = mc_latest.latest;
			mcLatestpost = mc_latest;
			getRoom = mc_room.toroom;
			mcGetroom = mc_room;
			
			latestpost.selectable = false;
			latestpost.autoSize = TextFieldAutoSize.CENTER;
			latestpost.defaultTextFormat = textformat;
			mcLatestpost.buttonMode = true;
			mcLatestpost.useHandCursor = true;
			mcLatestpost.mouseChildren = false;
			mcLatestpost.addEventListener(MouseEvent.CLICK, latestClickHandler);
			mcLatestpost.addEventListener(MouseEvent.MOUSE_OVER, latestmouseoverHandler);
			mcLatestpost.addEventListener(MouseEvent.MOUSE_OUT, latestmouseoutHandler);
			
			
			getRoom.selectable = false;
			getRoom.autoSize = TextFieldAutoSize.CENTER;
			getRoom.defaultTextFormat = textformatTitle;
			mcGetroom.buttonMode = true;
			mcGetroom.useHandCursor = true;
			mcGetroom.mouseChildren = false;
			//mcGetroom.addEventListener(MouseEvent.CLICK, roomClickHandler);
			//mcGetroom.addEventListener(MouseEvent.MOUSE_OVER, roommouseoverHandler);
			//mcGetroom.addEventListener(MouseEvent.MOUSE_OUT, roommouseoutHandler);
		}
		private function latestClickHandler (e:MouseEvent):void
		{
			
		}
		private function roomClickHandler(e:MouseEvent):void
		{
			
			
		}
		//functions to set the textformat
		private function roommouseoverHandler(e:MouseEvent):void
		{
			
			
			getRoom.setTextFormat(tf);
		}
		private function roommouseoutHandler(e:MouseEvent):void
		{
			
			getRoom.setTextFormat(textformat);
		}
		private function latestmouseoverHandler(e:MouseEvent):void
		{
			
			latestpost.setTextFormat(tf);
		}
		private function latestmouseoutHandler(e:MouseEvent):void
		{
			
			latestpost.setTextFormat(textformat);
		}
		//public function to set the id of the hoverbox
		public function setId(idname:String):void
		{
			movieclipId = idname;
		}
		
	}

}