/**
 * 全局函数
 * 
 * 快捷代理函数，发送视图消息
 */
package
{
	import framework.module.notification.NotificationIds;
	import framework.module.notification.NotificationManager;

	public function sendViewMessage(id:String,params:Object = null,sync:Boolean = false):void
	{
		NotificationManager.instance.sendMessage(NotificationIds.MESSAGE_VIEW,id,params,sync);
	}
}