package lib.ui.control
{
	import flash.geom.Point;
	
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.textures.Texture;
	
	/**
	 * 使用单张图片用缩放作为效果的按钮
	 * 
	 **/
	public class UIScaleButton extends UIImage
	{
		private var _scale:Number = 1;
		
		public function UIScaleButton()
		{
			addEventListener(TouchEvent.TOUCH,onTouch);
		}
		
		private var _pos:Point = new Point();
		private var _touch:Touch = null;
		private var _clipLock:Boolean = false;
		private function onTouch(event:TouchEvent):void
		{
			_touch = event.getTouch(this,TouchPhase.BEGAN);
			if(_touch)
			{
				scaleX = scaleY = _scale;
				return;
			}
			
			_touch = event.getTouch(this,TouchPhase.MOVED);
			if(_touch)
			{
				if(!isInBounds(_touch))
				{
					scaleX = scaleY = 1;
				}
				return;
			}
			_touch = event.getTouch(this,TouchPhase.ENDED);
			if(_touch)
			{
				scaleX = scaleY = 1;
				if(isInBounds(_touch))
				{
					if(null != selectFunc)
					{
						selectFunc(this);
					}
				}
			}
		}
		
		override public function set componentXml(value:XML):void
		{
			_scale = Number(value.@scale);
			if(_scale <= 0)
			{
				_scale = 1;
			}
			super.componentXml = value;
		}
		
		
		
		override public function dispose():void
		{
			removeEventListener(TouchEvent.TOUCH,onTouch);
			super.dispose();
		}
		
		private function isInBounds(touch:Touch):Boolean
		{
			_pos.x = _touch.globalX;
			_pos.y = _touch.globalY;
			_pos = globalToLocal(_pos);
			return (hitTest(_pos) != null);
		}
		
		private var selectFunc:Function = null;
		public function set onSelect(value:Function):void
		{
			selectFunc = value;
		}
	}
}