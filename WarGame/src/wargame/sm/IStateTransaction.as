package wargame.sm
{
	public interface IStateTransaction
	{
		function checkCond(...args:Array):Boolean;
		function getDestState():IState;
		function addCondition(cond:ITransactionCond):void;
	}
}