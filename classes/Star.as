package 
{
	import flash.display.MovieClip;
	import flash.events.Event;

	public class Star extends MovieClip
	{
		private var speed:Number;

		public function Star():void
		{

			setupStar(true);

			addEventListener(Event.ENTER_FRAME, loop, false, 0, true);
		}

		public function setupStar(randomizeX:Boolean = false):void
		{
			x = randomizeX ? Math.random() * 600:600;
			y = Math.random() * 450;
			alpha = Math.random();
			speed = 2 + Math.random() * 2;
		}

		public function loop(event:Event):void
		{
			x -=  speed;

			if (x <= 0)
			{
				setupStar();
			}
		}
	}
}