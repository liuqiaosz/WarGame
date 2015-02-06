package wargame.scene.menu
{
	import framework.module.scene.SceneBase;
	
	import wargame.scene.ViewIds;
	import wargame.scene.menu.view.ViewMainMenu;

	/**
	 * 菜单场景
	 * 
	 **/
	public class SceneMenu extends SceneBase
	{
		public function SceneMenu(id:String)
		{
			super(id);
		}
		
		override public function initializer():void
		{
			this.registerView(ViewIds.MENU_MAINMENU,ViewMainMenu);
			super.initializer();
		}
	}
}