


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
		private var itembox4:MovieClip;
		private var itembox5:MovieClip;
		private var itembox6:MovieClip;
		private var itembox7:MovieClip;
		private var itembox8:MovieClip;
		private var itembox9:MovieClip;
		private var itembox10:MovieClip;
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
			tf.size = 11;
			tf.font = "Verdana";
			tf.color = 0x000000;
			
			_tf = new TextFormat();
			_tf.bold = true;
			_tf.font = "Verdana";
			_tf.size = 10;
			

			//tell the compiler they are movieclips
			itembox1 = sc.content.textitem1;
			itembox2 = sc.content.textitem2;
			itembox3 = sc.content.textitem3;
			itembox4 = sc.content.textitem4;
			itembox5 = sc.content.textitem5;
			itembox6 = sc.content.textitem6;
			itembox7 = sc.content.textitem7;
			itembox8 = sc.content.textitem8;
			itembox9 = sc.content.textitem9;
			itembox10 = sc.content.textitem10;
			
			itembox1.addEventListener(MouseEvent.CLICK, mouseclickItembox);
			itembox2.addEventListener(MouseEvent.CLICK, mouseclickItembox);
			itembox3.addEventListener(MouseEvent.CLICK, mouseclickItembox);
			itembox4.addEventListener(MouseEvent.CLICK, mouseclickItembox);
			itembox5.addEventListener(MouseEvent.CLICK, mouseclickItembox);
			itembox6.addEventListener(MouseEvent.CLICK, mouseclickItembox);
			itembox7.addEventListener(MouseEvent.CLICK, mouseclickItembox);
			itembox8.addEventListener(MouseEvent.CLICK, mouseclickItembox);
			itembox9.addEventListener(MouseEvent.CLICK, mouseclickItembox);
			itembox10.addEventListener(MouseEvent.CLICK, mouseclickItembox);
			
			

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
			trace("run settextitem1");
			itembox1.headline.htmlText = "<b>" + checkForText(headline) + "</b>";
			if (itembox1.headline.textWidth > 173)
			{
				
				itembox1.headline.replaceText(22, 200, "...");
				
			}else{
				itembox1.headline.htmlText = "<b>" + headline + "</b>";
			}
			
			itembox1.type.htmlText = checkForText(testString(type));
			itembox1.date.htmlText = checkForText(date);

		}
		public function setTextitem1(headline:String,date:String,type:String):void
		{
			trace("run settextitem2");
			itembox2.headline.htmlText = "<b>" + checkForText(headline) + "</b>";
						if (itembox2.headline.textWidth > 173)
			{
				
				itembox2.headline.replaceText(22, 200, "...");
				
			}else{
				itembox2.headline.htmlText = "<b>" + checkForText(headline) + "</b>";
			}
			itembox2.type.htmlText = checkForText(testString(type));
			itembox2.date.htmlText = checkForText(date);
		}
		public function setTextitem2(headline:String,date:String,type:String):void
		{
			trace("run settextitem3");

			itembox3.headline.htmlText = "<b>" + checkForText(headline) + "</b>";
						if (itembox3.headline.textWidth > 173)
			{
				
				itembox3.headline.replaceText(22, 200, "...");
				
			}else{
				itembox3.headline.htmlText = "<b>" + headline + "</b>";
			}
			itembox3.type.htmlText = checkForText(testString(type));
			itembox3.date.htmlText = checkForText(date);
		}
		public function setTextitem3(headline:String,date:String,type:String):void
		{
			trace("run settextitem3");

			itembox4.headline.htmlText = "<b>" + checkForText(headline) + "</b>";
						if (itembox4.headline.textWidth > 173)
			{
				
				itembox4.headline.replaceText(22, 200, "...");
				
			}else{
				itembox4.headline.htmlText = "<b>" + headline + "</b>";
			}
			itembox4.type.htmlText = checkForText(testString(type));
			itembox4.date.htmlText = checkForText(date);
		}
		public function setTextitem4(headline:String,date:String,type:String):void
		{
			trace("run settextitem4");

			itembox5.headline.htmlText = "<b>" + checkForText(headline) + "</b>";
						if (itembox5.headline.textWidth > 173)
			{
				
				itembox5.headline.replaceText(22, 200, "...");
				
			}else{
				itembox5.headline.htmlText = "<b>" + headline + "</b>";
			}
			itembox5.type.htmlText = checkForText(testString(type));
			itembox5.date.htmlText = checkForText(date);
		}
		public function setTextitem5(headline:String,date:String,type:String):void
		{
			trace("run settextitem5");

			itembox6.headline.htmlText = "<b>" + checkForText(headline) + "</b>";
						if (itembox6.headline.textWidth > 173)
			{
				
				itembox6.headline.replaceText(22, 200, "...");
				
			}else{
				itembox6.headline.htmlText = "<b>" + headline + "</b>";
			}
			itembox6.type.htmlText = checkForText(testString(type));
			itembox6.date.htmlText = checkForText(date);
		}
		public function setTextitem6(headline:String,date:String,type:String):void
		{
			trace("run settextitem6");

			itembox7.headline.htmlText = "<b>" + checkForText(headline) + "</b>";
						if (itembox7.headline.textWidth > 173)
			{
				
				itembox7.headline.replaceText(22, 200, "...");
				
			}else{
				itembox7.headline.htmlText = "<b>" + headline + "</b>";
			}
			itembox7.type.htmlText = checkForText(testString(type));
			itembox7.date.htmlText = checkForText(date);
		}
		public function setTextitem7(headline:String,date:String,type:String):void
		{
			trace("run settextitem7");

			itembox8.headline.htmlText = "<b>" + checkForText(headline) + "</b>";
						if (itembox8.headline.textWidth > 173)
			{
				
				itembox8.headline.replaceText(22, 200, "...");
				
			}else{
				itembox8.headline.htmlText = "<b>" + headline + "</b>";
			}
			itembox8.type.htmlText = checkForText(testString(type));
			itembox8.date.htmlText = checkForText(date);
		}
		public function setTextitem8(headline:String,date:String,type:String):void
		{
			trace("run settextitem8");

			itembox9.headline.htmlText = "<b>" + checkForText(headline) + "</b>";
						if (itembox9.headline.textWidth > 173)
			{
				
				itembox9.headline.replaceText(22, 200, "...");
				
			}else{
				itembox9.headline.htmlText = "<b>" + headline + "</b>";
			}
			itembox9.type.htmlText = checkForText(testString(type));
			itembox9.date.htmlText = checkForText(date);
		}
		public function setTextitem9(headline:String,date:String,type:String):void
		{
			trace("run settextitem9");

			itembox10.headline.htmlText = "<b>" + checkForText(headline) + "</b>";
						if (itembox10.headline.textWidth > 173)
			{
				
				itembox10.headline.replaceText(22, 200, "...");
				
			}else{
				itembox10.headline.htmlText = "<b>" + headline + "</b>";
			}
			itembox10.type.htmlText = checkForText(testString(type));
			itembox10.date.htmlText = checkForText(date);
		}
		private function checkForText(text:String):String
		{
			var testString:String = text;
			if (testString == "") {
				testString = "";
				return testString;
			}else {
				return testString;
			}
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
				
				case "forum":
				return "Debatten";
				break;
				
				case "historie":
				return "Livsfortællinger";
				break;
				
				default:
				return type;
			}
		}


	}

}