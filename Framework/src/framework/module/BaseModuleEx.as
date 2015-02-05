package framework.module
{
	import framework.module.notification.NotificationIds;
	import framework.module.notification.NotificationManager;

	/**
	 * 模块基类扩展，除消息模块以外的基础模块继承此类
	 * 
	 * 提供了一些消息的发送，注册接口
	 */
	public class BaseModuleEx extends BaseModule
	{
		public function BaseModuleEx()
		{
		}
		
		/**
		 * 添加视图
		 */
		protected function addViewListener(id:String,func:Function,params:Object = null):void
		{
			addMessageListener(NotificationIds.MESSAGE_VIEW,id,func,params);
		}
		
		/**
		 * 发送视图消息
		 */
		protected function sendViewMessage(id:String,params:Object = null):void
		{
			sendMessageListener(NotificationIds.MESSAGE_VIEW,id,params);
		}
		
		/**
		 * 添加视图
		 */
		protected function addLogicListener(id:String,func:Function,params:Object = null):void
		{
			addMessageListener(NotificationIds.MESSAGE_LOGIC,id,func,params);
		}
		
		/**
		 * 发送逻辑消息
		 */
		protected function sendLogicMessage(id:String,params:Object = null):void
		{
			sendMessageListener(NotificationIds.MESSAGE_LOGIC,id,params);
		}
		
		/**
		 * 添加数据消息监听
		 */
		protected function addDataListener(id:String,func:Function,params:Object = null):void
		{
			addMessageListener(NotificationIds.MESSAGE_DATA,id,func,params);
		}
		
		/**
		 * 发送框架消息
		 */
		protected function sendFrameworkMessage(id:String,params:Object = null):void
		{
			sendMessageListener(NotificationIds.MESSAGE_FRAMEWORK,id,params);
		}
		
		/**
		 * 添加框架消息监听
		 */
		protected function addFrameworkListener(id:String,func:Function,params:Object = null):void
		{
			addMessageListener(NotificationIds.MESSAGE_FRAMEWORK,id,func,params);
		}
		
		/**
		 * 发送数据消息
		 */
		protected function sendDataMessage(id:String,params:Object = null):void
		{
			sendMessageListener(NotificationIds.MESSAGE_DATA,id,params);
		}
		
		private function addMessageListener(type:int,id:String,func:Function,params:Object = null):void
		{
			NotificationManager.instance.addMessageListener(type,id,func,params);
		}
		private function sendMessageListener(type:int,id:String,params:Object = null):void
		{
			NotificationManager.instance.sendMessage(type,id,params);
		}
	}
}