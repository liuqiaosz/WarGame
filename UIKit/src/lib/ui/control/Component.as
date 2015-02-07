package lib.ui.control
{
	import lib.ui.core.IComponent;
	import lib.ui.core.UIKit;
	
	import starling.display.Image;
	import starling.display.Quad;
	import starling.display.Sprite;
	import starling.textures.Texture;

	/**
	 * 组件基类
	 **/
	public class Component extends Sprite implements IComponent
	{
		private var _anchor:Anchor = null;
		protected var compWidth:int = 0;
		protected var compHeight:int = 0;
		public function Component()
		{
		}
		
		
		public function set anchor(value:Anchor):void
		{
			_anchor = value;
			//anchorUpdate();
		}
		
		private function anchorUpdate():void
		{
			if(_anchor)
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
		}
		
		private var _varName:String = "";
		public function getVarName():String
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
				compWidth = int(_componentXml.@width);
				compHeight = int(_componentXml.@height);
			}
			invalidate();
		}
		
		public function get componentXml():XML
		{
			return _componentXml;
		}
		
//		public function componentRender():void
//		{
//			anchorUpdate();
//		}
		
		private var _invalidate:Boolean = false;
		protected function invalidate():void
		{
			if(!_invalidate)
			{
				UIKit.instance.addInvalidate(this);
				_invalidate = true;
			}
		}
		
		public function invalidateRender():void
		{
			_invalidate = false;
			anchorUpdate();
		}
		
		private var _data:Object = null;
		public function set data(value:Object):void
		{
			_data = value;
		}
		public function get data():Object
		{
			return _data;
		}
	}
}