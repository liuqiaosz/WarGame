package wargame.sm
{
	import flash.utils.Dictionary;
	
	import framework.module.notification.NotificationIds;

	/**
	 * 状态机核心类
	 **/
	public class StateMachine
	{
		private var _currentState:IState = null;//当前状态
		private var _states:Vector.<IState> = null;
		private var _stateDict:Dictionary = null;
		private var _condDict:Dictionary = null;
		private var _onChange:Function = null;
		private var _onUpdate:Function = null;
		
		private var argInt:Dictionary = null;
		private var argBool:Dictionary = null;
		private var argString:Dictionary = null;
		
		public function StateMachine(onUpdate:Function,onChangeState:Function = null)
		{
			_states = new Vector.<IState>();
			_stateDict = new Dictionary();
			_condDict = new Dictionary();
			_onUpdate = onUpdate;
			
			argInt = new Dictionary();
			argBool = new Dictionary();
			argString = new Dictionary();
		}
		
		public function setInt(name:String,value:int):void
		{
			argInt[name] = value;
		}
		public function setBool(name:String,value:Boolean):void
		{
			argBool[name] = value;
		}
		public function setString(name:String,value:String):void
		{
			argString[name] = value;
		}
		
		//开始状态机运行
		public function begin():void
		{
			addFrameworkListener(NotificationIds.MSG_FMK_FRAME_UPDATE,onTick);
		}
		
		private var transformList:Vector.<IStateTransaction> = null;
		private function onTick(value:Object = null):void
		{
			if(null != _onUpdate)
			{
				_onUpdate(this);
			}
			if(_currentState)
			{
				_currentState.execute(value);
			}
			
			transformList = _condDict[_currentState];
			for each(var trans:IStateTransaction in transformList)
			{
				if(trans.checkCond(argInt,argBool,argString))
				{
					//状态变换
					if(_currentState)
					{
						_currentState.onExit();
					}
					_currentState = trans.getDestState();
					if(_currentState)
					{
						_currentState.onBegin();
					}
				}
			}
		}
		
		/**
		 * 添加一个状态转换链接
		 **/
		public function addTransform(src:IState,dest:IState):IStateTransaction
		{
			var check:Boolean = true;
			if(!(src in _condDict))
			{
				_condDict[src] = new Vector.<IStateTransaction>();
				check = false;
			}
			var conditions:Vector.<IStateTransaction> = _condDict[src];
			var trans:IStateTransaction = null;
			if(check)
			{
				for(var idx:int = 0; idx<conditions.length; idx++)
				{
					if(conditions[idx].getDestState() == dest)
					{
						return conditions[idx];
					}
				}
			}
			
			trans = new protoTransform(dest);
			conditions.push(trans);
			return trans;
		}
		
		/**
		 * 添加一个状态
		 **/
		public function addState(state:int,executor:Function,onBegin:Function = null,onEnd:Function = null):IState
		{
			if(!(state in _stateDict))
			{
				_stateDict[state] = new State(state,executor,onBegin,onEnd);
				if(_states.length == 0)
				{
					_currentState = _stateDict[state];
				}
				_states.push(_stateDict[state]);
			}
			
			return _stateDict[state];
		}
		
		/**
		 * 设置默认状态
		 **/
		public function setDefaultState(state:int):void
		{
			if(state in _stateDict)
			{
				_currentState = _stateDict[state];
			}
		}
		
		//状态机结束运行
		public function end():void
		{
			removeFrameworkListener(NotificationIds.MSG_FMK_FRAME_UPDATE,onTick);
		}
	}
}