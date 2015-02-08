package wargame.scene.menu.view
{
	import framework.module.asset.AssetsManager;
	import framework.module.scene.SceneViewBase;
	
	import starling.display.Quad;
	
	import wargame.asset.Assets;
	import wargame.scene.menu.ui.MenuView;

	public class ViewMainMenu extends SceneViewBase
	{
		private var _view:MenuView = null;
		
		public function ViewMainMenu()
		{
			super([
				Assets.getUIAssetPath("comm","bg_menuitem"),
				"assets/data/MenuUI.xml"
			]);
		}
		
		override public function onShow():void
		{
			
		}
		
		/**
		 * 资源加载完成
		 **/
		override protected function onResourceLoadComplete():void
		{
			if(!_view)
			{
				_view = new MenuView();
				_view.onSelect = function():void{
				
					trace("!!");
					_view.fadeFlyOut();
				};
				addChild(_view);
			}
		}
	}
}