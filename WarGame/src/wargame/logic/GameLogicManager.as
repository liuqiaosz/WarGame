package wargame.logic
{
	import framework.module.notification.NotificationIds;

	public class GameLogicManager
	{
		private static var _instance:GameLogicManager = null;
		public static function get instance():GameLogicManager
		{
			if(!_instance)
			{
				_instance = new GameLogicManager();
			}
			return _instance;
		}
		
		private var _logics:Vector.<IGameLogic> = null;
		public function add(value:IGameLogic):void
		{
			if(_logics.indexOf(value) < 0)
			{
				_logics.push(value);
			}
			addFrameworkListener(NotificationIds.MSG_FMK_FRAME_UPDATE,onUpdate);
		}
		
		private function onUpdate(delta:int):void
		{
			for(var idx:int = 0; idx<_logics.length; idx++)
			{
				_logics[idx].update(delta);
			}
		}
		
		public function remove(value:IGameLogic,dispose:Boolean = true):void
		{
			var idx:int = _logics.indexOf(value >= 0);
			if(idx >= 0)
			{
				var logic:IGameLogic = _logics[idx];
				_logics.splice(idx,1);
				logic.dispose();
				logic = null;
			}
		}
		
		public function GameLogicManager()
		{
			_logics = new Vector.<IGameLogic>();
		}
	}
}