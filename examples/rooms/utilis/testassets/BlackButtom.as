package utilis.testassets
{
	import flash.display.Sprite;

	public class BlackButtom extends Sprite
	{
		private var whitebox:Sprite;
		public function BlackButtom()
		{
			whitebox = new Sprite();
			whitebox.graphics.lineStyle(10,0x000000,0);
			whitebox.graphics.beginFill(0x000000,1);
			whitebox.graphics.drawRect(0,0,70,245);
			
			addChild(whitebox);
		}
		
	}
}