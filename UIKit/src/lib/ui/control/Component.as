package lib.ui.control
{
	import lib.ui.core.IComponent;
	
	import starling.display.Image;
	import starling.textures.Texture;

	/**
	 * 组件基类
	 **/
	public class Component extends Image implements IComponent
	{
		private static var Empty:Texture = Texture.empty(1,1);
		private var _anchor:Anchor = null;
		private var _navTexture:Texture = null;
		public function set source(value:Texture):void
		{
			_navTexture = value;
			if(_navTexture)
			{
				this.texture = _navTexture;
			}
		}
		public function Component()
		{
			super(Empty);
		}
		
		public function set anchor(value:Anchor):void
		{
			_anchor = value;
			anchorUpdate();
		}
		
		private function anchorUpdate():void
		{
			if(_anchor.left || _anchor.top || _anchor.right || _anchor.bottom)
			{
				if(_anchor.left)
				{
					x = _anchor.left;
				}
				else if(_anchor.right)
				{
					if(parent)
					{
						x = parent.width - _anchor.right;
					}
				}
				
				if(_anchor.top)
				{
					y = _anchor.top;
				}
				else if(_anchor.bottom)
				{
					if(parent)
					{
						y = parent.height - _anchor.bottom;
					}
				}
			}
		}
		
		private var _varName:String = "";
		public function get varName():String
		{
			return _varName;
		}
		
		private var _componentXml:XML = null;
		public function set componentXml(value:XML):void
		{
			_componentXml = value;
			if(_componentXml)
			{
				var str:String;
				var args:Array = null;
				str = _componentXml.@anchor;
				if(str)
				{
					str = _componentXml.@anchor;
					args = str.split(",");
					if(args.length >= 4)
					{
						anchor = new Anchor(args[0],args[1],args[2],args[3]);
					}
				}
				else
				{
					str = _componentXml.@posx;
					if(str)
					{
						x = int(str);
					}
					str = _componentXml.@posy;
					if(str)
					{
						y = int(str);
					}
				}
				_varName = _componentXml.@varname;
			}
		}
		
		public function get componentXml():XML
		{
			return _componentXml;
		}
		
		public function componentRender():void
		{
			
		}
	}
	
}