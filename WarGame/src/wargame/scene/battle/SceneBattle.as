package wargame.scene.battle
{
	import framework.module.notification.NotificationIds;
	import framework.module.notification.NotificationManager;
	import framework.module.scene.SceneBase;
	import framework.module.scene.vo.ViewParam;
	
	import wargame.logic.battle.BattleLogic;
	import wargame.scene.ViewIds;
	import wargame.scene.battle.view.BattleLoadView;
	import wargame.scene.battle.view.BattleView;
	import wargame.utility.NotifyIds;

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
			registerView(ViewIds.BATTLE_LOAD,BattleLoadView);
			registerView(ViewIds.BATTLE_MAIN,BattleView);
		
			super.initializer();
		}
		
		
		override public function onShow():void
		{
			addLogicListener(NotifyIds.LOGIC_BATTLE_ENTER,onBattleEnter);
			addLogicListener(NotifyIds.LOGIC_BATTLE_RES_ERR,onResourceError);
			addLogicListener(NotifyIds.LOGIC_BATTLE_READY,onBattleReady);
			super.onShow();
		}
		
		/**
		 * 资源准备异常
		 **/
		private function onResourceError(param:Object = null):void
		{
			debug("战斗初始化资源异常");
		}
		
		override public function onHide():void
		{
			removeLogicListener(NotifyIds.LOGIC_BATTLE_ENTER,onBattleEnter);
			removeLogicListener(NotifyIds.LOGIC_BATTLE_RES_ERR,onResourceError);
			removeLogicListener(NotifyIds.LOGIC_BATTLE_READY,onBattleReady);
			super.onHide();	
		}
		
		/**
		 * 战斗数据准备完成，进入资源准备界面
		 **/
		private function onBattleEnter(param:Object = null):void
		{
			var args:ViewParam = new ViewParam();
			args.view = ViewIds.BATTLE_LOAD;
			args.anim = false;
			args.data = param;
			showView(args);
		}
		
		/**
		 * 战斗资源准备完成，进入战场
		 **/
		private function onBattleReady(param:Object = null):void
		{
			var args:ViewParam = new ViewParam();
			args.view = ViewIds.BATTLE_MAIN;
			args.anim = false;
			sendViewMessage(NotificationIds.MSG_VIEW_SHOWVIEW,args);
			
			args = new ViewParam();
			args.view = ViewIds.BATTLE_LOAD;
			args.anim = false;
			sendViewMessage(NotificationIds.MSG_VIEW_HIDEVIEW,args);
		}
	}
}