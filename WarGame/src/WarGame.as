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
	
	import wargame.TestView;
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
			
			AssetsManager.instance.addLoadQueue([
				Assets.getUIAssetPath("comm","slash"),
				Assets.getUIAssetPath("comm","icon"),
				Assets.getUIAssetPath("comm","181001"),
				Assets.getUIAssetPath("comm","181002"),
				"assets/data/Layout.xml"],function():void{
			
					var doc:XML = AssetsManager.instance.getXml("Layout") as XML;
					var view:TestView = new TestView();
					view.createComponent(doc.component[0]);
					view.btn.onSelect = function():void{
						trace("!");
					};
				//var tx:Texture = AssetsManager.instance.getTexture("slash");
				//view.addChild(new Image(tx));
				GameContext.instance.screenStage.addChild(view);
				
			});
			
		}
	}
}