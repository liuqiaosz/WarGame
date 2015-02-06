package lib.ui.control
{
	import framework.module.asset.AssetsManager;
	
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.textures.Texture;

	public class UIButton extends UIImage
	{
		public function UIButton()
		{
		}
		
		private var _normal:String = "";
		private var _pressed:String = "";
		
		override public function set componentXml(value:XML):void
		{
			_atlas = value.@atlas;
			_normal = value.@normal[0];
			_pressed = value.@pressed[0];	
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
		}
	}
}