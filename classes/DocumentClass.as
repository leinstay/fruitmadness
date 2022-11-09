package 
{
	import flash.display.MovieClip;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.events.MouseEvent;

	public class DocumentClass extends MovieClip
	{
		public const GAME_WIDTH:Number = 600;
		public const GAME_HEIGHT:Number = 450;
		
		public var game:GameLoop;
		public var startScreen:Menu;
		public var goToMenuButton:MenuButton;
		public var pauseButton:PauseButton;

		public function DocumentClass():void
		{
			startScreen = new Menu  ;
			startScreen.addEventListener(StartEvent.START,removeMenuGoToGame,false,0,true);
			addChild(startScreen);
			startScreen.x = GAME_WIDTH / 2;
			startScreen.y = GAME_HEIGHT / 2;

			stage.focus = stage;
		}

		public function removeMenuGoToGame(event:StartEvent):void
		{
			startScreen.removeMenu();
			removeChild(startScreen);
			startScreen = null;

			addEventListener(Event.ENTER_FRAME,gameFunction,false,0,true);
		}

		public function gameFunction(event:Event):void
		{
			removeEventListener(Event.ENTER_FRAME,gameFunction);

			game = new GameLoop  ;
			addChild(game);

			goToMenuButton = new MenuButton  ;
			addChild(goToMenuButton);
			goToMenuButton.x = GAME_WIDTH - (goToMenuButton.width/2) + 5;
			goToMenuButton.y = GAME_HEIGHT - (goToMenuButton.height/2) + 6;
			goToMenuButton.addEventListener(MouseEvent.CLICK,removeGameGoToMenu,false,0,true);

			pauseButton = new PauseButton  ;
			addChild(pauseButton);
			pauseButton.x = (pauseButton.width/2) - 3;
			pauseButton.y = GAME_HEIGHT - (pauseButton.height/2) + 6;
			pauseButton.addEventListener(MouseEvent.CLICK,pauseFunction,false,0,true);

			stage.focus = stage;
		}

		public function removeGameGoToMenu(event:MouseEvent):void
		{
			removeChild(goToMenuButton);
			goToMenuButton = null;

			game.removeGame();
			removeChild(game);
			game = null;

			addEventListener(Event.ENTER_FRAME,menuFunction,false,0,true);
		}

		public function menuFunction(event:Event):void
		{
			removeEventListener(Event.ENTER_FRAME,menuFunction);

			startScreen = new Menu  ;
			startScreen.addEventListener(StartEvent.START,removeMenuGoToGame,false,0,true);
			addChild(startScreen);
			startScreen.x = GAME_WIDTH / 2;
			startScreen.y = GAME_HEIGHT / 2;

			stage.focus = stage;
		}

		public function pauseFunction(event:Event):void
		{
			if (pauseButton.toggle)
			{
				pauseButton.toggle = false;
			}
			else
			{
				pauseButton.toggle = true;
			}
			
			if (pauseButton.toggle)
			{
				game.pauseOn();
				goToMenuButton.removeEventListener(MouseEvent.CLICK,removeGameGoToMenu);
			}
			else
			{
				game.pauseOff();
				goToMenuButton.addEventListener(MouseEvent.CLICK,removeGameGoToMenu,false,0,true);
			}
		}
	}
}