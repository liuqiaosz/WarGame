package wargame.sm
{
	import flash.utils.Dictionary;

	public class ConditionInt implements ITransactionCond
	{
		public static const TYPE_EQUALS:int = 1;
		public static const TYPE_SMALL:int = 2;
		public static const TYPE_BIG:int = 3;
		public static const TYPE_NOT_EQUALS:int = 4;
		
		private var _name:String = "":
		private var _value:int = 0;
		private var _type:int = 0;
		public function ConditionInt(name:String,type:int,value:int)
		{
			_name = name;
			_value = value;
			_type = type;
		}
		
		public function check(argInt:Dictionary,argBool:Dictionary,argString:Dictionary):Boolean
		{
			if(_name in argInt)
			{
				switch(_type)
				{
					case TYPE_EQUALS:
						return (argInt[_name] == _value);
						break;
					case TYPE_SMALL:
						return (argInt[_name] < _value);
						break;
					case TYPE_BIG:
						return (argInt[_name] > _value);
						break;
					case TYPE_NOT_EQUALS:
						return (argInt[_name] != _value);
						break;
				}
			}
			return false;
		}
	}
}