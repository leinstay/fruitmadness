package 
{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.TimerEvent;

	public class Explosion extends MovieClip
	{

		private const PARTICLE_MULT = 600;
		private const PARTICLE_MAX_SIZE = 3;
		private const PARTICLE_SPEED = 12;

		public function explosionFunction(x:Number, y:Number):void
		{
			var particle_qty:Number = Math.random() * (PARTICLE_MULT / 2) + (PARTICLE_MULT / 2);
			for (var i:Number = 0; i < particle_qty; i++)
			{
				var pSize:Number = Math.random() * (PARTICLE_MAX_SIZE - 1) + 1;
				var pAlpha:Number = Math.random();

				var p:Sprite = new Sprite();
				p.graphics.beginFill(0xFFFFFF);
				p.graphics.drawCircle(0,0,pSize);

				var particle:MovieClip = new MovieClip();
				particle.addChild(p);
				particle.x = x;
				particle.y = y;
				particle.alpha = pAlpha;

				var pFast:int = Math.round(Math.random() * 0.75);
				particle.pathX = (Math.random() * PARTICLE_SPEED - PARTICLE_SPEED/2) + 
				pFast * (Math.random() * 10 - 5);
				particle.pathY = (Math.random() * PARTICLE_SPEED - PARTICLE_SPEED/2) + 
				pFast * (Math.random() * 10 - 5);

				particle.addEventListener(Event.ENTER_FRAME, particlePath, false, 0, true);
				addChild(particle);
			}
		}

		public function particlePath(e:Event):void
		{
			e.target.x +=  e.target.pathX;
			e.target.y +=  e.target.pathY;
			e.target.alpha -=  0.005;

			if (e.target.alpha <= 0)
			{
				e.target.removeEventListener('enterFrame', particlePath);
				e.target.parent.removeChild(e.target);
			}
		}
	}

}