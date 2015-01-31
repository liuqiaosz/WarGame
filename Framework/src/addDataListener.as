/**
 * 全局函数
 * 
 * 快捷代理函数，监听数据消息
 */
package
{
	import framework.module.msg.MessageConstants;
	import framework.module.msg.MessageManager;
	
	public function addDataListener(id:String,func:Function,params:Object = null,priority:int = 0):void
	{
		MessageManager.instance.addMessageListener(MessageConstants.MESSAGE_DATA,id,func,params,priority);
	}
}