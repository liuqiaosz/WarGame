package editor.utility
{
	import editor.debug.Logger;
	import editor.ui.LoggerPanel;
	
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;
	import flash.utils.Dictionary;
	
	import mx.core.FlexGlobals;

	public class KeyboardManager
	{
		public static const COMMAND_QUICKSAVE:int = 101;
		public static const COMMAND_QUICKSAVE_ALL:int = 102;
		
		private static var _instance:KeyboardManager = null;
		public static function get instance():KeyboardManager
		{
			if(!_instance)
			{
				_instance = new KeyboardManager();
			}
			return _instance;
		}
		
		private var command:Boolean = false;
		
		public function KeyboardManager()
		{
			FlexGlobals.topLevelApplication.addEventListener(KeyboardEvent.KEY_DOWN,onKeyPressed);
			FlexGlobals.topLevelApplication.addEventListener(KeyboardEvent.KEY_UP,onKeyReleased);
		}
		
		private function onKeyPressed(event:KeyboardEvent):void
		{
			switch(event.keyCode)
			{
				case Keyboard.F1:
					Logger.instance.showPanel();
					break;
				case Keyboard.S:
					if(command)
					{
						//快速保存
						dispatchCommand(COMMAND_QUICKSAVE);
					}
					break;
				case Keyboard.CONTROL:
					command = true;
					break;
			}
		}
		
		private function onKeyReleased(event:KeyboardEvent):void
		{
			switch(event.keyCode)
			{
				case Keyboard.CONTROL:
					command = false;
					break;
			}
		}
		
		private var _callbacks:Dictionary = new Dictionary();
		public function onCommand(command:int,value:Function):void
		{
			if(!(command in _callbacks))
			{
				_callbacks[command] = [];
			}
			
			if(_callbacks[command].indexOf(value) < 0)
			{
				_callbacks[command].push(value);
			}
		}
		
		private function dispatchCommand(value:int):void
		{
			if(value in _callbacks)
			{
				for each(var func:Function in _callbacks[value])
				{
					func(value);
				}
			}
		}
	}
}