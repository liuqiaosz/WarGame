/**
 * 全局函数
 * 
 * 快捷代理函数，监听逻辑消息
 */
package
{
	import framework.module.msg.MessageConstants;
	import framework.module.msg.MessageManager;
	
	public function addLogicListener(id:String,func:Function,params:Object = null,priority:int = 0):void
	{
		MessageManager.instance.addMessageListener(MessageConstants.MESSAGE_LOGIC,id,func,params,priority);
	}
}