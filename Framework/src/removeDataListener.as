/**
 * 全局函数
 * 
 * 快捷代理函数，监听数据消息
 */
package
{
	import framework.module.notification.NotificationIds;
	import framework.module.notification.NotificationManager;
	
	public function removeDataListener(id:String,func:Function,params:Object = null):void
	{
		NotificationManager.instance.removeMessageListener(NotificationIds.MESSAGE_DATA,id,func);
	}
}