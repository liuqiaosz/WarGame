package lib.ui.control
{
	
	import framework.module.asset.AssetsManager;
	
	import starling.display.Image;
	import starling.textures.Texture;

	public class UIImage extends Component
	{
		private var content:Image = null;
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
		
		override public function componentRender():void
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
				}
			}
			super.componentRender();
		}
		
		public function set texture(value:Texture):void
		{
			if(value)
			{
				if(!content)
				{
					content = new Image(value);
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