package 
{
	import flash.events.Event;

	public class StartEvent extends Event
	{
		public static const START:String = "start";

		public function StartEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false)
		{
			super(type, bubbles, cancelable);
		}

		public override function clone():Event
		{
			return new StartEvent(type, bubbles, cancelable);
		}

		public override function toString():String
		{
			return formatToString("StartEvent", "type", "bubbles", "cancelable", "eventPhase");
		}
	}
}