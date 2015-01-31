/**
 * 全局函数
 * 
 * 快捷代理函数，监听数据消息
 */
package
{
	import framework.module.msg.MessageConstants;
	import framework.module.msg.MessageManager;
	
	public function removeDataListener(id:String,func:Function,params:Object = null):void
	{
		MessageManager.instance.removeMessageListener(MessageConstants.MESSAGE_DATA,id,func);
	}
}