package lib.ui.control
{
	
	import extension.asset.AssetsManager;
	
	import starling.display.Image;
	import starling.textures.Texture;

	public class UIImage extends Component
	{
		protected var content:Image = null;
		protected var _atlas:String = "";
		protected var _img:String = "";
		public function setTexture(id:String,atlas:String = null):void
		{
			_atlas = atlas;
			_img = id;
		}
		
		private static var Empty:Texture = Texture.empty(1,1);
		public function UIImage()
		{
			super();
			
			_anchorX = _anchorY = 0.5;
		}
		
		override public function set componentXml(value:XML):void
		{
			setTexture(value.@source,value.@atlas);
			super.componentXml = value;
		}
		
		override public function invalidateRender():void
		{
			if(_img)
			{
				var img:Texture = AssetsManager.instance.getTextureFromAtlas(_atlas,_img);
				if(img)
				{
					if(!content)
					{
						content = new Image(img);
						addChild(content);
					}
					else
					{
						content.texture = img;
					}
					
					if(_anchorX > 0)
					{
						content.x = -(img.width * _anchorX);
					}
					else
					{
						content.y = 0;
					}
					
					if(_anchorY > 0)
					{
						content.y = -(img.height * _anchorY);
					}
					else
					{
						content.y = 0;
					}
				}
			}
			super.invalidateRender();
		}
		
		public function set texture(value:Texture):void
		{
			if(value)
			{
				if(!content)
				{
					content = new Image(value);
					content.x = -(value.width >> 1);
					content.y = -(value.height >> 1);
					addChild(content);
				}
				else
				{
					content.texture = value;
				}
			}
		}
	}
}