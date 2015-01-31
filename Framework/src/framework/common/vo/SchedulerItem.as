package framework.common.vo
{
	import flash.utils.getTimer;
	
	import framework.common.objectPool.IReuseable;

	/**
	 * 调度节点
	 */
	public class SchedulerItem implements IReuseable
	{
		public var repeat:int = 0;
		public var delay:int = 0;
		public var handler:Function = null;
		public var comleteHandler:Function = null;
		private var _runCount:int = 0;
		private var _lastTodo:int = 0;
		public function get lastTodo():int
		{
			return _lastTodo;
		}
		public function get runCount():int
		{
			return _runCount;	
		}
		public function SchedulerItem()
		{
		}
		
		public function init():void
		{
			_lastTodo = flash.utils.getTimer();
		}
		
		public function todo(t:int):void
		{
			_lastTodo = t;
			_runCount++;
			if(null != handler)
			{
				handler(this);
			}
		}
		
		public function reuse():void
		{
			repeat = 0;
			delay = 0;
			handler = null;
			comleteHandler = null;
			_runCount = 0;
		}
		
	}
}