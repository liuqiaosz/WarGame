/**
 * 全局函数
 * 
 * 快捷代理函数，发送框架消息
 */
package
{
	import framework.module.msg.MessageConstants;
	import framework.module.msg.MessageManager;

	public function sendFrameworkMessage(id:String,params:Object = null):void
	{
		MessageManager.instance.sendMessage(MessageConstants.MESSAGE_FRAMEWORK,id,params);
	}
}