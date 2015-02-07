package
{
	import flash.system.Capabilities;
	
	import framework.core.GameApp;
	import framework.core.GameContext;
	import framework.device.Device;
	import framework.module.asset.AssetsManager;
	import framework.module.scene.SceneManager;
	
	import lib.ui.control.UIScrollView;
	import lib.ui.control.UIView;
	
	import starling.core.Starling;
	import starling.display.Image;
	import starling.display.Quad;
	import starling.textures.Texture;
	
	import wargame.TestView;
	import wargame.asset.Assets;
	import wargame.scene.SceneIds;
	import wargame.scene.menu.SceneMenu;
	import wargame.scene.menu.ui.MenuView;
	import wargame.scene.menu.view.ScrollTest;
	
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
			
			SceneManager.instance.changeScene(SceneIds.SCENE_MENU);
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
			*/
		}
	}
}
import lib.ui.control.IRenderer;

import starling.display.Quad;
import starling.display.Sprite;

class Item extends Sprite implements IRenderer
{
	public function Item()
	{
		var cube:Quad = new Quad(150,150,0xff0000);
		addChild(cube);
	}
	
	public function set data(value:Object):void
	{
		
	}
	private var _index:int = 0;
	public function set index(value:int):void
	{
		_index = value;
	}
	public function get index():int
	{
		return _index;
	}
}