package wargame.sm
{
	import flash.utils.Dictionary;

	public class ConditionBool implements ITransactionCond
	{
		private var _name:String = "":
		private var _value:Boolean = false;
		public function ConditionBool(name:String,value:Boolean)
		{
			_name = name;
			_value = value;
		}
		
		public function check(argInt:Dictionary,argBool:Dictionary,argString:Dictionary):Boolean
		{
			return (_name in argBool && argBool[_name] == _value);
		}
	}
}