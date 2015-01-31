/**
 * 全局函数
 * 
 * 快捷代理函数，发送视图消息
 */
package
{
	import framework.module.msg.MessageConstants;
	import framework.module.msg.MessageManager;

	public function sendViewMessage(id:String,params:Object = null,sync:Boolean = false):void
	{
		MessageManager.instance.sendMessage(MessageConstants.MESSAGE_VIEW,id,params,sync);
	}
}