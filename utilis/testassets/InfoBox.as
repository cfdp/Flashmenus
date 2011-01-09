/**
* @Edit: Kristoffer Sall Hansen (Refunk.dk) 17-06-09
* @Description: Den tomme streng ('') er sat som default for _content og _headline
*/
package utilis.testassets
{
	// her importere jeg de forskillige klasser jeg har brug for at kunne skabe tekstboksen.
	import flash.display.GradientType;
	import flash.display.SpreadMethod;
	import flash.display.Sprite;
	import flash.geom.Matrix;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
/**
* Class for showing text in Cybermenu
 * 
 * @author Rene
 * tekstboksen består af 3 dele top, midt og bund. Bunden følger midten som kan variere i størrelse
 * alt efter hvor meget tekst der er, dog vil den altid have en minimum størrelse.
 * I tekstboksen kan man ændre farve,tekst og gennemsigthed via xmlfilen til Cybermenuen.
 * 
*/
	public class InfoBox extends Sprite
	{
		private var _topGfx:Sprite;// variablen der holder værdien for top objektet.
		private var _middelGfx:Sprite;// vaiablen der holder værdien for midt objektet.
		private var _buttomGfx:Sprite;// variablen der holder værdien for bund objektet
		private var _topText:TextField;
		private var _midText:TextField;
		private var _container:Sprite;// container variablen et et objekt som indeholder alle den andre objekter
		private var _textFormat:TextFormat;// denne variable holder den tekststil som bliver sat på teksten i boksen.
		private var _topColor:uint;// holder farve værdien til top grafikken.
		private var _containerXpos:Number;// værdien for placering af tekstboksen på x aksen.
		private var _containerYpos:Number;// variable der holder værdien til placering af tekstboken på y aksen.
		private var _alpha:Number;// denne variable holder gennemsigt værdien for tekstboksen.
		public var _headline:String;
		public var _content:String;
		private var _buttomColor:uint;
		public var _fontColor:uint;
		
		//constructor not in use
		public function InfoBox()
		{
		}
		// setter/getter funktioner gør det muligt at sætte de forskellige værdier uden for klassen.
		public function set fontColor(value:uint):void
		{
			_fontColor = value;
		}
		public function get fontColor():uint
		{
			return _fontColor;
		}
		public function set buttomColor(value:uint):void
		{
			_buttomColor = value;	
		}
		public function get buttomColor():uint
		{
			return _buttomColor;			
		}
		public function set topColor(value:uint):void
		{
			_topColor = value;	
		}
		public function get topColor():uint
		{
			return _topColor;			
		}
		public function set containerX (value:Number):void
		{
			_containerXpos = value;
		}
		public function get containerX ():Number
		{
			return _containerXpos;
		}
		public function set containerY (value:Number):void
		{
			_containerYpos = value;
		}
		public function get containerY ():Number
		{
			return _containerYpos;
		}
		public function set boxalpha(value:Number):void
		{
			_alpha = value;
		}
		public function get boxalpha ():Number
		{
			return _alpha;
		}
		public function get midtextHeight():Number
		{
			return _midText.height;
		}
		public function get topgfxHeight():Number
		{
			return _topGfx.height;
		}

		// denne funktion starter klassen samt de forskellige metoder.
		public function setupcontainer():void
		{
			if(_topGfx != null)
			{
				_container.removeChild(_topGfx);
				_container.removeChild(_middelGfx);
				_container.removeChild(_buttomGfx);
				_container.removeChild(_topText);
				_container.removeChild(_midText);
			}
			toptext();
			midtext();
			topgfx();
			middelgfx();
			buttomgfx();
			_container = new Sprite();
			containerPos();
			_container.addChild(_topGfx);
			_container.addChild(_middelGfx);
			_container.addChild(_buttomGfx);
			_container.addChildAt(_topText,1);
			_container.addChildAt(_midText,3);
			addChild(_container);
			
		}
		//funktion der laver top grafikken.
		private function topgfx():void
		{
			_topGfx = new Sprite();// her opretter den øverste grafik del.
			_topGfx.graphics.beginFill(_topColor,_alpha);// her tildele jeg den hvilken farve den skal have samt gennemsigtheden.
			_topGfx.graphics.drawRoundRectComplex(0,0,150,25,15,15,0,0);// her angiver jeg breden og hvor stor radius hjørnerne skal være
			_topGfx.graphics.endFill();// her slutter jeg objektet.

		}
		//funktion der laver bund grafikken.
		private function buttomgfx():void
		{
			_buttomGfx = new Sprite();
			_buttomGfx.graphics.beginFill(_buttomColor,_alpha);
			_buttomGfx.graphics.drawRoundRectComplex(0,setGfxButtomYpos(),150,25,0,0,15,15);
			_buttomGfx.graphics.endFill();

		}
		//funktion der laver midt grafikken.
		private function middelgfx():void
		{
			_middelGfx = new Sprite();
			var filltype:String = GradientType.LINEAR;
			var colors:Array = [topColor,buttomColor];
			var alphas:Array = [_alpha,_alpha];
			var ratios:Array = [100,255];
			var matr:Matrix = new Matrix();
			matr.createGradientBox(150,midgfxHeight(),Math.PI/2,0,0);
			var spreadMethod:String = SpreadMethod.PAD;
			_middelGfx.graphics.beginGradientFill(filltype,colors,alphas,ratios,matr,spreadMethod);
			_middelGfx.graphics.drawRoundRectComplex(0,25,150,midgfxHeight(),0,0,0,0);
			_middelGfx.graphics.endFill();

		}
		// funktion der laver teksten i toppen
		private function toptext():void
		{
			_topText = new TextField();
			_topText.defaultTextFormat = textformat(11);
			_topText.width = 144;
			_topText.height = 20;
			_topText.x = 5;
			_topText.y = 5;
			_topText.htmlText = (_headline !== null)?_headline:"";

		}
		// funktionen der laver midtteksten
		private function midtext ():void
		{
			_midText = new TextField();
			_midText.defaultTextFormat = textformat(9);
			_midText.htmlText = (_content !== null)?_content:"";
			_midText.width = 144;
			_midText.autoSize = TextFieldAutoSize.LEFT;
			_midText.wordWrap = true;
			_midText.multiline = true;
			_midText.y = 25;
			_midText.x = 5;
		}
		// funktion der sætter tekstformat på font.
		private function textformat(size:int):TextFormat
		{
			_textFormat = new TextFormat ();
			_textFormat.font = "Verdana";
			_textFormat.color = _fontColor;
			_textFormat.size = size;
			return _textFormat;
		}
		// funktion der placere tekstboksen.
		private function containerPos():void
		{
			_container.x = _containerXpos;
			_container.y = _containerYpos;
		}
		private function midgfxHeight():Number
		{
			if(midtextHeight<100)
			{
				return 60;
			}else{
				return midtextHeight;
			}
		}
		private function setGfxButtomYpos():Number
		{
			if(midtextHeight+topgfxHeight<100)
			{
				return 60+topgfxHeight;
			}else{
				return midtextHeight+topgfxHeight;
			}
		}

		
	}
}