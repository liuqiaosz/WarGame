/**
 *  水平滑动列表: 滚动过程中交替放大缩小
 */

package morn.core.components.touch
{
	import flash.display.DisplayObject;
	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.sampler.getSize;
	
	import morn.core.components.Box;
	import morn.core.components.IItem;
	import morn.core.events.UIEvent;
	import morn.core.handlers.Handler;
	import morn.editor.core.IList;
	
	import starling.events.Event;
	
	/**选择单元格改变后触发*/
	[Event(name="select",type="starling.events.Event")]
	/**单元格渲染时触发*/
	[Event(name="listRender",type="morn.core.events.UIEvent")]
	
	public class HScrollList extends Box implements IList, IItem
	{
		/**
		 * @property 第一个Item的放大比例
		 */
		private var _maxScale:Number = 1.0;
		public function get maxScale():Number
		{
			return _maxScale;
		}
		public function set maxScale(value:Number):void
		{
			if(value <= 1.0)
				value = 1.0;
			
			_maxScale = value;
		}
		
		/**
		 * @property 水平方向两个item的间隔
		 */
		private var _sepW:Number = 0.0;
		public function get sepW():Number
		{
			return _sepW;
		}
		public function set sepW(value:Number):void
		{
			_sepW = value;
		}
		
		/**
		 * 可见区域的高
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
		 * 可见区域的宽
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
			
			createItems();
			
			refreshItems(true);
		}
		
		/**
		 * Item的宽度
		 */
		public var itemWidth:Number = 0;
		
		/**
		 * 所有Item数组
		 */
		private var _model:Array = null;
		public function set model(value:Array):void
		{
			if(_model == null)
			{
				_model = value;
				updateItemNow();
			}
		}
		public function get model():Array
		{
			return _model;
		}
		
		/**
		 * 可见Item数组
		 */
		public var items:Array = [];
		
		/**
		 * 当前第一个Item索引
		 */
		private var _firstindex:int = 0;
		
		/**
		 * 可见区域的Item数量
		 */
		private var _itemCount:int = 0;
		public function get itemCount():int
		{
			var hasHalfItem:int = 0;	
			if((showWidth + sepW) % (itemWidth + sepW) != 0)
			{
				hasHalfItem = 1;
			}
			
			_itemCount = int((showWidth + sepW) / (itemWidth + sepW)) + hasHalfItem + 1;
			return _itemCount;
		}
		
		/**
		 * 单元格渲染器，可以设置为XML或类对象
		 */
		protected var _itemRender:*;
		public function get itemRender():*
		{
			return _itemRender;
		}
		public function set itemRender(value:*):void
		{
			_itemRender = value;
		}
		
		/**
		 * List的总宽高
		 */
		protected var _contentSize:Rectangle = new Rectangle();
		public function getSize():Rectangle
		{
			_contentSize.width = _model ? (_model.length * (itemWidth + sepW) - sepW) : 0;
			_contentSize.height = _showHeight;
			return _contentSize;
		}
		
		/**
		 * 可见区域第一个可见Item的index
		 */
		public function get firstindex():int
		{
			var sx:Number = -x;
			return int( sx / (itemWidth + sepW));
		}
		
		/**
		 * 当前选中的ItemIndex
		 */
		public var _selectedIndex:int = 0;
		
		/**
		 * 上次可见区域第一个可见Item的index
		 */
		private var oldFirstIndex:int = -10;
		
		/**
		 * 水平方向滚动的位置
		 */
		public function set gridX(value:Number):void
		{
			x = -value;
			updateItem(false);
		}
		public function get gridX():Number
		{
			return -x;
		}
		
		/**
		 * 构造函数
		 */
		public function HScrollList()
		{
			//
		}
		
		/**
		 * 初始化Item
		 */
		public function initItems():void
		{
			//
		}
		
		public function createItems():void
		{
			//销毁老单元格
			var cell:Box = null;
			for each (cell in items)
			{
				cell.remove();
			}
			items.length = 0;
			
			if(!_itemRender)
			{
				cell = getChildByName("item0") as Box;
				if (cell)
				{
					items.push(cell);
					itemWidth = cell.width;
				}
				
				for (var i:int = 1; i < itemCount; i++)
				{
					cell = getChildByName("item" + i) as Box;
					if (cell)
					{
						items.push(cell);
						continue;
					}
					break;
				}
			}
			
			items[0].scaleX = _maxScale;
			items[0].scaleY = _maxScale;
		}
		
		/**
		 * 刷新Item
		 */
		protected function refreshItems(changeData:Boolean=true):void
		{	
			if (!_model || _model.length <= 0)
			{
				return;
			}
			
			var item:*;
			for(var i:uint=0; i < itemCount; i++)
			{
				item = items[i];
				if (item)
				{
					if(_model.length > i + firstindex)
					{
						if(changeData)
						{
							//item.show(_model[firstindex + i]);
							moveItem(item, i);
						}
						//item.selected = (firstindex + i == _model.selectedIndex);
					}
					else
					{
						//item.hide();
					}
				}
			}
			oldFirstIndex = firstindex;
		}
		
		/**
		 * 设置item的位置
		 */
		protected function moveItem(item:*, i:int):void
		{
			var tempScale:Number = Math.abs(gridX - firstindex * (itemWidth + sepW));
			tempScale = tempScale/itemWidth * (_maxScale - 1);
			if(tempScale > (_maxScale - 1))
			{
				tempScale = (_maxScale - 1);
			}
			
			if(i == 0)
			{
				//item.zoom(_maxScale - tempScale, _maxScale - tempScale);
				item.scaleX = _maxScale - tempScale;
				item.scaleY = _maxScale - tempScale;
				
				item.x = (i + firstindex) * (itemWidth + sepW);
			}
			else if(i == 1)
			{
				//item.zoom(1.0 + tempScale, 1.0 + tempScale);
				item.scaleX = 1.0 + tempScale;
				item.scaleY = 1.0 + tempScale;
				
				item.x = items[0].width*items[0].scaleX + sepW + (i + firstindex - 1) * (itemWidth + sepW);
			}
			else
			{
				item.scaleX = 1.0;
				item.scaleY = 1.0;
				
				item.x = items[0].width*items[0].scaleX + items[1].width*items[1].scaleX + 2 * sepW + (i + firstindex - 2) * (itemWidth + sepW);
			}
			
			item.y = showHeight - item.height*item.scaleY;
		}
		
		public function updateItem(checkFirstIndex:Boolean=true):void
		{	
			if (oldFirstIndex == firstindex && checkFirstIndex)
			{
				return;
			}
			
			updateItemNow();
		}
		
		protected function updateItemNow():void
		{
			//如果向上滚动一个item，不需要全部刷新内容，只需要把第一个元素放到最后就可以了
			if (oldFirstIndex == firstindex - 1)
			{
				items.push(items.shift());
			}//同理，向下滚动一个item
			else if (oldFirstIndex == firstindex + 1)
			{
				items.unshift(items.pop());
			}
			refreshItems();
		}
		
		/**
		 * @public
		 */
		public function getItemX(realIndex:int):Number
		{
			if(realIndex >= 0 && realIndex < _model.length)
			{
				return realIndex * (itemWidth + sepW)
			}
			
			return 0;
		}
	}
}