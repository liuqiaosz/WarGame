package morn.core.components.touch
{
	import flash.geom.*;
	import flash.ui.Keyboard;
	import flash.utils.getTimer;
	
	import morn.core.components.Container;
	import morn.core.components.IItem;
	import morn.core.components.touch.HScrollList;
	
	import starling.display.DisplayObject;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	
	public class HScrollPane extends Container implements IItem
	{
		/**
		 * @property 可见区域的宽
		 */
		private var _bg:Sprite = null;
		private var _showBg:Boolean = false;
		public function get showBg():Boolean
		{
			return _showBg;
		}
		public function set showBg(value:Boolean):void
		{
			_showBg = value;
			
			if(_showBg)
			{
//				_bg = new Sprite();
//				_bg.graphics.beginFill(0x000000, 1.0);
//				_bg.graphics.drawRect(0, 0, width, height);
//				_bg.graphics.endFill();
//				addChildAt(_bg, 0);
			}
			else
			{
				if(_bg)
				{
					removeChild(_bg);
					_bg = null;
				}
			}
		}
		
		/**
		 * @property 可见区域的高
		 */
		private var _showHeight:Number = 0;
		public function get showHeight():Number
		{
			return _showHeight;
		}
		public function set showHeight(value:Number):void
		{
			_showHeight = value;
			height = _showHeight;
		}
		
		/**
		 * @property 可见区域的宽
		 */
		private var _showWidth:Number = 0;
		public function get showWidth():Number
		{
			return _showWidth;
		}
		public function set showWidth(value:Number):void
		{
			_showWidth = value;
			width = _showWidth;
			
//			if(scrollRect != null)
//			{
//				scrollRect = null;
//			}
//			scrollRect = new Rectangle(0, 0, width, height);
			
			if(content)
			{
				setContentShowSize(width, height);
			}
		}
		
		public function set model(value:Array):void
		{
			if(content)
			{
				content.model = value;
				updateHorMaxScrollPosition();
			}
		}
		
		/**
		 * 最小的滑动距离
		 */
		private var _minScrollPositionX:Number = 0;
		public function get minHorizontalScrollPosition():int 
		{
			return _minScrollPositionX;
		}
		
		/**
		 * 最大的滑动距离
		 */
		private var _maxScrollPositionX:Number = 0;
		public function get maxHorizontalScrollPosition():int 
		{
			return _maxScrollPositionX;
		}
		public function updateHorMaxScrollPosition():void
		{
			_minScrollPositionX = 0;
			if(content != null)
			{
				_maxScrollPositionX = Math.max(getContentWidth() - content.itemWidth, _minScrollPositionX);
			}
		}
		private function getContentWidth():Number
		{
			if(content != null)
			{
				return content.getSize().width;
			}
			return 0;
		}
		
		public function setScrollPositionX(newScrollPosition:Number):void
		{
			var oldPosition:Number = getGridX();
			
			newScrollPosition = Math.max(_minScrollPositionX,Math.min(_maxScrollPositionX, newScrollPosition));
			if (oldPosition == newScrollPosition)
				return;
			
			setGridX(newScrollPosition);
		}
		
		/**
		 * 水平滑动列表
		 */
		private var content:HScrollList = null;
		
		public function HScrollPane()
		{
			addEventListener(Event.ADDED_TO_STAGE, addListener);
		}
		
		public function initItems():void
		{
			content = getChildByName("scrollList") as HScrollList;
			
			showWidth = width;
			showHeight = height;
		}
		
		/**
		 * dispose need override
		 */
		override public function dispose():void
		{
			removeEventListener(Event.ADDED_TO_STAGE, addListener);
			removeEventListener(Event.REMOVED_FROM_STAGE, onRemove);
			removeEventListener(Event.ENTER_FRAME, update);
			removeEventListener(TouchEvent.TOUCH, onStartDrag);
			
			if(stage != null)
			{
				stage.removeEventListener(TouchEvent.TOUCH, onMoveDrag);
				stage.removeEventListener(TouchEvent.TOUCH, onStopDrag);
			}
			
			if(this.numChildren > 0)
			{
				this.removeChildren();
			}
			
			if(this.parent != null)
			{
				this.parent.removeChild(this);
			}
		}
		
		/**
		 * 重写onResize
		 */
		override protected function onResize(e:Event):void {
			super.onResize(e);
			
			if(content)
			{
				setContentShowSize(width, height);
			}
		}
		protected function setContentShowSize(width:Number, height:Number):void 
		{
			content.showHeight = height;
			content.showWidth = width;
		}
		
		//{touch vars
		protected var oldMouse:int = 0;
		protected var currentMouse:int = 0;
		protected var startMouse:int = 0;
		protected var speed:Number=0;
		
		protected var isMove:Boolean = false;
		protected var isSlide:Boolean = false;
		protected var isAutoRoll:Boolean = false;
		
		protected var startIndex:int = 0;
		protected var endIndex:int = 0;
		
		protected var rollTimes:int = -1;
		
		/**
		 * @public
		 */
		public function setGridX(value:Number):void
		{
			content.gridX = value;
		}
		/**
		 * @public
		 */
		public function getGridX():Number
		{
			return content.gridX;
		}
		
		/**
		 * @private
		 */
		protected function getContentHeight():Number
		{
			return content.getSize().height;
		}
		/**
		 * @private
		 */
		protected function getContentShowWidth():Number
		{
			return content.showWidth;
		}
		/**
		 * @private
		 */
		protected function getContentShowHeight():Number
		{
			return content.showHeight;
		}
		
		//{touch operation
		protected function addListener(event:Event = null):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, addListener);
			addEventListener(Event.REMOVED_FROM_STAGE, onRemove);
			addEventListener(Event.ENTER_FRAME, update);
			
			addEventListener(TouchEvent.TOUCH, onStartDrag);
		}
		
		protected function onRemove(event:Event = null):void
		{
			addEventListener(Event.ADDED_TO_STAGE, addListener);
			removeEventListener(Event.ENTER_FRAME, update);
			
			removeEventListener(TouchEvent.TOUCH, onStartDrag);
		}
		
		protected function onStartDrag(event:TouchEvent):void
		{
			var touch:Touch = event.getTouch(event.currentTarget as DisplayObject, TouchPhase.BEGAN);
			if(touch)
			{
				oldMouse = event.data[0].globalX;
				currentMouse = oldMouse;
				startMouse = oldMouse;
				isMove = true;
				isSlide = false;
				isAutoRoll = false;
				stage.addEventListener(TouchEvent.TOUCH, onMoveDrag);
				stage.addEventListener(TouchEvent.TOUCH, onStopDrag);
			}
		}
		
		private var ptHelper:Point = new Point();
		protected function onStopDrag(event:TouchEvent):void
		{
			var touch:Touch = event.getTouch(event.currentTarget as DisplayObject, TouchPhase.ENDED);
			if(touch)
			{
				stage.removeEventListener(TouchEvent.TOUCH, onMoveDrag);
				stage.removeEventListener(TouchEvent.TOUCH, onStopDrag);
				
				if (isMove) 
				{
					isMove = false;
					
					if (checkLocal())
					{
						speed = 0;
						isSlide = false;
					}
					else
					{
						speed = speed * 1.5;
						isSlide = true;
					}
				}
			}
		}
		
		protected function onMoveDrag(event:TouchEvent):void
		{
			var touch:Touch = event.getTouch(event.currentTarget as DisplayObject, TouchPhase.MOVED);
			if(touch)
			{
				currentMouse = event.data[0].globalX;
			}
		}
		
		public function update(event:Event):void
		{
			if (!stage && !content.itemCount) 
			{
				return;
			}
			
			if (isMove)
			{
				speed = oldMouse - currentMouse;
			}
			else if (isSlide) 
			{
				speed = speed * 0.8;
				if(checkLocal())
				{
					speed = 0;
					isSlide = false;
				}
				else if (speed < 5 && speed > -5)
				{
					speed = 0;
					roll();
					isSlide = false;
					return;
				}
			}
			else if (isAutoRoll)
			{
				rollTimes = rollTimes - 1;
				if (rollTimes == -1) 
				{
					speed = 0;
					isAutoRoll = false;
					
					//adjust
					var toPos:Number = content.getItemX(_rollToIndex);
					if(toPos - getGridX() != 0)
					{
						setScrollPositionX(toPos);
					}
					_rollToIndex = 0;
				}
			}
			
			if (speed != 0) 
			{
				moveList();
			}
			
			if (isMove) 
			{
				oldMouse = currentMouse;
			}
		}
		
		protected function moveList():void
		{
			if(content == null)
			{
				return;
			}
			
			if (!content.itemCount) 
			{
				return;
			}
			
			var start:Number = getGridX();
			setScrollPositionX(start + speed);
		}
		
		protected function checkLocal():Boolean
		{
			var bRet:Boolean=false;
			if (!content.itemCount) 
			{
				return true;
			}
			
			var start:Number = getGridX();
			if ((start <= _minScrollPositionX && speed < 0)
				|| (start >= _maxScrollPositionX && speed > 0)) 
			{
				bRet = true;
			}
				
			return bRet;
		}
		
		private var _rollToIndex:int = 0;
		protected function roll():void
		{
			if (!content.itemCount)
			{
				return;
			}
			
			rollToIndex(content.firstindex);
		}
		
		public function rollToItem(item:*):void
		{
			if(item != null)
			{
				var toindex:int = content.items.indexOf(item) + content.firstindex;
				rollToIndex(toindex, 60);
			}
		}
		
		protected function rollToIndex(toindex:int, rollSpeed:int = 10):void
		{
			if (!content.itemCount || toindex < 0 || toindex >= content.model.count)
			{
				return;
			}
			
			var dist:Number=0;
			var start:Number = getGridX();
			_rollToIndex = toindex;
			var toPos:Number = content.getItemX(_rollToIndex);
			
			if(toPos + content.itemWidth / 2.0 < start)
			{
				_rollToIndex++;
			}
			
			if(_rollToIndex < content.model.length)
			{
				toPos = content.getItemX(_rollToIndex);
				dist = toPos - start;
			}
			
			if (dist != 0) 
			{
				rollTimes = int(dist / rollSpeed);
				rollTimes = rollTimes < 0 ? -rollTimes : rollTimes;
				rollTimes = rollTimes + (dist % rollSpeed != 0 ? 1 : 0);
				speed = dist / rollTimes;
				isMove = false;
				isSlide = false;
				isAutoRoll = true;
			}
		}
	}
}