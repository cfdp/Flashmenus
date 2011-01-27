


package components.Mediabox_beta2 
{
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import caurina.transitions.Tweener;
	import flash.text.TextFormat;
	import flash.text.TextFieldAutoSize;
	import utilis.xml.Htmldecoder;
	
	
	/**
	 * ...
	 * @author Rene Skou
	 * @description class for showing dynamic created content by drupal cms system
	 * in the mediabox
	 */
	public class Mediabox extends MovieClip 
	{
		
		private var itembox1:MovieClip;
		private var itembox2:MovieClip;
		private var itembox3:MovieClip;
		private var titletext:TextField;
		private var ungeblog:MovieClip;
		private var starway:MovieClip;
		private var tf:TextFormat;
		private var _headline:String;
		private var _tf:TextFormat;

		
		public function Mediabox() 
		{
			setupitems();
		}
		//adds listener to items and mouse action
		private function setupitems ():void
		{
			tf = new TextFormat();
			tf.bold = true;
			tf.size = 12;
			tf.font = "Verdana";
			
			_tf = new TextFormat();
			_tf.bold = true;
			_tf.font = "Verdana";
			_tf.size = 10;
			

			//tell the compiler they are movieclips
			itembox1 = textitem1;
			itembox2 = textitem2;
			itembox3 = textitem3;
			
			itembox1.addEventListener(MouseEvent.CLICK, mouseclickItembox);
			itembox2.addEventListener(MouseEvent.CLICK, mouseclickItembox);
			itembox3.addEventListener(MouseEvent.CLICK, mouseclickItembox);
			
			

			titletext = titlename;
			titletext.selectable = false;
			titletext.autoSize = TextFieldAutoSize.CENTER;
			titletext.defaultTextFormat = tf;
			titletext.text = "Henter elementer 0 / 00";
			
			this.addEventListener(MouseEvent.MOUSE_DOWN, mouseDrag);
			this.addEventListener(MouseEvent.MOUSE_UP, mousestopDrag);
			
			
	
		}
		private function mouseDrag (e:MouseEvent):void
		{
			//MovieClip(this).startDrag();
		}
		private function mousestopDrag(e:MouseEvent):void
		{
			//MovieClip(this).stopDrag();
		}
		//mouse event when client click the itembox
		private function mouseclickItembox (e:MouseEvent):void
		{
			
		}

		//functions for setting up text for the item text fields.
		public function setTextitem0(headline:String,date:String,type:String):void
		{
			itembox1.headline.htmlText = "<b>" + headline + "</b>";
			if (itembox1.headline.textWidth > 173)
			{
				
				itembox1.headline.replaceText(22, 200, "...");
				
			}else{
				itembox1.headline.htmlText = "<b>" + headline + "</b>";
			}
			
			itembox1.type.htmlText = " "+testString(type);
			itembox1.date.htmlText = date;

		}
		public function setTextitem1(headline:String,date:String,type:String):void
		{
			itembox2.headline.htmlText = "<b>" + headline + "</b>";
						if (itembox2.headline.textWidth > 173)
			{
				
				itembox2.headline.replaceText(22, 200, "...");
				
			}else{
				itembox2.headline.htmlText = "<b>" + headline + "</b>";
			}
			itembox2.type.htmlText = " "+testString(type);
			itembox2.date.htmlText = date;
		}
		public function setTextitem2(headline:String,date:String,type:String):void
		{

			itembox3.headline.htmlText = "<b>" + headline + "</b>";
						if (itembox3.headline.textWidth > 173)
			{
				
				itembox3.headline.replaceText(22, 200, "...");
				
			}else{
				itembox3.headline.htmlText = "<b>" + headline + "</b>";
			}
			itembox3.type.htmlText = " "+testString(type);
			itembox3.date.htmlText = date;
		}

		//end of functions
		
		//to test and change the type to a more readerfriendly word
		private function testString(type:String):String
		{
			switch(type)
			{
				case "link_artikel":
				return "Artikel";
				break;
				
				case "poll":
				return "Afstemning";
				break;
				
				case "blog":
				return "Blog";
				break;
				
				case "faq":
				return "Brevkassesvar";
				break;
				
				case "page":
				return "Side";
				break;
				
				default:
				return type;
			}
		}


	}

}