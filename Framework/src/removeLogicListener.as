/**
 * 全局函数
 * 
 * 快捷代理函数，监听逻辑消息
 */
package
{
	import framework.module.msg.MessageConstants;
	import framework.module.msg.MessageManager;
	
	public function removeLogicListener(id:String,func:Function,params:Object = null):void
	{
		MessageManager.instance.removeMessageListener(MessageConstants.MESSAGE_LOGIC,id,func);
	}
}