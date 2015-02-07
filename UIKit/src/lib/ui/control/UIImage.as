package lib.ui.control
{
	
	import framework.module.asset.AssetsManager;
	
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
				var img:Texture = AssetsManager.instance.getUITexture(_img,_atlas);
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
					content.x = -(img.width >> 1);
					content.y = -(img.height >> 1);
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