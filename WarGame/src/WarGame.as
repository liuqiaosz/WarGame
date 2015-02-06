package
{
	import flash.system.Capabilities;
	
	import framework.core.GameApp;
	import framework.core.GameContext;
	import framework.device.Device;
	import framework.module.asset.AssetsManager;
	import framework.module.scene.SceneManager;
	
	import lib.ui.control.UIView;
	
	import starling.core.Starling;
	import starling.display.Image;
	import starling.display.Quad;
	import starling.textures.Texture;
	
	import wargame.asset.Assets;
	import wargame.scene.SceneIds;
	import wargame.scene.menu.SceneMenu;
	
	[SWF(frameRate="60")]
	public class WarGame extends GameApp
	{
		public function WarGame()
		{
			super({
			});
		}
		
		/**
		 * 各种初始化完成
		 **/
		override protected function gameReady():void
		{
			Starling.current.showStats = true;
			SceneManager.instance.register(SceneIds.SCENE_MENU,SceneMenu);
			
			AssetsManager.instance.addLoadQueue([Assets.getAssetNativePath("assets/slash"),"assets/data/Layout.xml"],function():void{
			
				var doc:XML = AssetsManager.instance.getXml("Layout") as XML;
				var view:UIView = new UIView();
				view.createComponent(doc);
				
				GameContext.instance.screenStage.addChild(view);
				
			});
			
		}
	}
}