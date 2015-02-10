package wargame.logic.game
{
	import wargame.logic.IGameLogic;
	import wargame.logic.game.vo.SaveInfo;

	public class GameLogic implements IGameLogic
	{
		private static var _instance:GameLogic = null;
		public static function get instance():GameLogic
		{
			if(!_instance)
			{
				_instance = new GameLogic();
			}
			return _instance;
		}
		
		private var _info:SaveInfo = null;
		private var _saveDatas:Array = [null,null,null];
		public function GameLogic()
		{
			if(_instance)
			{
				throw new Error("");
			}
			
			_info = new SaveInfo();
		}
		
		public function get saveInfo():SaveInfo
		{
			return _info;
		}
		
		public function get saveRecords():Array
		{
			return _saveDatas;
		}
		
		public function dispose():void
		{
			
		}
		
		public function update(delta:int):void
		{
			
		}
	}
}