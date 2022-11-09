package 
{
	import flash.display.MovieClip;
	
	public class Enemies extends MovieClip
	{
		private var speed:Number;

		public function Enemies(speedForEnemies:Number):void
		{
			speed = speedForEnemies;
		}
		
		public function moveEnemiesHorizontal():void
		{
			x -= speed;
		}
		
		public function moveEnemiesVertical():void
		{
			y -= speed;
		}
		
		public function moveEnemiesInMajorDiagonal():void
		{
			x -= speed;
			y -= (2/3 * speed);
		}
		
		public function moveEnemiesInMinorDiagonal():void
		{
			x -= speed;
			y += (2/3 * speed);
		}
	}
}