package utilis.testassets.balls
{
	import flash.display.Sprite;

	public class Dot extends Sprite
	{
		public var ball:Sprite;
		
		public function Dot(x:Number,y:Number,r:Number,c:uint)
		{
			drawBall(x,y,r,c)
			
		}
		private function drawBall(xpos:Number,ypos:Number,radius:Number,color:uint):void
		{
			ball = new Sprite();
			ball.graphics.beginFill(color,1);
			ball.graphics.drawCircle(xpos,ypos,radius);
			ball.graphics.endFill();
			this.buttonMode = true;

			addChild(ball);
		}

	}
}