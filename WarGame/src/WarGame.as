package
{
	import extension.asset.AssetsManager;
	
	import flash.events.KeyboardEvent;
	import flash.system.Capabilities;
	
	import framework.core.GameApp;
	import framework.core.GameContext;
	import framework.device.Device;
	import framework.module.scene.SceneManager;
	
	import lib.animation.core.AnimAsset;
	import lib.ui.control.UIScrollView;
	import lib.ui.control.UIView;
	
	import starling.core.Starling;
	import starling.display.Image;
	import starling.display.Quad;
	import starling.textures.Texture;
	
	import wargame.TestView;
	import wargame.asset.Assets;
	import wargame.cfg.GameConfig;
	import wargame.logic.battle.BattleLogic;
	import wargame.scene.SceneIds;
	import wargame.scene.battle.SceneBattle;
	import wargame.scene.menu.SceneMenu;
	import wargame.scene.menu.ui.MenuView;
	import wargame.scene.menu.view.ScrollTest;
	import wargame.utility.NotifyIds;
	
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
			initDirectory();
			initConfig();
			initLogic();
			
			Starling.current.showStats = true;
			
			SceneManager.instance.register(SceneIds.SCENE_MENU,SceneMenu);
			SceneManager.instance.register(SceneIds.SCENE_BATTLE,SceneBattle);
			//SceneManager.instance.changeScene(SceneIds.SCENE_MENU);
			Starling.juggler.delayCall(function():void{
				sendLogicMessage(NotifyIds.LOGIC_BATTLE_REQUEST,[1,"30001"]);
			},1);
			/**
			AssetsManager.instance.addLoadQueue([
				Assets.getUIAssetPath("comm","slash"),
				Assets.getUIAssetPath("comm","icon"),
				Assets.getUIAssetPath("comm","181001"),
				Assets.getUIAssetPath("comm","181002"),
				Assets.getUIAssetPath("comm","bg_menuitem"),
				"assets/data/MenuUI.xml"],function():void{

					var view:MenuView = new MenuView();
					view.x = GameContext.instance.getDesignPixelAspect().screenWidth >> 1;
					GameContext.instance.screenStage.addChild(view);
			});
			**/
		}
		
		private function initDirectory():void
		{
			AnimAsset.avatarDirectory = "assets/avatar";
			AnimAsset.effectDirectory = "assets/effect";
			
			CONFIG::debug
			{
				AnimAsset.isDebug = true;
			}
		}
		
		private function initLogic():void
		{
			BattleLogic.instance.initializer();
		}
		
		private function initConfig():void
		{
			GameConfig.instance.loadConfig(null);
		}
	}
}
