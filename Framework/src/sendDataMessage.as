/**
 * 全局函数
 * 
 * 快捷代理函数，发送数据消息
 */
package
{
	import framework.module.msg.MessageConstants;
	import framework.module.msg.MessageManager;

	public function sendDataMessage(id:String,params:Object = null):void
	{
		MessageManager.instance.sendMessage(MessageConstants.MESSAGE_DATA,id,params);
	}
}