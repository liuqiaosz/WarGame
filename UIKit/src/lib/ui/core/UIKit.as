package lib.ui.core
{
	import flash.utils.getTimer;
	
	import starling.core.Starling;
	import starling.events.Event;

	public class UIKit
	{
		private static var _instance:UIKit = null;
		public function UIKit()
		{
		}
		
		private var _invalidateList:Vector.<IComponent> = null;
		private var isInit:Boolean = false;
		public static function get instance():UIKit
		{
			if(!_instance)
			{
				_instance = new UIKit();
				_instance.initializer();
			}
			return _instance;
		}
		
		private function initializer():void
		{
			_invalidateList = new Vector.<IComponent>();
			if(Starling.current)
			{
				Starling.current.stage.addEventListener(Event.ENTER_FRAME,onUpdate);
				last = getTimer();
				isInit = true;
			}
		}
		
		private var last:int = 0;
		private var now:int = 0;
		private var swap:Vector.<IComponent> = null;
		private function onUpdate(event:Event):void
		{
			now = getTimer();
			swap = _invalidateList.concat();
			_invalidateList.length = 0;
			for(var idx:int = 0; idx<swap.length; idx++)
			{
				swap[idx].invalidateRender();
			}
			swap.length = 0;
		}
		
		public function addInvalidate(comp:IComponent):void
		{
			if(_invalidateList.indexOf(comp) < 0)
			{
				_invalidateList.unshift(comp);
			}
		}
		
	}
}