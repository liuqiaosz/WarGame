package wargame.scene.battle
{
	import framework.module.scene.SceneBase;
	import framework.module.scene.vo.ViewParam;
	
	import wargame.scene.ViewIds;
	import wargame.scene.battle.view.BattleView;

	/**
	 * 战斗场景
	 * 
	 **/
	public class SceneBattle extends SceneBase
	{
		public function SceneBattle(id:String)
		{
			super(id);
		}
		
		override public function initializer():void
		{
			registerView(ViewIds.BATTLE_MAIN,BattleView);
			super.initializer();
		}
		
		override public function onShow():void
		{
			var args:ViewParam = new ViewParam();
			args.view = ViewIds.BATTLE_MAIN;
			args.anim = false;
			showView(args);
		}
		
		override public function onHide():void
		{
			
		}
	}
}