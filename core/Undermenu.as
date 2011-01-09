/**
* Code by Rene´Skou 2008
* Class creates submenus for cybermenu 
* @Edit: Kristoffer Sall Hansen (Refunk.dk) 17-06-09 
* @Description: txtwin kører nu på InfoBox og kan derfor benytte farver og alpha
* variablen swfcontent er nu udkommenteret da den ikke ser ud til at tjene et formål
*/
package core
{
	import utilis.testassets.BlackButtom;
	import utilis.testassets.InfoBox;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.ColorTransform;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	
	import utilis.loadcontent.Swfloader;
	import utilis.testassets.balls.Dot;
	
	public class Undermenu extends Sprite
	{
		public var underContainer:Sprite;
		private var underpoint:Dot;
		private var underarray:Array;
		private var arrayHead:Array;
		private var num:int;
		private var j:int;
		private var headXpos:Number;
		private var headYpos:Number;
		private var headHeight:Number;
		private var underYpos:int;
		private var underXpos:int;
		private var elementNum:int;
		private var undermenunum:int;
		private var headname:String;
		private var whitebuttom:BlackButtom;
		private var swfcontent:Swfloader;
		private var textBox:InfoBox;
		private var xmlcon:XML;


		
		
		public function Undermenu(headA:Array,headS:String,hxpos:Number,hypos:Number,hheight:Number,xml:XML)
		{

			headname = headS;
			arrayHead = headA;
			headXpos = hxpos;
			headYpos = hypos;
			headHeight = hheight;
			xmlcon = xml;
			initUndermenu();	
		}
		
		private function initUndermenu():void
		{
			underContainer = new Sprite();
			underarray = new Array();
			textBox = new InfoBox();
			elementNum = arrayHead.indexOf(headname);
			whitebuttom = new BlackButtom();
			
			/*** The window is set up with the config from the XML ***/
			/*** Beware, all elements MUST theese attributes otherwise the offsets are wrong ***/
			textBox._fontColor = xmlcon..tekstfarve[elementNum];
			textBox.boxalpha = xmlcon..gennemsigthed[elementNum];
			/*** The container doesnt have a default position so we set it here ***/
			textBox.containerX = 0;
			textBox.containerY = 0;
			textBox.topColor = xmlcon..baggrundsfarve[elementNum].@topfarve;
			textBox.buttomColor = xmlcon..baggrundsfarve[elementNum].@bundfarve;
			textBox._content = xmlcon..menukategori[elementNum];
			textBox._headline = xmlcon..overskrift[elementNum];
			/*** Setup is complete and we initialize the window ***/
			textBox.setupcontainer();
			if(headXpos > 408){
				headXpos = headXpos-40;
				textBox.x = headXpos-textBox.width;
				whitebuttom.x = headXpos;
				
			}else{
			textBox.x = headXpos+35;
			headXpos = headXpos;
			whitebuttom.x = headXpos-20;
			}
			
			underYpos = headYpos+headHeight;
			var textpos:Number = headYpos+textBox.width;
			var numminus:Number = textpos-487;
			if(textpos > 487){
				
				textBox.y = headYpos-numminus;
				whitebuttom.y = headYpos-whitebuttom.height+20;
				
				
			}else{
				textBox.y = headYpos;
				whitebuttom.y = headYpos-20;

			}
			
			
			for( j = 0; j <undercount; j++)
			{
				underpoint = new Dot(0,0,7,0x000000);
				underpoint.name = "menu"+j;
				underarray.push(underpoint.name);
				underpoint.addEventListener(MouseEvent.MOUSE_OVER, underOverHandler);
				underpoint.addEventListener(MouseEvent.MOUSE_OUT, underOutHandler);
				underpoint.addEventListener(MouseEvent.CLICK, clickHandler);
				underpoint.transform.colorTransform = new ColorTransform(1,1,1,1,
				xmlcon..farve[j].@roed,xmlcon..farve[j].@groen,
				xmlcon..farve[j].@blaa,1);
				underXpos = headXpos;
				underpoint.x = underXpos+20;
				if(textpos > 487){
					underYpos = underYpos-25;
				}else {
				underYpos = underYpos+25;

				}
				underpoint.y = underYpos;
				underpoint.mouseChildren = false;
				underContainer.addChild(underpoint);
				
			}
			//trace(underContainer.height);
			underContainer.addChild(textBox);
			addChild(underContainer);
			
			
			
			



			/*whitebuttom.addEventListener(MouseEvent.ROLL_OUT, whiteOutListener,false,0,true);
			addChild(whitebuttom,1);*/

		}
		private function underOverHandler(event:MouseEvent):void
		{
				undermenunum = underarray.indexOf(event.target.name);
				
				swfcontent = new Swfloader(xmlcon..menupunkter[elementNum].menupunkt[undermenunum].@billedurl);
				var framexpos:Number = xmlcon..menupunkter[elementNum].menupunkt[undermenunum].@billedxpos;
				var picxpos:Number = xmlcon..billedpos[elementNum].@xpos;
				swfcontent.x = picxpos + framexpos;
				var frameypos:Number = xmlcon..menupunkter[elementNum].menupunkt[undermenunum].@billedypos;
				var picypos:Number = xmlcon..billedpos[elementNum].@ypos;
				swfcontent.y = picypos  + frameypos;
				addChild(swfcontent);
		
				textBox._headline = xmlcon..menupunkter[elementNum].menupunkt[undermenunum].@titel;
				textBox._content = xmlcon..menupunkter[elementNum].menupunkt[undermenunum];
				textBox.setupcontainer();
				swfcontent.addEventListener(Swfloader.ADDTOSTAGE, stageListener);
		}
		private function stageListener(e:Event):void
		{
			if(underpoint.hitTestObject(swfcontent)){
				var errormessage:error = new error();
				errormessage.errortext.text = "Din swf overlapper din menu knap";
				errormessage.x = 50;
				errormessage.y = 50;
				addChildAt(errormessage,1);
			}
		}
		private function underOutHandler(e:MouseEvent):void
		{
			removeChild(swfcontent);
		}
		private function clickHandler(e:MouseEvent):void
		{
			navigateToURL(new URLRequest(xmlcon..menupunkter[elementNum].menupunkt[undermenunum].@link),"_self");
		}
		private function whiteOutListener(e:MouseEvent):void
		{
			
			removeChild(whitebuttom);
			removeChild(underContainer);
			whitebuttom.removeEventListener(MouseEvent.ROLL_OUT,whiteOutListener);
		
		}
		private function get undercount():int
		{
			return xmlcon..menupunkter[elementNum].menupunkt.length();
		}
	}
}