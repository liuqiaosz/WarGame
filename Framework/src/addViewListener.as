/**
 * 全局函数
 * 
 * 快捷代理函数，监听视图消息
 */
package
{
	import framework.module.notification.NotificationIds;
	import framework.module.notification.NotificationManager;
	
	public function addViewListener(id:String,func:Function,params:Object = null,priority:int = 0):void
	{
		NotificationManager.instance.addMessageListener(NotificationIds.MESSAGE_VIEW,id,func,params,priority);
	}
}