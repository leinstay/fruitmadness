package 
{
	import flash.display.MovieClip;

	public class Sugar extends MovieClip
	{
		private var speed:Number;
		public var startCorner:int;

		public function Sugar(speedForSugar:Number, numForStartCorner:int):void
		{
			startCorner = numForStartCorner;
			speed = speedForSugar;
		}
		
		public function moveSugarHorizontal():void
		{
			x -= speed;
		}
		
		public function moveSugarVertical():void
		{
			y -= speed;
		}
		
		public function moveSugarInMajorDiagonal():void
		{
			x -= speed;
			y -= (2/3 * speed);
		}
		
		public function moveSugarInMinorDiagonal():void
		{
			x -= speed;
			y += (2/3 * speed);
		}
	}
}