package 
{
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.events.TimerEvent;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;

	public class Menu extends MovieClip
	{
		public var startButton:StartButton;

		public function Menu()
		{
			startButton = new StartButton();
			addChild(startButton);
			startButton.y = 60;

			startButton.addEventListener(MouseEvent.CLICK, startGameWithMouse, false, 0, true);
		}

		public function startGameWithMouse(event:MouseEvent):void
		{
			dispatchEvent(new StartEvent(StartEvent.START));
		}
		
		public function removeMenu():void
		{
			startButton.removeEventListener(MouseEvent.CLICK, startGameWithMouse);
			removeChild(startButton);
			startButton = null;
		}
	}
}