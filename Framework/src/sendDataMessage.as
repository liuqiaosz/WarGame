/**
 * 全局函数
 * 
 * 快捷代理函数，发送数据消息
 */
package
{
	import framework.module.notification.NotificationIds;
	import framework.module.notification.NotificationManager;

	public function sendDataMessage(id:String,params:Object = null):void
	{
		NotificationManager.instance.sendMessage(NotificationIds.MESSAGE_DATA,id,params);
	}
}