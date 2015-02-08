package lib.ui.control
{
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.getTimer;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;

	public class UIScroller extends UIContainer
	{
		private static const GAP:int = 10;
		private static var SWIP_FRICTION:Number = 0.015;
		private static const SWIP_TIME_THRESHOLD:int = 500;
		private static const SWIP_POS_THRESHOLD:int = 50;
		public static const LAYOUT_H:int = 1;
		public static const LAYOUT_V:int = 2;
		public static const LAYOUT_G:int = 3;
		
		//滚动UI可视区域
		protected var _viewport:Rectangle = null;
		public function set viewport(value:Rectangle):void
		{
			_viewport = value;
			//_viewport.x = (_viewport.x + -(_viewport.width>>1));
			//_viewport.y = (_viewport.y + -(_viewport.height>>1));
			
		}
		public function get viewport():Rectangle
		{
			return _viewport;
		}
		
		private var _clipRect:Rectangle = new Rectangle();
		private var _range:Rectangle = new Rectangle();
		override public function invalidateRender():void
		{
			super.invalidateRender();
			if(_viewport)
			{
				//设置可视区域
//				_clipRect.x = -(_bounds.width >>1);
//				_clipRect.y = -(_bounds.height >> 1);
//				_clipRect.width = _viewport.width;
//				_clipRect.height = _viewport.height;
//				clipRect = _clipRect;
				clipRect = _viewport;
			}
			
			//设置可移动区域
			_range.x = 0
			_range.width = -(_bounds.width - _viewport.width);
			_range.y = 0
			_range.height = -(_bounds.height - _viewport.height);
			
			if(!this.hasEventListener(TouchEvent.TOUCH))
			{
				this.addEventListener(TouchEvent.TOUCH,onScrollerTouchHandler);
			}
		}
		private var beginMousePos:Point = new Point();
		private var endMousePos:Point = new Point();
		private var lastMousePos:Point = new Point();
		private var curMousePos:Point = new Point();
		private var isScrolling:Boolean = false;
		private var isSwip:Boolean = false;
		private var beginTime:Number = 0;
		private var endTime:Number = 0;
		private var nowTime:Number = 0;
		private var touch:Touch = null;
		private var swipPixel:Point = new Point();
		private var swipDelta:Point = new Point();
		
		private function onScrollerTouchHandler(event:TouchEvent):void
		{
			nowTime = flash.utils.getTimer();
			touch = event.getTouch(stage,TouchPhase.BEGAN);
			if(touch)
			{
				swipPixel.x = swipPixel.y = 0;
				isSwip = false;
				isScrolling = true;
				beginMousePos.x = curMousePos.x = lastMousePos.x = touch.globalX;
				beginMousePos.y = curMousePos.y = lastMousePos.y = touch.globalY;
				beginTime = nowTime;
				this.addEventListener(Event.ENTER_FRAME,onUpdate);
				return;
			}
			
			touch = event.getTouch(stage,TouchPhase.MOVED);
			if(touch)
			{
				curMousePos.x = touch.globalX;
				curMousePos.y = touch.globalY;
			}
			
			touch = event.getTouch(stage,TouchPhase.ENDED);
			if(touch)
			{
				//up
				isScrolling = false;
				endTime = nowTime;
				endMousePos.x = touch.globalX;
				endMousePos.y = touch.globalY;
				
				if(endTime - beginTime <= SWIP_TIME_THRESHOLD && (Math.abs(endMousePos.x - beginMousePos.x) >= SWIP_POS_THRESHOLD || 
					Math.abs(endMousePos.y - beginMousePos.y) >= SWIP_POS_THRESHOLD))
				{
					//满足滑屏缓动条件
					SWIP_FRICTION = Math.abs(endTime - beginTime) * 0.0001;
					isSwip = true;
					swipPixel.x = (endMousePos.x - beginMousePos.x);
					swipPixel.y = (endMousePos.y - beginMousePos.y);
					
					swipDelta.x = Math.abs(swipPixel.x) * .15;
					swipDelta.y = Math.abs(swipPixel.y) * .15;
				}
				else
				{
					removeEventListener(Event.ENTER_FRAME,onUpdate);
				}
			}
		}
		
		public function onUpdate(event:Event):void
		{
			if(isSwip)
			{
				if(swipDelta.x > 0 && swipPixel.x != 0)
				{
					if(swipPixel.x < 0)
					{
						//left
						_content.x += -swipDelta.x;
						if(_content.x < _range.width)
						{
							_content.x = _range.width;
						}
					}
					else
					{
						//right
						_content.x += swipDelta.x;
						if(_content.x > _range.x)
						{
							_content.x = _range.x;
						}
					}
					
					swipDelta.x -= (swipDelta.x * SWIP_FRICTION);
				}
				
				if(swipDelta.y > 0 && swipPixel.y != 0)
				{
					if(swipPixel.y < 0)
					{
						//top
						_content.y += -swipDelta.y;
						if(_content.y < _range.height)
						{
							_content.y = _range.height;	
						}
					}
					else
					{
						//bottom
						_content.y += swipDelta.y;
						if(_content.y > _range.y)
						{
							_content.y = _range.y;
						}
					}
					swipDelta.y -= (swipDelta.y * SWIP_FRICTION);
				}
				
				if(swipDelta.x < 0 && swipDelta.y < 0)
				{
					isSwip = false;
					removeEventListener(Event.ENTER_FRAME,onUpdate);
				}
			}
			else if(isScrolling)
			{
				_content.x += (curMousePos.x - lastMousePos.x);
				_content.y +=(curMousePos.y - lastMousePos.y);
				lastMousePos.x = curMousePos.x;
				lastMousePos.y = curMousePos.y;
			}
		}
		
		public function UIScroller()
		{
			
		}
	}
}