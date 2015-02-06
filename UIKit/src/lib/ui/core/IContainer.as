package lib.ui.core
{
	import starling.display.DisplayObject;

	public interface IContainer extends IComponent
	{
		function addChild(value:DisplayObject):DisplayObject;
	}
}