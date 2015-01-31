/**
 * 全局函数
 * 
 * 快捷代理函数，发送逻辑消息
 */
package
{
	import framework.module.msg.MessageConstants;
	import framework.module.msg.MessageManager;

	public function sendLogicMessage(id:String,params:Object = null,sync:Boolean = false):void
	{
		MessageManager.instance.sendMessage(MessageConstants.MESSAGE_LOGIC,id,params,sync);
	}
}