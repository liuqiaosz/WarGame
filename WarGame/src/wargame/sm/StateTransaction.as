package wargame.sm
{
	import flash.utils.Dictionary;

	public class StateTransaction implements IStateTransaction
	{
		private var _conditions:Vector.<ITransactionCond> = null;
		private var _dest:IState = null;
		public function StateTransaction(value:IState)
		{
			_dest = value;
			_conditions = new Vector.<ITransactionCond>();
		}
		
		public function checkCond(argInt:Dictionary,argBool:Dictionary,argString:Dictionary):Boolean
		{
			for each(var cond:ITransactionCond in _conditions)
			{
				if(!cond.check(argInt,argBool,argString))
				{
					return false;
				}
			}
			return true;
		}
		
		public function getDestState():IState
		{
			return _dest;
		}
		
		public function addCondition(cond:ITransactionCond):void
		{
			_conditions.push(cond);
		}
		
	}
}