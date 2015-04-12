package wargame.logic.battle
{
	import wargame.logic.battle.vo.ArmyInfo;
	import wargame.logic.battle.vo.SoliderInfo;
	import wargame.sm.ConditionInt;
	import wargame.sm.IState;
	import wargame.sm.IStateTransaction;
	import wargame.sm.StateMachine;

	public class AI
	{
		private static const STATE_IDLE:int = 1;		//空闲状态
		private static const STATE_BUILD:int = 2;	//建造状态，升级城堡或者生产单位
		
		private var _sm:StateMachine = null;			//逻辑状态机
		private var _controlArmy:ArmyInfo = null;	//控制的阵营
		private var _miniCostNeed:int = 0;				//需要最低资源消耗
		
		public function AI(army:ArmyInfo)
		{
			_controlArmy = army;
			_sm = new StateMachine(onMachineUpdate);
			
			for each(var solider:SoliderInfo in _controlArmy.solider)
			{
				_miniCostNeed = Math.min(_miniCostNeed,solider.levelInfo.cost);
			}
		}
		
		private function onMachineUpdate():void
		{
			
		}
		
		/**
		 * 开始AI逻辑
		 **/
		public function begin():void
		{
			_sm.begin();
			
			//空闲逻辑
			var idle:IState = _sm.addState(STATE_IDLE,function(t:int):void{
				_totalTime += t;
				debug("空闲等待状态,已等待[" + _totalTime + "]毫秒");
			},function(t:int):void{
				_totalTime = 0;
				debug("开始空闲状态");
			},function(t:int):void{
				debug("空闲状态结束");
			});
			
			var build:IState = _sm.addState(STATE_BUILD,function(t:int):void{
				
			},function():void{},function():void{});
			
			//空闲->生产
			var transaction:IStateTransaction = _sm.addTransform(idle,build);
			transaction.addCondition(new ConditionInt("Res",ConditionInt.TYPE_BIG,_miniCostNeed));
			
			//生产->空闲
			transaction = _sm.addTransform(build,idle);
			transaction.addCondition(new ConditionInt("Res",ConditionInt.TYPE_SMALL,_miniCostNeed));
		}
		
		private var _totalTime:int = 0;
		private function onIdleProcess(t:int):void
		{
			
		}
	}
}

class 