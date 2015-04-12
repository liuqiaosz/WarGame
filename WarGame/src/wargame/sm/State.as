package wargame.sm
{
	public class State implements IState
	{
		private var _state:int;
		public function get state():int
		{
			return _state;
		}
		private var _process:Function = null;
		private var _begin:Function = null;
		private var _end:Function = null;
		public function State(value:int,progress:Function,beginProcess:Function = null,endProcess:Function = null)
		{
			_process = progress;
			_state = value;
			_begin = beginProcess;
			_end = endProcess;
		}
		
		public function execute(t:int):void
		{
			if(null != _process)
			{
				_process(t);
			}
		}
		
		public function onBegin():void
		{
			if(null != _begin)
			{
				_begin(this);
			}
		}
		
		public function onExit():void
		{
			if(null != _end)
			{
				_end(this);
			}
		}
		
	}
}