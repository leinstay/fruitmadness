package 
{
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;

	public class Player extends MovieClip
	{
		private var downKeyIsBeingPressed:Boolean;
		private var upKeyIsBeingPressed:Boolean;
		private var leftKeyIsBeingPressed:Boolean;
		private var rightKeyIsBeingPressed:Boolean;

		private var speed:Number;
		private var velocityX:Number;
		private var velocityY:Number;
		public var maxSpeed:Number;
		public var friction:Number;

		public function Player():void
		{
			downKeyIsBeingPressed = false;
			upKeyIsBeingPressed = false;
			leftKeyIsBeingPressed = false;
			rightKeyIsBeingPressed = false;

			velocityX = 0;
			velocityY = 0;
			speed = .5;
			maxSpeed = 6;
			friction = .93;

			addEventListener(Event.ENTER_FRAME, playerMovement, false, 0, true);
			addEventListener(Event.ADDED_TO_STAGE, addKeyListeners, false, 0, true);
		}

		public function addKeyListeners(event:Event):void
		{
			stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyPress, false, 0, true);
			stage.addEventListener(KeyboardEvent.KEY_UP, onKeyRelease, false, 0, true);
		}

		public function onKeyPress(event:KeyboardEvent):void
		{
			if (event.keyCode == Keyboard.DOWN || event.keyCode == 83)
			{
				downKeyIsBeingPressed = true;
			}
			if (event.keyCode == Keyboard.UP || event.keyCode == 87)
			{
				upKeyIsBeingPressed = true;
			}
			if (event.keyCode == Keyboard.LEFT || event.keyCode == 65)
			{
				leftKeyIsBeingPressed = true;
			}
			if (event.keyCode == Keyboard.RIGHT || event.keyCode == 68)
			{
				rightKeyIsBeingPressed = true;
			}
		}

		public function onKeyRelease(event:KeyboardEvent):void
		{
			if (event.keyCode == Keyboard.DOWN || event.keyCode == 83)
			{
				downKeyIsBeingPressed = false;
			}
			if (event.keyCode == Keyboard.UP || event.keyCode ==  87)
			{
				upKeyIsBeingPressed = false;
			}
			if (event.keyCode == Keyboard.LEFT || event.keyCode == 65)
			{
				leftKeyIsBeingPressed = false;
			}
			if (event.keyCode == Keyboard.RIGHT || event.keyCode == 68)
			{
				rightKeyIsBeingPressed = false;
			}
		}

		public function playerMovement(event:Event):void
		{
			if (leftKeyIsBeingPressed)
			{
				velocityX -=  speed;
			}
			else if (rightKeyIsBeingPressed)
			{
				velocityX +=  speed;
			}
			else
			{
				velocityX *=  friction;

			}
			if (upKeyIsBeingPressed)
			{
				velocityY -=  speed;
			}
			else if (downKeyIsBeingPressed)
			{
				velocityY +=  speed;
			}
			else
			{
				velocityY *=  friction;

			}

			x +=  velocityX;
			y +=  velocityY;
			rotation = velocityX;

			if (velocityX > maxSpeed)
			{
				velocityX = maxSpeed;
			}
			else if (velocityX < -maxSpeed)
			{
				velocityX =  -  maxSpeed;

			}
			if (velocityY > maxSpeed)
			{
				velocityY = maxSpeed;
			}
			else if (velocityY < -maxSpeed)
			{
				velocityY =  -  maxSpeed;
			}
		}
	}
}