package 
{
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.media.SoundChannel;
	import flash.utils.Timer;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.events.MouseEvent;

	/****************************/
	/**@Niruin&Fenion,2013-2014**/
	/****************************/
	
	/*
	 * Основной класс нашего первого совместного проекта и по совместительству первая программа, 
	 * превосходящая по размерам мой унылый калькулятор на Java. Писался он с периодическими разрывами, 
	 * из чего и следует то, что со стороны он похож на страшный сон программиста, с кучей заплаток и различных глупостей.
	 */

	public class GameLoop extends MovieClip
	{
		/*---------------------Блок переменных------------------*/

		/*
		 * | доступ(private,protected,public) | изменяемость(var,const) | название | тип(число,строка,экземпляр класса) | значение |
		 */
		
		public const GAME_WIDTH:Number = 600; // ширина игрового поля
		public const GAME_HEIGHT:Number = 450; // высота игрового поля
		public const NUMBER_OF_STARS:int = 60; // максимальное количество звезд на игровом экране

		private var sugarArray:Array; // волшебный сахарок, массив для различных вкусностей в виде топлива, а в будущем бонусов.
		private var enemyArray:Array; // фрукты, фрукты никогда не меняются, они так и хотят лишить вас возможности насладиться вкуснейшим сахаром.

		private var bgmSoundChannel:SoundChannel; // звуковой канал, для фоновой музыки.
		private var sfxSoundChannel:SoundChannel; // БУМ! БАМ! КАБЛАМ! Звуковой канал для различных эффектов.

		private var backgroundMusic:MainTheme; // основная музыкальная тема, найденная в кейгене для нашего AFCS6.
		private var gameOverMusic:GameOverTheme; // YOU GET PWNED! Геймовер мьюзик, взят из ROM'а старенькой NES-игры Gun-Nac.
		private var explodeSound:Boom; // звук взрыва, записан наживо (+1000 к эпичности проекта).
		
		private var background:Background;
		private var player:Player; // это ты, да да, именно ты.
		private var pilot:PilotPanda; // а вот это уже та милая панда, которую ты видишь перед собой.
		
		private var dangerHz:DangerHz; // вот эта штука => ::::DANGER::::
		private var dangerVt:DangerVt; // те же яйца, только в профиль.
		private var dangerDiag:DangerDiag; // те же яйца, только хуже.
		
		private var comboBar:ComboBar; // в разработке..., элемент UI
		private var fuelBar:FuelBar; // топливный бак, элемент UI
		private var fuelCount:FuelCount; // количество топлива, элемент UI
		private var scoreBar:ScoreBar; // олдскульный счет, элемент UI
		
		/*
		 * Стоит отметить что счетчики, приведенные ниже, хранят в себе количество кадров, с момента своего последнего обнуления.   
		 */

		private var timerForSugar:int; // счетчик для бонусов (таймер без таймера (wat?)).
		private var timerForEnemies:int; // тоже, для врагов.

		private var timeForSugarToAppear:int; // граница, для счетчика таймера без таймера; измеряется в секундах (значение 1 <=> 1 секунде реального времени)
		private var timeForEnemiesToAppear:int; // тоже, для врагов.
		
		private var timeForGameModeToChange:int; // время на один режим, после запускается пауза между режимами. 
		private var timeToWaitUntilGameModeChange:int; // пауза между режимами, необходимая для того, чтобы воины фруктовой империи собрались с силами для новой атаки.
		
		private var lineForSugar:int; // (1-5) линия, по которой будет двигаться бонус.
		private var lineForEnemies:int; // (1-5) линия, по которой будет двигаться враг.
		private var numOfSugar:int; // (1-5) количество бонусов выбрасываемых в данной волне.
		private var numOfEnemies:int; // (1-5) количество врагов выбрасываемых в данной волне.

		private var standartFont:PixelFont; // основной внутриигровой шрифт.
		private var textFormat:TextFormat; // форматирование выводимого текста.
		private var overallScore:TextField; // текстовое поле для игрового счета.
		private var gameOverScore:TextField; // текстовое поле для финального счета.

		private var overallScoreNumber:int; // числовое значение игрового счета.
		private var gameOverScoreNumber:int; // числовое значение финального счета.

		private var fuel:Number; // значение топлива в данный момент времени.
		private var fuelUp:Number; // значение увеличивающее топливо.
		private var fuelDown:Number; // значение уменьшающее топливо.

		private var amount:int; // стандартный счетчик для всех циклов (чуть солидней, чем просто i).
		private var speedForSugar:Number; // скорость бонусов.
		private var speedForEnemies:Number; // скорость врагов.
		private var difficulty:Number; // увеличивает скорость с течением времени.
		
		private var gameMode:int; // № игрового режима.
		private var oldGameMode:int; // № прошлого игрового режима.
		
		private var gameModeChanged:Boolean; // bool определяющий изменен ли игровой режим или остался прежним.
		private var gameModeTimerEnd:Boolean; // bool определяющий время ли входить в стадию паузы между сменой режимов или нет.
		private var gameOverState:Boolean; // bool определяющий мертвы вы или живы; если здесь false, значит пока что все идет хорошо.

		private var bgmTimer:Timer; // Единоразово запускает фоновую музыку
		private var gameModeTimer:Timer; // ЗАМЕНИТЬ ТАЙМЕРОМ БЕЗ ТАЙМЕРА
		private var waitTimer:Timer; // ЗАМЕНИТЬ ТАЙМЕРОМ БЕЗ ТАЙМЕРА

		/*---------------------Конструктор---------------------------------------------------*/

		public function GameLoop():void
		{
			gameInit();
			
			/*
			 * Дополнительная функция gameInit создана на тот случай, если появится необходимость 
			 * инициировать что-либо до начала главного процесса, либо после его окончания. 
			 */
		}

		public function gameInit():void
		{
		/*---------------------Начальные значения всех переменных----------------------*/
			
			/*
			 * Первичное обнуление счетчиков для таймеров.
			 */
			
			timerForSugar = 0;
			timerForEnemies = 0;

			/*
			 * 15 секунд на каждый игровой режим, с паузой в 5 секунд между ними.
			 */
			
			timeForGameModeToChange = 15000;
			timeToWaitUntilGameModeChange = 5000;
			
			/*
			 * Каждую 1 секунду, появляеться враг и бонус.
			 */
			
			timeForSugarToAppear = 1;
			timeForEnemiesToAppear = 1;
			
			/*
			 * Начальный, конечный счет, и сложность на старте игры равны 0.
			 */

			overallScoreNumber = 0;
			gameOverScoreNumber = 0;
			difficulty = .2;
			
			/*
			 * Общая вместимость бака, расход на один кадр, объем пополненого топлива за один маффин.
			 */

			fuel = 100;
			fuelUp = 10;
			fuelDown = .05;

			/*
			 * Первый режим является стартовым. 
			 */
			
			gameMode = 1;
			oldGameMode = 1;
			
			/*
			 * Первая волна всегда пустая. 
			 */
			
			numOfSugar = 0;
			numOfEnemies = 0;
			
			/*
			 * Игра и первый режим не закончены на старте, первый режим ничем не изменен. 
			 */

			gameOverState = false;
			gameModeChanged = false;
			gameModeTimerEnd = false;
			
		/*---------------------Экземпляры классов----------------------*/

			background = new Background();
			player = new Player();
			pilot = new PilotPanda(player.x,player.y - 1);
			
			addChild(background);
			addChild(player);
			addChild(pilot);
			
			player.x = GAME_WIDTH / 5;
			player.y = GAME_HEIGHT / 2;
			
			for (amount = 0; amount < NUMBER_OF_STARS; amount++)
			{
				addChildAt(new Star(),1);
			}

			sugarArray = new Array;
			enemyArray = new Array;

			dangerHz = new DangerHz;
			dangerVt = new DangerVt;
			dangerDiag = new DangerDiag;

			standartFont = new PixelFont;
			comboBar = new ComboBar;
			fuelBar = new FuelBar;
			fuelCount = new FuelCount;
			scoreBar = new ScoreBar;
			overallScore = new TextField;
			gameOverScore = new TextField;
			
		/*---------------------Таймеры и слушатели----------------------*/
		
			addEventListener(Event.ENTER_FRAME,mainFunction,false,0,true);

			bgmTimer = new Timer(0,1);
			bgmTimer.addEventListener(TimerEvent.TIMER,bgmStart,false,0,true);
			bgmTimer.start();

			waitTimer = new Timer(timeToWaitUntilGameModeChange);
			waitTimer.addEventListener(TimerEvent.TIMER,gameModeWait,false,0,true);

			gameModeTimer = new Timer(timeForGameModeToChange);
			gameModeTimer.addEventListener(TimerEvent.TIMER,gameChange,false,0,true);
			gameModeTimer.start();
		}

		/*---------------------Главная функция----------------------------------------------*/

		public function mainFunction(event:Event):void
		{
			borders();
			HUD();
			actions();
		}

		/*---------------------Рандомизация-------------------------------------------------*/

		public function randomRange(minNum:int,maxNum:int):int
		{
			return Math.floor(Math.random() * ((maxNum - minNum) + 1)) + minNum;
		}

		/*---------------------Границы------------------------------------------------------*/

		public function borders():void
		{
			if (pilot.x != player.x)
			{
				pilot.x = player.x;
			}
			if (pilot.y != player.y)
			{
				pilot.y = player.y;
			}
			if (player.x < player.width / 2)
			{
				player.x = player.width / 2;
				pilot.x = player.x;
			}
			if (player.x > GAME_WIDTH - player.width / 2)
			{
				player.x = GAME_WIDTH - player.width / 2;
				pilot.x = player.x;
			}
			if (player.y < player.height / 2)
			{
				player.y = player.height / 2;
				pilot.y = player.y;
			}
			if (player.y > GAME_HEIGHT - player.height / 2)
			{
				player.y = GAME_HEIGHT - player.height / 2;
				pilot.y = player.y;
			}
		}

		/*---------------------Фоновая музыка-----------------------------------------------*/

		public function bgmStart(event:TimerEvent):void
		{
			backgroundMusic = new MainTheme  ;
			bgmSoundChannel = backgroundMusic.play();
			bgmSoundChannel.addEventListener(Event.SOUND_COMPLETE,bgmFinish,false,0,true);
		}

		public function bgmFinish(event:Event):void
		{
			bgmSoundChannel = backgroundMusic.play();
			bgmSoundChannel.addEventListener(Event.SOUND_COMPLETE,bgmFinish,false,0,true);
		}

		public function sfxFinish(event:Event):void
		{
			gameOverMusic = new GameOverTheme  ;
			bgmSoundChannel = gameOverMusic.play(0,1);
		}

		/*---------------------Ожидание смены игрового режима и сложность-------------------*/

		public function gameChange(timerEvent:TimerEvent):void
		{
			oldGameMode = gameMode;
			gameMode = randomRange(1,8);
			difficulty += .05;

			if ((oldGameMode == gameMode))
			{
				gameModeChanged = false;
			}
			else
			{
				waitTimer.start();
				gameModeTimer.stop();
				gameModeChanged = true;

				switch (gameMode)
				{
					case 1 :
						addChild(dangerVt);
						dangerVt.x = GAME_WIDTH - dangerVt.width - 10;
						dangerVt.y = GAME_HEIGHT / 2;
						break;
					case 2 :
						addChild(dangerVt);
						dangerVt.x = dangerVt.width + 10;
						dangerVt.y = GAME_HEIGHT / 2;
						break;
					case 3 :
						addChild(dangerHz);
						dangerHz.x = GAME_WIDTH / 2;
						dangerHz.y = dangerHz.height + 35;
						break;
					case 4 :
						addChild(dangerHz);
						dangerHz.x = GAME_WIDTH / 2;
						dangerHz.y = GAME_HEIGHT - dangerHz.height - 20;
						break;
					case 5 :
						addChild(dangerDiag);
						dangerDiag.x = 100;
						dangerDiag.y = 100;
						break;
					case 6 :
						addChild(dangerDiag);
						dangerDiag.x = GAME_WIDTH - 100;
						dangerDiag.y = GAME_HEIGHT - 100;
						break;
					case 7 :
						addChild(dangerDiag);
						dangerDiag.x = GAME_WIDTH - 100;
						dangerDiag.y = 100;
						break;
					case 8 :
						addChild(dangerDiag);
						dangerDiag.x = 100;
						dangerDiag.y = GAME_HEIGHT - 100;
						break;
				}
			}
		}

		/*---------------------Смена игрового режима----------------------------------------*/

		public function gameModeWait(timerEvent:TimerEvent):void
		{
			gameModeTimer.start();
			waitTimer.stop();
			gameModeTimerEnd = true;

			if (contains(dangerHz))
			{
				removeChild(dangerHz);
			}
			if (contains(dangerVt))
			{
				removeChild(dangerVt);
			}
			if (contains(dangerDiag))
			{
				removeChild(dangerDiag);
			}
		}
		
		/*---------------------Счет и топливо игрока----------------------------------------*/

		public function HUD():void
		{
			addChild(fuelCount);
			addChild(fuelBar);
			addChild(comboBar);
			addChild(scoreBar);
			addChild(overallScore);

			textFormat = new TextFormat(standartFont.fontName,20,0xFFFFFF);
			overallScore.defaultTextFormat = textFormat;
			overallScore.embedFonts = true;
			overallScore.autoSize = "left";
			overallScore.x = (GAME_WIDTH/2) - (overallScore.width/2) + 1;
			overallScore.y = overallScore.height - 2;
			overallScore.text = ('0000000'.slice(0,-overallScoreNumber.toString().length) + overallScoreNumber.toString());

			fuelBar.y = fuelCount.y = comboBar.y = scoreBar.y = 32;
			fuelBar.x = 57;
			fuelCount.x = 6 + (fuelBar.width/2);
			scoreBar.x = GAME_WIDTH / 2;
			comboBar.x = 543;

			if (gameOverState == false)
			{
				overallScoreNumber +=  1;
				fuel -=  fuelDown;
				
				if (fuel / 100 < 0)
				{
					fuel = 0;
					fuelCount.scaleX = 0;
				}
				else if (fuel / 100 > 1)
				{
					fuel = 100;
					fuelCount.scaleX = 1;
				}
				else
				{
					fuelCount.scaleX = fuel / 100;
				}

				if (fuel <= 0)
				{
					player.maxSpeed = .5;
					player.friction = .99;
				}
				if (fuel > 0)
				{
					player.maxSpeed = 6;
					player.friction = .93;
				}
			}
			else
			{
				removeChild(overallScore);
				removeChild(fuelBar);
				removeChild(comboBar);
				removeChild(scoreBar);
				removeChild(fuelCount);
			}
		}

		/*---------------------Интерактив---------------------------------------------------*/

		public function actions():void
		{
			
		/*---------------------Генератор бонусов и их основные действия---------------------*/

			if (++timerForSugar % (100 * timeForSugarToAppear) == 0)
			{
				numOfSugar = randomRange(0,2);
				for (amount = 1; amount < numOfSugar; amount++)
				{
					speedForSugar = -randomRange(3,4);
					sugar = new Sugar(speedForSugar,1);
					sugarArray.push(sugar);
					addChild(sugar);
					lineForSugar = randomRange(1,5);
					switch (lineForSugar)
					{
						case 1 :
							sugar.x = 1/2 * GAME_WIDTH;
							sugar.y = -sugar.height;
							break;
						case 2 :
							sugar.x = 1/4 * GAME_WIDTH;
							sugar.y = -sugar.height;
							break;
						case 3 :
							sugar.x = -sugar.width;
							sugar.y = -sugar.height;
							break;
						case 4 :
							sugar.x = -sugar.width;
							sugar.y = 1/4 * GAME_HEIGHT;
							break;
						case 5 :
							sugar.x = -sugar.width;
							sugar.y = 1/2 * GAME_HEIGHT;
							break;
					}
					
				}
				
				numOfSugar = randomRange(0,2);
				for (amount = 1; amount < numOfSugar; amount++)
				{
					speedForSugar = randomRange(3,4);
					sugar = new Sugar(speedForSugar,2);
					sugarArray.push(sugar);
					addChild(sugar);
					lineForSugar = randomRange(1,5);
					switch (lineForSugar)
					{
						case 1 :
							sugar.x = 1/2 * GAME_WIDTH;
							sugar.y = GAME_HEIGHT + sugar.height;
							break;
						case 2 :
							sugar.x = 3/4 * GAME_WIDTH;
							sugar.y = GAME_HEIGHT + sugar.height;
							break;
						case 3 :
							sugar.x = GAME_WIDTH + sugar.width;
							sugar.y = GAME_HEIGHT + sugar.height;
							break;
						case 4 :
							sugar.x = GAME_WIDTH + sugar.width;
							sugar.y = 3/4 * GAME_HEIGHT;
							break;
						case 5 :
							sugar.x = GAME_WIDTH + sugar.width;
							sugar.y = 1/2 * GAME_HEIGHT;
							break;
					}
				}
				
				numOfSugar = randomRange(0,2);
				for (amount = 1; amount < numOfSugar; amount++)
				{
					speedForSugar = randomRange(3,4);
					sugar = new Sugar(speedForSugar,3);
					sugarArray.push(sugar);
					addChild(sugar);
					lineForSugar = randomRange(1,5);
					switch (lineForSugar)
					{
						case 1 :
							sugar.x = 1/2 * GAME_WIDTH;
							sugar.y = -sugar.height;
							break;
						case 2 :
							sugar.x = 3/4 * GAME_WIDTH;
							sugar.y = -sugar.height;
							break;
						case 3 :
							sugar.x = GAME_WIDTH + sugar.width;
							sugar.y = -sugar.height;
							break;
						case 4 :
							sugar.x = GAME_WIDTH + sugar.width;
							sugar.y = 1/4 * GAME_HEIGHT;
							break;
						case 5 :
							sugar.x = GAME_WIDTH + sugar.width;
							sugar.y = 1/2 * GAME_HEIGHT;
							break;
					}
				}
				
				numOfSugar = randomRange(0,2);
				for (amount = 1; amount < numOfSugar; amount++)
				{
					speedForSugar = -randomRange(3,4);
					sugar = new Sugar(speedForSugar,4);
					sugarArray.push(sugar);
					addChild(sugar);
					lineForSugar = randomRange(1,5);
					switch (lineForSugar)
					{
						case 1 :
							sugar.x = 1/2 * GAME_WIDTH;
							sugar.y = GAME_HEIGHT + sugar.height;
							break;
						case 2 :
							sugar.x = 1/4 * GAME_WIDTH;
							sugar.y = GAME_HEIGHT + sugar.height;
							break;
						case 3 :
							sugar.x = -sugar.width;
							sugar.y = GAME_HEIGHT + sugar.height;
							break;
						case 4 :
							sugar.x = -sugar.width;
							sugar.y = 3/4 * GAME_HEIGHT;
							break;
						case 5 :
							sugar.x = -sugar.width;
							sugar.y = 1/2 * GAME_HEIGHT;
							break;
					}
				}
				
				timerForSugar = 0;
			}

			for each (var sugar:Sugar in sugarArray)
			{
				switch (sugar.startCorner)
				{
					case 1 :
					case 2 :
						sugar.moveSugarInMajorDiagonal()
						break;
					case 3 :
					case 4 :
						sugar.moveSugarInMinorDiagonal()
						break;
				}
				
				if (sugar.x < -sugar.width)
				{
					if (contains(sugar))
					{
						removeChild(sugar);
					}
				}
				if ((gameOverState == false))
				{
					if (PPCDetection.isColliding(player,sugar,this,true))
					{
						if (contains(sugar))
						{
							removeChild(sugar);
							fuel += fuelUp;
						}
					}
				}
			}

		/*---------------------Генератор врагов и их основные действия---------------------*/

			if (++timerForEnemies % (60 * timeForEnemiesToAppear) == 0)
			{
				if ((gameModeChanged == false))
				{
					if (gameMode == 1)
					{
						speedForEnemies = 7 + difficulty;
						numOfEnemies = randomRange(2,4);
						for (amount = 1; amount <= numOfEnemies; amount++)
						{
							enemy = new Enemies(speedForEnemies);
							enemyArray.push(enemy);
							addChild(enemy);
							lineForEnemies = randomRange(1,5);
							enemy.x = (GAME_WIDTH + enemy.width);
							enemy.y = (((lineForEnemies * (GAME_HEIGHT / 5)) + ((lineForEnemies - 1) * (GAME_HEIGHT / 5))) / 2);
						}
					}
					else if (gameMode == 2)
					{
						speedForEnemies = -7 - difficulty;
						numOfEnemies = randomRange(2,4);
						for (amount = 1; amount <= numOfEnemies; amount++)
						{
							enemy = new Enemies(speedForEnemies);
							enemyArray.push(enemy);
							addChild(enemy);
							lineForEnemies = randomRange(1,5);
							enemy.x =  -enemy.width;
							enemy.y = (((lineForEnemies * (GAME_HEIGHT / 5)) + ((lineForEnemies - 1) * (GAME_HEIGHT / 5))) / 2);
						}
					}
					else if (gameMode == 3)
					{
						speedForEnemies = -5 - difficulty;
						numOfEnemies = randomRange(2,4);
						for (amount = 1; amount <= numOfEnemies; amount++)
						{
							enemy = new Enemies(speedForEnemies);
							enemyArray.push(enemy);
							addChild(enemy);
							lineForEnemies = randomRange(1,5);
							enemy.x = (((lineForEnemies * (GAME_WIDTH / 5)) + ((lineForEnemies - 1) * (GAME_WIDTH / 5))) / 2);
							enemy.y =  -enemy.height;
						}
					}
					else if (gameMode == 4)
					{
						speedForEnemies = 5 + difficulty;
						numOfEnemies = randomRange(2,4);
						for (amount = 1; amount <= numOfEnemies; amount++)
						{
							enemy = new Enemies(speedForEnemies);
							enemyArray.push(enemy);
							addChild(enemy);
							lineForEnemies = randomRange(1,5);
							enemy.x = (((lineForEnemies * (GAME_WIDTH / 5)) + ((lineForEnemies - 1) * (GAME_WIDTH / 5))) / 2);
							enemy.y = (GAME_HEIGHT + enemy.height);
						}
					}
					else if (gameMode == 5)
					{
						speedForEnemies = -4 - difficulty;
						numOfEnemies = randomRange(2,4);
						for (amount = 1; amount <= numOfEnemies; amount++)
						{
							enemy = new Enemies(speedForEnemies);
							enemyArray.push(enemy);
							addChild(enemy);
							lineForEnemies = randomRange(1,5);
							switch (lineForEnemies)
							{
								case 1 :
									enemy.x = 3/4 * GAME_WIDTH;
									enemy.y = -enemy.height;
									break;
								case 2 :
									enemy.x = 1/4 * GAME_WIDTH;
									enemy.y = -enemy.height;
									break;
								case 3 :
									enemy.x = -enemy.width;
									enemy.y = -enemy.height;
									break;
								case 4 :
									enemy.x = -enemy.width;
									enemy.y = 1/4 * GAME_HEIGHT;
									break;
								case 5 :
									enemy.x = -enemy.width;
									enemy.y = 3/4 * GAME_HEIGHT;
									break;
							}
						}
					}
					else if (gameMode == 6)
					{
						speedForEnemies = 4 + difficulty;
						numOfEnemies = randomRange(2,4);
						for (amount = 1; amount <= numOfEnemies; amount++)
						{
							enemy = new Enemies(speedForEnemies);
							enemyArray.push(enemy);
							addChild(enemy);
							lineForEnemies = randomRange(1,5);
							switch (lineForEnemies)
							{
								case 1 :
									enemy.x = 1/4 * GAME_WIDTH;
									enemy.y = GAME_HEIGHT + enemy.height;
									break;
								case 2 :
									enemy.x = 3/4 * GAME_WIDTH;
									enemy.y = GAME_HEIGHT + enemy.height;
									break;
								case 3 :
									enemy.x = GAME_WIDTH + enemy.width;
									enemy.y = GAME_HEIGHT + enemy.height;
									break;
								case 4 :
									enemy.x = GAME_WIDTH + enemy.width;
									enemy.y = 3/4 * GAME_HEIGHT;
									break;
								case 5 :
									enemy.x = GAME_WIDTH + enemy.width;
									enemy.y = 1/4 * GAME_HEIGHT;
									break;
							}
						}
					}
					else if (gameMode == 7)
					{
						speedForEnemies = 4 + difficulty;
						numOfEnemies = randomRange(2,4);
						for (amount = 1; amount <= numOfEnemies; amount++)
						{
							enemy = new Enemies(speedForEnemies);
							enemyArray.push(enemy);
							addChild(enemy);
							lineForEnemies = randomRange(1,5);
							switch (lineForEnemies)
							{
								case 1 :
									enemy.x = 1/4 * GAME_WIDTH;
									enemy.y = -enemy.height;
									break;
								case 2 :
									enemy.x = 3/4 * GAME_WIDTH;
									enemy.y = -enemy.height;
									break;
								case 3 :
									enemy.x = GAME_WIDTH + enemy.width;
									enemy.y = -enemy.height;
									break;
								case 4 :
									enemy.x = GAME_WIDTH + enemy.width;
									enemy.y = 1/4 * GAME_HEIGHT;
									break;
								case 5 :
									enemy.x = GAME_WIDTH + enemy.width;
									enemy.y = 3/4 * GAME_HEIGHT;
									break;
							}
						}
					}
					else if (gameMode == 8)
					{
						speedForEnemies = -4 - difficulty;
						numOfEnemies = randomRange(2,4);
						for (amount = 1; amount <= numOfEnemies; amount++)
						{
							enemy = new Enemies(speedForEnemies);
							enemyArray.push(enemy);
							addChild(enemy);
							lineForEnemies = randomRange(1,5);
							switch (lineForEnemies)
							{
								case 1 :
									enemy.x = 3/4 * GAME_WIDTH;
									enemy.y = GAME_HEIGHT + enemy.height;
									break;
								case 2 :
									enemy.x = 1/4 * GAME_WIDTH;
									enemy.y = GAME_HEIGHT + enemy.height;
									break;
								case 3 :
									enemy.x = -enemy.width;
									enemy.y = GAME_HEIGHT + enemy.height;
									break;
								case 4 :
									enemy.x = -enemy.width;
									enemy.y = 3/4 * GAME_HEIGHT;
									break;
								case 5 :
									enemy.x = -enemy.width;
									enemy.y = 1/4 * GAME_HEIGHT;
									break;
							}
						}
					}
				}
				timerForEnemies = 0;
			}

			for each (var enemy:Enemies in enemyArray)
			{
				if (gameModeChanged == false)
				{
						switch (gameMode)
						{
							case 1 :
							case 2 :
								enemy.moveEnemiesHorizontal();
								break;
							case 3 :
							case 4 :
								enemy.moveEnemiesVertical();
								break;
							case 5 :
							case 6 :
								enemy.moveEnemiesInMajorDiagonal();
								break;
							case 7 :
							case 8 :
								enemy.moveEnemiesInMinorDiagonal();
								break;
							}
						}
				else
				{
					if (gameModeTimerEnd)
					{
						gameModeChanged = false;
						gameModeTimerEnd = false;
					}
					else
					{
						switch (oldGameMode)
						{
							case 1 :
							case 2 :
								enemy.moveEnemiesHorizontal();
								break;
							case 3 :
							case 4 :
								enemy.moveEnemiesVertical();
								break;
							case 5 :
							case 6 :
								enemy.moveEnemiesInMajorDiagonal();
								break;
							case 7 :
							case 8 :
								enemy.moveEnemiesInMinorDiagonal();
								break;
						}
					}
				}

				if (PPCDetection.isColliding(player,enemy,this,true))
				{
					if (contains((player && pilot)))
					{
						gameOver();
					}
				}
				
				if (enemy.x <= -enemy.width * 2 || enemy.x >= (GAME_WIDTH + enemy.width * 2) || enemy.y <= -enemy.height * 2 || enemy.y >= (GAME_HEIGHT + enemy.height * 2))
				{
					if (contains(enemy))
					{
						removeChild(enemy);
					}
				}
			}
		}

		/*---------------------Конец игры---------------------------------------------------*/

		public function gameOver():void
		{
			gameOverState = true;

			bgmSoundChannel.stop();

			removeChild(player);
			removeChild(pilot);

			var explosion = new Explosion  ;
			addChild(explosion);
			explosion.explosionFunction(player.x,player.y);
			explodeSound = new Boom  ;
			sfxSoundChannel = explodeSound.play(0,1);
			sfxSoundChannel.addEventListener(Event.SOUND_COMPLETE,sfxFinish,false,0,true);

			var gameOver = new GameOver  ;
			addChild(gameOver);
			gameOver.x = GAME_WIDTH / 2;
			gameOver.y = GAME_HEIGHT / 2;
			gameOverScoreNumber = overallScoreNumber;

			addChild(gameOverScore);
			textFormat = new TextFormat(standartFont.fontName,30,0xFFFFFF);
			gameOverScore.defaultTextFormat = textFormat;
			gameOverScore.embedFonts = true;
			gameOverScore.autoSize = "left";
			gameOverScore.x = GAME_WIDTH / 2 - 75;
			gameOverScore.y = GAME_HEIGHT / 2;
			gameOverScore.text = ('SCORE: ' + '0000000'.slice(0,-overallScoreNumber.toString().length) + overallScoreNumber.toString());
		}

		/*---------------------Пауза--------------------------------------------------------*/

		public function pauseOn():void
		{
			if (gameOverState == false)
			{
				stage.frameRate = .01;
			}
		}

		public function pauseOff():void
		{
			if (gameOverState == false)
			{
				stage.frameRate = 60;
			}
		}

		/*---------------------Чистка игры--------------------------------------------------*/

		public function removeGame():void
		{
			removeEventListener(Event.ENTER_FRAME,mainFunction);
			bgmTimer.removeEventListener(TimerEvent.TIMER,bgmStart);
			waitTimer.removeEventListener(TimerEvent.TIMER,gameModeWait);
			gameModeTimer.removeEventListener(TimerEvent.TIMER,gameChange);

			bgmSoundChannel.stop();
			bgmSoundChannel.removeEventListener(Event.SOUND_COMPLETE,bgmFinish);

			if (contains((player && pilot)))
			{
				removeChild(player);
				player = null;
				removeChild(pilot);
				pilot = null;
			}

			if (gameOverState)
			{
				sfxSoundChannel.stop();
				sfxSoundChannel.removeEventListener(Event.SOUND_COMPLETE,sfxFinish);
			}
		}
	}
}