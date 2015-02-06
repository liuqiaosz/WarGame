package lib.ui.control
{
	
	import framework.module.asset.AssetsManager;
	
	import starling.textures.Texture;

	public class UIImage extends Component
	{
		protected var _atlas:String = "";
		protected var _img:String = "";
		public function setTexture(id:String,atlas:String = null):void
		{
			_atlas = atlas;
			_img = id;
		}
		
		public function UIImage()
		{
		}
		
		override public function set componentXml(value:XML):void
		{
			setTexture(value.@source,value.@atlas);
			super.componentXml = value;
		}
		
		override public function componentRender():void
		{
			var img:Texture = AssetsManager.instance.getUITexture(_img,_atlas);
			if(img)
			{
				texture = img;
			}
			
		}
	}
}