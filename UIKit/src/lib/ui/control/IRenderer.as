package lib.ui.control
{
	public interface IRenderer
	{
		function set data(value:Object):void;
		
		function set x(value:Number):void;
		function set y(value:Number):void;
		function get width():Number;
		function get height():Number;
		
		function set index(value:int):void;
		function get index():int;
	}
}