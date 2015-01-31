package framework.helper
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Loader;
	import flash.errors.IllegalOperationError;

	public class HelpUtils
	{
		public function HelpUtils()
		{
		}
		
		public static function newApply(definition:Class, arguments:Array = null):Object
		{
			if(definition == null)
			{
				throw new Error("Null definition");
			}
			
			var numberArguments:int = arguments == null || arguments.length == 0 ? 0 : arguments.length;
			var object:Object = null;
			switch(numberArguments)
			{
				case 0:
					object = new definition();
					break;
				case 1:
					object = new definition(arguments[0]);
					break;
				case 2:
					object = new definition(arguments[0], arguments[1]);
					break;
				case 3:
					object = new definition(arguments[0], arguments[1], arguments[2]);
					break;
				case 4:
					object = new definition(arguments[0], arguments[1], arguments[2], arguments[3]);
					break;
				case 5:
					object = new definition(arguments[0], arguments[1], arguments[2], arguments[3], arguments[4]);
					break;
				case 6:
					object = new definition(arguments[0], arguments[1], arguments[2], arguments[3], arguments[4], arguments[5]);
					break;
				case 7:
					object = new definition(arguments[0], arguments[1], arguments[2], arguments[3], arguments[4], arguments[5], arguments[6]);
					break;
				case 8:
					object = new definition(arguments[0], arguments[1], arguments[2], arguments[3], arguments[4], arguments[5], arguments[6], arguments[7]);
					break;
				case 9:
					object = new definition(arguments[0], arguments[1], arguments[2], arguments[3], arguments[4], arguments[5], arguments[6], arguments[7], arguments[8]);
					break;
				default:
					throw new IllegalOperationError("Length of arguments list more than 9 : " + arguments);
			}
			
			return object;
		}
		
		/**
		 * 断开数组和每个元素之间的引用
		 *
		 * @param array 指定操作的数组或Vector
		 *
		 * @throws NullPointerException
		 * 指定的数组是null
		 */
		public static function breakArray(array:*):void
		{
			if(array == null)
			{
				throw new Error("Null array");
			}
			
			var length:int = array.length;
			for(var i:int = 0; i < length; i++)
			{
				array[i] = null;
			}
			array.length = 0;
		}
		
		/**
		 *从父组件中移除某子组件 
		 * @param child
		 * @param checkParent 是否检查在没有父组件时的移除错误
		 * 
		 */		
		public static function removeSelf( child:DisplayObject, checkParent:Boolean=false
										   , container:DisplayObjectContainer = null ):void
		{
			container = container || child.parent;
			if( !container )
			{
				if( checkParent )
				{
					throw new Error("找不到父组件，要移除的组件已经从父组件中移除了。");
				}else
				{
					return;//没有父组件，无需移除
				}
			}else if( container is Loader){
				return;//Loader类不实现此方法
			}
			
			container.removeChild( child );
		}
	}
}