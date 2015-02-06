package lib.ui.core
{
	public interface IComponent
	{
		function set componentXml(value:XML):void;
		function componentRender():void;
	}
}