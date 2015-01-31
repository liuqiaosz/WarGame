package framework.core
{
	import flash.utils.getTimer;
	
	import framework.module.msg.MessageConstants;
	import framework.module.msg.MessageManager;
	
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
			MessageManager.instance.sendMessage(MessageConstants.MESSAGE_FRAMEWORK,MessageConstants.MSG_FMK_START_COMPLETE);
			addEventListener(Event.ENTER_FRAME,onEnterFrame);
			GameContext.instance.screenStage = this;
		}
		
		private function onEnterFrame(event:Event):void
		{
			var t:Number = flash.utils.getTimer();
			MessageManager.instance.sendMessage(MessageConstants.MESSAGE_FRAMEWORK,MessageConstants.MSG_FMK_FRAME_UPDATE,t);
			MessageManager.instance.update(t);
		}
	}
}