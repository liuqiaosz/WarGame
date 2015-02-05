package framework.core
{
	import flash.utils.getTimer;
	
	import framework.module.notification.NotificationIds;
	import framework.module.notification.NotificationManager;
	
	import starling.core.Starling;
	import starling.display.Sprite;
	import starling.events.Event;
	
	public class StarlingGame extends Sprite
	{
		use namespace FrameworkNS;
		public function StarlingGame()
		{
			addEventListener(Event.ADDED_TO_STAGE,onAdded);
		}
		
		private function onAdded(event:Event):void
		{
			stage.color = 0x000000;
			
			removeEventListener(Event.ADDED_TO_STAGE,onAdded);
			
			//启动成功消息发送
			NotificationManager.instance.sendMessage(NotificationIds.MESSAGE_FRAMEWORK,NotificationIds.MSG_FMK_START_COMPLETE);
			addEventListener(Event.ENTER_FRAME,onEnterFrame);
			GameContext.instance.screenStage = this;
		}
		
		private function onEnterFrame(event:Event):void
		{
			var t:Number = flash.utils.getTimer();
			NotificationManager.instance.sendMessage(NotificationIds.MESSAGE_FRAMEWORK,NotificationIds.MSG_FMK_FRAME_UPDATE,t);
			NotificationManager.instance.update(t);
		}
	}
}