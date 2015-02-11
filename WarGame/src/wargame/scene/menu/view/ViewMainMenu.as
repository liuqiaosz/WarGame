package wargame.scene.menu.view
{
	import flash.events.KeyboardEvent;
	
	import framework.core.GameContext;
	import extension.asset.AssetsManager;
	import framework.module.scene.SceneViewBase;
	
	import lib.animation.avatar.Avatar;
	import lib.animation.avatar.AvatarManager;
	
	import starling.display.Quad;
	
	import wargame.asset.Assets;
	import wargame.scene.menu.ui.MenuView;
	import wargame.utility.NotifyIds;

	public class ViewMainMenu extends SceneViewBase
	{
		private var _view:MenuView = null;
		
		public function ViewMainMenu(id:String)
		{
			super(id,[
				Assets.getUIAssetPath("comm","bg_menuitem"),
				"assets/data/MenuUI.xml"
			]);
		}
		
		override public function onShow():void
		{
			CONFIG::debug
			{
				
				GameContext.instance.flashStage.addEventListener(KeyboardEvent.KEY_DOWN,function(event:KeyboardEvent):void{
					sendLogicMessage(NotifyIds.LOGIC_BATTLE_REQUEST,[1,"30001"]);
				});
			}
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
					_view.fadeFlyOut();
				};
				addChild(_view);
			}
		}
	}
}