package lib.ui.control
{
	import flash.geom.Point;
	
	import framework.module.asset.AssetsManager;
	
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.textures.Texture;

	public class UIButton extends UIImage
	{
		public function UIButton()
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
				if(_isToggle)
				{
					_selected = !_selected;
					if(_selected)
					{
						if(null != selectFunc)
						{
							selectFunc();
						}
					}
				}
				else
				{
					texture = _pressedTex;
				}
				return;
			}
			
			_touch = event.getTouch(this,TouchPhase.MOVED);
			if(_touch)
			{
				if(!isInBounds(_touch))
				{
					_selected = false;
					texture = _normalTex;
				}
				return;
			}
			_touch = event.getTouch(this,TouchPhase.ENDED);
			if(_touch && !_isToggle)
			{
				if(isInBounds(_touch))
				{
					if(null != selectFunc)
					{
						selectFunc();
					}
				}
				texture = _normalTex;
			}
		}
		
		private var _normal:String = "";
		private var _pressed:String = "";
		override public function set componentXml(value:XML):void
		{
			_atlas = value.@atlas;
			_normal = value.normal.toString();
			_pressed = value.pressed.toString();	
			super.componentXml = value;
		}
		
		private var _normalTex:Texture = null;
		private var _pressedTex:Texture = null;
		override public function componentRender():void
		{
			_normalTex = AssetsManager.instance.getUITexture(_normal,_atlas);
			_pressedTex = AssetsManager.instance.getUITexture(_pressed,_atlas);
			
			if(_normalTex)
			{
				texture = _normalTex;
			}
			super.componentRender();
		}
		
		private var _isToggle:Boolean = false;
		public function set isToggle(value:Boolean):void
		{
			_isToggle = value;
		}
		public function get isToggle():Boolean
		{
			return _isToggle;
		}
		
		private var _selected:Boolean = false;
		public function set selected(value:Boolean):void
		{
			if(_isToggle)
			{
				_selected = value;
				if(_selected)
				{
					if(_pressedTex)
					{
						texture = _pressedTex;
					}
				}
				else
				{
					if(_normalTex)
					{
						texture = _normalTex;
					}
				}
			}
		}
		
		public function get selected():Boolean
		{
			return _selected;
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