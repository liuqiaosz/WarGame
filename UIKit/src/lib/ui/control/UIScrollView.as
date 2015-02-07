package lib.ui.control
{
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.getTimer;
	
	import flashx.textLayout.formats.VerticalAlign;
	
	import org.osmf.layout.HorizontalAlign;
	
	import starling.display.DisplayObject;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;

	public class UIScrollView extends Component
	{
		private static const GAP:int = 10;
		private static var SWIP_FRICTION:Number = 0.015;
		private static const SWIP_TIME_THRESHOLD:int = 500;
		private static const SWIP_POS_THRESHOLD:int = 50;
		public static const LAYOUT_H:int = 1;
		public static const LAYOUT_V:int = 2;
		public static const LAYOUT_G:int = 3;
		
		private var _layout:int = 0;
		public function set layout(value:int):void
		{
			_layout = value;
		}
		private var _itemW:Number = 0;
		private var _itemH:Number = 0;
		private var _itemRenderer:Class = null;
		public function set itemRenderer(value:Class):void
		{
			_itemRenderer = value;
		}
		private var _content:Sprite = null;
		
//		public function UIScrollView(layout:int,itemRenderer:Class)
		public function UIScrollView()
		{
//			_itemRenderer = itemRenderer;
//			_layout = layout;
			_content = new Sprite();
			addChild(_content);
			_items = new Vector.<IRenderer>();
		}
		
		private var _viewport:Rectangle = null;
		override public function invalidateRender():void
		{
			//初始化可视区域
			_viewport = new Rectangle(0,0,compWidth,compHeight);
			this.clipRect = _viewport;
			refreshLayout();
			super.invalidateRender();
		}
		
		private var beginMousePos:Number = 0;
		private var endMousePos:Number = 0;
		private var lastMousePos:Number = 0;
		private var curMousePos:Number = 0;
		private var isScrolling:Boolean = false;
		private var isSwip:Boolean = false;
		private var beginTime:Number = 0;
		private var endTime:Number = 0;
		private var nowTime:Number = 0;
		private var touch:Touch = null;
		private var swipPixel:int = 0;
		private var swipDelta:Number = 0;
		private function onTouch(event:TouchEvent):void
		{
			nowTime = flash.utils.getTimer();
			touch = event.getTouch(stage,TouchPhase.BEGAN);
			if(touch)
			{
				isSwip = false;
				//begin
				isScrolling = true;
				if(_layout == LAYOUT_H)
				{
					beginMousePos = curMousePos = lastMousePos = touch.globalX;
				}
				else if(_layout == LAYOUT_V)
				{
					beginMousePos = curMousePos = lastMousePos = touch.globalY;
				}
				beginTime = nowTime;
				this.addEventListener(Event.ENTER_FRAME,onUpdate);
				return;
			}
			
			touch = event.getTouch(stage,TouchPhase.MOVED);
			if(touch)
			{
				if(_layout == LAYOUT_H)
				{
					//move
					curMousePos = touch.globalX;
				}
				else if(_layout == LAYOUT_V)
				{
					curMousePos = touch.globalY;
				}
			}
			
			touch = event.getTouch(stage,TouchPhase.ENDED);
			if(touch)
			{
				//up
				isScrolling = false;
				endTime = nowTime;
				if(_layout == LAYOUT_H)
				{
					endMousePos = touch.globalX;
				}
				else
				{
					endMousePos = touch.globalY;
				}
				if(endTime - beginTime <= SWIP_TIME_THRESHOLD && Math.abs(endMousePos - beginMousePos) >= SWIP_POS_THRESHOLD)
				{
					//满足滑屏缓动条件
					SWIP_FRICTION = Math.abs(endTime - beginTime) * 0.0001;
					isSwip = true;
					swipDelta = 10;
					swipPixel = endMousePos - beginMousePos;
				}
			}
		}
		
		public function onUpdate(event:Event):void
		{
			if(isSwip)
			{
				//滑屏滚动
				if(swipPixel < 0)
				{
					//left
					scrollLeftOrTop(-swipDelta);
					if(int(swipDelta) <= 0)
					{
						isSwip = false;
					}
				}
				else
				{
					//right
					scrollRightOrBottom(swipDelta);
					
					if(int(swipDelta) <= 0)
					{
						isSwip = false;
					}
				}
				
				swipDelta -= (swipDelta * SWIP_FRICTION);
			}
			else if(isScrolling && lastMousePos != curMousePos)
			{
				var delta:int = curMousePos - lastMousePos;
				lastMousePos = curMousePos;
				
				if(delta < 0)
				{
					scrollLeftOrTop(delta);
				}
				else
				{
					scrollRightOrBottom(delta);
				}
			}
		}
		
		private var zero:Point = new Point();
		private function scrollLeftOrTop(delta:Number):void
		{
			var item:IRenderer = null;
			var pos:Point = null;
			if(_layout == LAYOUT_H)
			{
				_content.x += delta;
				if(_items && _items.length)
				{
					if(DisplayObject(_items[0]).localToGlobal(zero).x < -(_itemW + GAP))
					{
						if(_items[_items.length - 1].index == _dataProvider.length)
						{
							isSwip = false;
							isScrolling = false;
							return;
						}
						item = _items.shift();
						item.index = _items[_items.length - 1].index + 1;
						item.x = item.index * _itemW + item.index * GAP;
						_content.addChild(item as DisplayObject);
						_items.push(item);
					}
				}
			}
			else if(_layout == LAYOUT_V)
			{
				_content.y += delta;
				if(_items && _items.length)
				{
					if(DisplayObject(_items[0]).localToGlobal(zero).y < -(_itemH + GAP))
					{
						item = _items.shift();
						item.index = _items[_items.length - 1].index + 1;
						item.y = item.index * _itemH + item.index * GAP;
						_content.addChild(item as DisplayObject);
						_items.push(item);
					}
				}
			}
		}
		
		private var pos:Point = null;
		private function scrollRightOrBottom(delta:Number):void
		{
			var item:IRenderer = null;
			if(_layout == LAYOUT_H)
			{
				_content.x += delta;
				if(_content.x > 0)
				{
					_content.x = 0;
				}
				if(_items && _items.length)
				{
					pos = DisplayObject(_items[_items.length - 1]).localToGlobal(zero);
					if(pos.x > clipRect.width && _items[0].index > 0)
					{
						item = _items.pop();
						item.index = _items[0].index - 1;
						item.x = item.index * _itemW + item.index * GAP;
						
						_content.addChild(item as DisplayObject);
						_items.unshift(item);
					}
				}
			}
			else
			{
				_content.y += delta;
				if(_content.y > 0)
				{
					_content.y = 0;
				}
				if(_items && _items.length)
				{
					pos = DisplayObject(_items[_items.length - 1]).localToGlobal(zero);
					if(pos.y > clipRect.height && _items[0].index > 0)
					{
						item = _items.pop();
						item.index = _items[0].index - 1;
						item.y = item.index * _itemH + item.index * GAP;
						_content.addChild(item as DisplayObject);
						_items.unshift(item);
					}
				}
			}
		}
		
		private var _items:Vector.<IRenderer> = null;
		private var _dataProvider:Array = null;
		public function set dataProvider(value:Array):void
		{
			if(_items.length == 0)
			{
				if(_itemRenderer)
				{
					var item:IRenderer = new _itemRenderer();
					_itemW = item.width;
					_itemH = item.height;
					//_items.push(item);
				}
				
				addEventListener(TouchEvent.TOUCH,onTouch);
			}
			_dataProvider = value;
			
		}
		
		/**
		 * 刷新布局
		 **/
		protected function refreshLayout():void
		{
			_content.x = _content.y = 0;
			switch(_layout)
			{
				case LAYOUT_H:
					refreshHorizontal();
					break;
				case LAYOUT_V:
					refreshVertical();
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
			item.data = null;
			item.index = index;
			item.data = _dataProvider[index];
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
			item.data = null;
			item.index = index;
			item.data = _dataProvider[index];
			_content.addChild(item as DisplayObject);
			_items.push(item);
		}
	}
}