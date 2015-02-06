package lib.ui.control
{
	import lib.ui.core.IContainer;
	
	import starling.display.DisplayObject;
	import starling.display.Sprite;

	/**
	 * 容器组件
	 **/
	public class UIContainer extends Component implements IContainer
	{
		public function UIContainer()
		{
			_children = new Vector.<DisplayObject>();
		}
		
		protected var _children:Vector.<DisplayObject> = null;
		override public function addChild(child:DisplayObject):DisplayObject
		{
			_children.push(child);
			return super.addChild(child);
		}
		
		override public function removeChild(child:DisplayObject, dispose:Boolean=false):DisplayObject
		{
			var idx:int = _children.indexOf(child);
			if(idx >= 0)
			{
				_children.splice(idx,1);
			}
			return super.removeChild(child,dispose);
		}
	}
}