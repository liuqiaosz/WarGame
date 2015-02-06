package lib.ui.control
{
	import flash.geom.Rectangle;
	
	import flashx.textLayout.formats.VerticalAlign;
	
	import org.osmf.layout.HorizontalAlign;
	
	import starling.display.DisplayObject;
	import starling.display.Sprite;
	import starling.events.TouchEvent;

	public class UIScrollView extends UIContainer
	{
		private static const GAP:int = 10;
		private static var SWIP_FRICTION:Number = 0.015;
		private static const SWIP_TIME_THRESHOLD:int = 500;
		private static const SWIP_POS_THRESHOLD:int = 50;
		public static const LAYOUT_H:int = 1;
		public static const LAYOUT_V:int = 2;
		public static const LAYOUT_G:int = 3;
		
		private var _layout:int = 0;
		private var _itemW:Number = 0;
		private var _itemH:Number = 0;
		private var _itemRenderer:Class = null;
		private var _content:Sprite = null;
		
		public function UIScrollView(layout:int,itemRenderer:Class)
		{
			_itemRenderer = itemRenderer;
			_layout = layout;
			_content = new Sprite();
			addChild(_content);
		}
		
		private var _viewport:Rectangle = null;
		override public function componentRender():void
		{
			super.componentRender();
			//初始化可视区域
			_viewport = new Rectangle(0,0,compWidth,compHeight);
			this.clipRect = _viewport;
			
			if(_itemRenderer)
			{
				var item:IRenderer = new _itemRenderer();
				_itemW = item.width;
				_itemH = item.height;
				_items.push(item);
			}
			refreshLayout();
			this.addEventListener(TouchEvent.TOUCH,onTouch);
		}
		
		private function onTouch(event:TouchEvent):void
		{
			
		}
		
		private var _items:Vector.<IRenderer> = null;
		private var _dataProvider:Array = null;
		public function set dataProvider(value:Array):void
		{
			
		}
		
		/**
		 * 刷新布局
		 **/
		protected function refreshLayout():void
		{
			switch(_layout)
			{
				case LAYOUT_H:
					refreshHorizontal();
					break;
				case LAYOUT_V:
					break;
				case LAYOUT_G:
					break;
			}
		}
		
		private function refreshHorizontal():void
		{
			var initCount:int = _viewport.width / (_itemW + GAP) + 2;
			var item:IRenderer = null;
			var idx:int = 0;
			while(_items.length < initCount)
			{
				item = new _itemRenderer();
				addItemBack(item,idx);
				idx++;
			}
		}
		private function refreshVertical():void
		{
			var initCount:int = _viewport.height / (_itemH + GAP) + 2;
			var item:IRenderer = null;
			var idx:int = 0;
			while(_items.length < initCount)
			{
				item = new _itemRenderer();
				addItemBack(item,idx);
				idx++;
			}
		}
		
		private function addItemFront(item:IRenderer,index:int):void
		{
			switch(_layout)
			{
				case LAYOUT_H:
					item.x = index * _itemW + index * GAP;
					break;
				case LAYOUT_V:
					item.y = index * _itemH + index * GAP;
					break;
				case LAYOUT_G:
					break;
			}
			
			_content.addChild(item as DisplayObject);
			_items.unshift(item);
		}
		private function addItemBack(item:IRenderer,index:int):void
		{
			switch(_layout)
			{
				case LAYOUT_H:
					item.x = index * _itemW + index * GAP;
					break;
				case LAYOUT_V:
					item.y = index * _itemH + index * GAP;
					break;
				case LAYOUT_G:
					break;
			}
			_content.addChild(item as DisplayObject);
			_items.push(item);
		}
	}
}