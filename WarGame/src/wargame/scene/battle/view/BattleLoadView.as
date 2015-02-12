package wargame.scene.battle.view
{
	import extension.asset.AssetsManager;
	
	import framework.module.scene.SceneViewBase;
	
	import wargame.utility.NotifyIds;

	/**
	 * 进入战斗资源预加载界面
	 * 
	 * 界面使用使用的素材在整个游戏周期都一直缓存所以这里不需要加载直接进入
	 **/
	public class BattleLoadView extends SceneViewBase
	{
		public function BattleLoadView(id:String)
		{
			super(id);
		}
		
		override public function onShow():void
		{
			beginLoadResource(data as Array);
			super.onShow();
		}
		
		override public function onHide():void
		{
			super.onHide();
		}
		
		private function beginLoadResource(resource:Array):void
		{
//			if(!resource)
//			{
//				debug("初始化资源异常");
//				sendLogicMessage(NotifyIds.LOGIC_BATTLE_RES_ERR);
//				return;
//			}
//			AssetsManager.instance.addLoadQueue(resource,onComplete,onProgress);
			sendLogicMessage(NotifyIds.LOGIC_BATTLE_READY);
		}
		
		/**
		 * 更新加载进度
		 **/
		private function onProgress(ratio:Number):void
		{
			
		}
		
		/**
		 * 素材准备结束
		 **/
		private function onComplete():void
		{
			sendLogicMessage(NotifyIds.LOGIC_BATTLE_BEGIN);
		}
	}
}