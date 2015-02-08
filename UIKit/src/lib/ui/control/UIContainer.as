package lib.ui.control
{
	import flash.geom.Rectangle;
	
	import lib.ui.core.IContainer;
	
	import org.osmf.layout.HorizontalAlign;
	
	import starling.display.DisplayObject;
	import starling.display.DisplayObjectContainer;
	import starling.display.Sprite;

	/**
	 * 容器组件
	 **/
	public class UIContainer extends Component implements IContainer
	{
		public static const LAYOUT_NONE:int = 0;
		public static const LAYOUT_H:int = 1;
		public static const LAYOUT_V:int = 2;
		public static const LAYOUT_G:int = 3;
		private var _layout:int = 0;
		private var _gap:int = 0;
		private var _marginLeft:int = 0;
		private var _marginTop:int = 0;
		protected var _content:Sprite = null;
		protected var _bounds:Rectangle = null;
		public function set layout(value:int):void
		{
			_layout = value;
			invalidate();
		}
		public function set gap(value:int):void
		{
			_gap = value;
			invalidate();
		}
		public function set marginLeft(value:int):void
		{
			_marginLeft = value;
			invalidate();
		}
		public function UIContainer()
		{
			_children = new Vector.<DisplayObject>();
			_content = new Sprite();
			super.addChild(_content);
		}
		
		protected var _children:Vector.<DisplayObject> = null;
		override public function addChild(child:DisplayObject):DisplayObject
		{
			_children.push(child);
			invalidate();
			return _content.addChild(child);
		}
		
		override public function removeChild(child:DisplayObject, dispose:Boolean=false):DisplayObject
		{
			var idx:int = _children.indexOf(child);
			if(idx >= 0)
			{
				_children.splice(idx,1);
			}
			invalidate();
			return _content.removeChild(child,dispose);
		}
		
		override public function set componentXml(value:XML):void
		{
			_layout = int(value.@layout);
			_gap = int(value.@gap);
			super.componentXml = value;
		}
		
		override public function invalidateRender():void
		{
			_bounds = _content.bounds;
			updateLayout();
			super.invalidateRender();
		}
		
		protected function updateLayout():void
		{
			switch(_layout)
			{
				case LAYOUT_V:
					verticalLayout();
					break;
				default:
					//_content.x = -(_bounds.width >> 1);
					//_content.y = -(_bounds.height >> 1);
					break;
			}
		}
		
		private function verticalLayout():void
		{
			var len:int = _children.length;
			var child:DisplayObject = null;
			var prevChild:DisplayObject = null;
			var totalH:int = 0;
			for(var idx:int = 0; idx<len; idx++)
			{
				child= _children[idx];
				child.x = _marginLeft;
				child.y = (prevChild ? (prevChild.y + prevChild.height):0) + _gap;
				prevChild = child;
			}
			totalH = prevChild.y + prevChild.height;
			if(_anchorX > 0)
			{
				_content.x = -(_bounds.width * _anchorX);
			}
			if(_anchorY > 0)
			{
				_content.y = -(totalH * _anchorY);
			}
			//_content.y = -(totalH >> 1);
			//_content.x = -(_bounds.width>>1);
		}

		private function horizontalLayout():void
		{
			var len:int = _children.length;
			var child:DisplayObject = null;
			var prevChild:DisplayObject = null;
			var totalW:int = 0;
			for(var idx:int = 0; idx<len; idx++)
			{
				child= _children[idx];
				child.x = (prevChild ? (prevChild.x + prevChild.width):0) + _gap;
				child.y = _marginTop;
				prevChild = child;
			}
			totalW = prevChild.y + prevChild.height;
			if(_anchorX > 0)
			{
				_content.x = -(totalW * _anchorX);
			}
			if(_anchorY > 0)
			{
				_content.y = -(_bounds.height * _anchorY);
			}
		}
	}
}