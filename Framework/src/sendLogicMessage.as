/**
 * 全局函数
 * 
 * 快捷代理函数，发送逻辑消息
 */
package
{
	import framework.module.notification.NotificationIds;
	import framework.module.notification.NotificationManager;

	public function sendLogicMessage(id:String,params:Object = null,sync:Boolean = false):void
	{
		NotificationManager.instance.sendMessage(NotificationIds.MESSAGE_LOGIC,id,params,sync);
	}
}