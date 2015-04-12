package wargame.sm
{
	import flash.utils.Dictionary;

	public interface ITransactionCond
	{
		function check(argInt:Dictionary,argBool:Dictionary,argString:Dictionary):Boolean;
	}
}