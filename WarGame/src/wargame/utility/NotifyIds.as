package wargame.utility
{
	public class NotifyIds
	{
		public static const LOGIC_BATTLE_REQUEST:String = "LogicBattleRequest";		//请求战斗
		public static const LOGIC_BATTLE_ENTER:String = "LogicBattleEnter";			//准备完毕，进入战斗
		public static const LOGIC_BATTLE_INIT_ERR:String = "LogicBattleInitErr";	//战斗初始化错误
		public static const LOGIC_BATTLE_RES_ERR:String = "LogicBattleResErr";		//资源初始化异常
		
		public static const LOGIC_BATTLE_READY:String = "LogicBattleReady";			//准备完毕
		public static const LOGIC_BATTLE_BEGIN:String = "LogicBattleBegin";			//开始战斗
		public static const LOGIC_BATTLE_ADD:String = "LogicBattleAdd";				//往战场添加一个节点，可能是角色，飞弹
		public static const LOGIC_BATTLE_ADDED:String = "LogicBattleAdded";			//添加完成
		public static const LOGIC_BATTLE_PAUSE:String = "LogicBattlePause";			//暂停
		public static const LOGIC_BATTLE_RESUME:String = "LogicBattleResume";		//恢复
		
		public static const LOGIC_BATTLE_UPDATE:String = "LogicBattleUpdate";		//战斗数据刷新

		public function NotifyIds()
		{
		}
	}
}