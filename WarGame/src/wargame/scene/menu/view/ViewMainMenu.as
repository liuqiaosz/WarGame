package wargame.scene.menu.view
{
	import framework.module.asset.AssetsManager;
	import framework.module.scene.SceneViewBase;
	
	import wargame.asset.Assets;

	public class ViewMainMenu extends SceneViewBase
	{
		public function ViewMainMenu()
		{
			
		}
		
		/**
		 * 资源加载完成
		 **/
		override protected function onResourceLoadComplete():void
		{
			var data:Object = AssetsManager.instance.getObject("Layout"); 
			trace("");
		}
		
		override public function getResource():Array
		{
			return [Assets.getAssetNativePath("assets/slash"),"assets/data/Layout.xml"];
		}
	}
}