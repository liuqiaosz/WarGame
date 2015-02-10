package wargame.logic.game.vo
{
	public class SaveInfo
	{
		//关卡数据
		public var levels:Vector.<SaveLevelInfo> = null;
		//城堡等级
		public var camplv:int = 0;
		//挂载组件
		public var campComs:Vector.<SaveComponent>;
		//单位数据
		public var soliders:Vector.<SaveSoliderInfo>;
		//道具数据
		public var goods:Vector.<SaveGoodsInfo>;
		//货币
		public var money:int = 0;
		//上阵的单位
		public var rushSoliders:Vector.<SaveSoliderInfo>;
		
		public function SaveInfo()
		{
		}
		
	}
}