package framework.module.notification
{
	import flash.utils.Dictionary;
	
	import framework.module.BaseModule;

	/**
	 * 消息中心
	 */
	public class NotificationManager extends BaseModule
	{
		public static const MODE_SYNC:int = 1;	//同步模式
		public static const MODE_ASYNC:int = 2;	//异步模式
		
		public static const POOL_CAPACITY:int = 20;		//对象池空间
		private static var _instance:NotificationManager = null;	
		private var mode:int = MODE_ASYNC;			//默认异步模式
		private var perCount:int = 5;				//每帧处理消息总数
		
		private var _msgDict:Dictionary = null;
		private var sendQueue:Vector.<MessageSender> = null;

		public function NotificationManager()
		{
			if(_instance)
			{
				throw new Error("Singlton Instance Error!");
			}
			_msgDict = new Dictionary();
		}
		
		public static function get instance():NotificationManager
		{
			if(!_instance)
			{
				_instance = new NotificationManager();
			}
			return _instance;
		}
		
		private var swap:Vector.<MessageSender> = null;
		override public function update(t:Number):void
		{
			super.update(t);
			if(sendQueue && sendQueue.length)
			{
				swap = sendQueue.concat();
				sendQueue.length = 0;
				//异步消息队列处理
				var send:MessageSender = null;
//				while(swap.length)
				for(var idx:int = 0; idx<swap.length; idx++)
				{
					send = swap[idx];
					dispatchMessage(send.type,send.id,send.params);
				}
				swap = null;
			}
		}
		
		/**
		 * 切换处理模式
		 */
		public function switchMode():void
		{
			mode = (mode == MODE_SYNC ? MODE_ASYNC:MODE_SYNC);
		}
		
		private var handlerSign:Dictionary = new Dictionary();
		/**
		 * 添加消息监听
		 * 
		 * @param		type		消息类型
		 * @param		id			消息id
		 * @param		func		消息回调
		 * @param		params		消息参数
		 */
		public function addMessageListener(type:int,id:String,func:Function,params:Object = null,priority:int = 0):void
		{
			if(!(type in _msgDict))
			{
				_msgDict[type] = new Dictionary();
			}
			var msgDict:Dictionary = _msgDict[type];
			if(!(id in msgDict))
			{
				msgDict[id] = new Vector.<MessageHandler>();
			}
			
			var sign:String = type + "_" + id;
			if(!(sign in handlerSign))
			{
				handlerSign[sign] = [];
			}
			
			if(handlerSign[sign].indexOf(func) < 0)
			{
				var handler:MessageHandler = new MessageHandler();
				handler.handler = func;
				handler.priority = priority;
				var queue:Vector.<MessageHandler> = msgDict[id];
				//			if(queue.indexOf(func) < 0)
				//			{
				//				queue.push(func);
				//			}
				queue.push(handler);
				
				handlerSign[sign].push(handler);
			}
		}
		
		/**
		 * 删除消息队列
		 * 
		 * @param		type		消息类型
		 * @param		id			消息ID
		 * @param		func		消息回调
		 */
		public function removeMessageListener(type:int,id:String,func:Function):void
		{
			if(type in _msgDict && id in _msgDict[type])
			{
//				var sign:String = type + "_" + id;
				var sign:String = type + "_" + id;
				if(sign in handlerSign)
				{

					var signIndex:int = -1;
					var len:int = handlerSign[sign].length;
					for(var index:int = 0; index<len; index++)
					{
						if(handlerSign[sign][index].handler == func)
						{
							signIndex = index;
						}
					}
					
//					var queue:Vector.<Function> = _msgDict[type][id];
//					var idx:int = queue.indexOf(func);
//					if(idx >= 0)
//					{
//						queue.splice(idx,1);
//					}
					if(signIndex >= 0)
					{
						var handler:MessageHandler = handlerSign[sign][signIndex];
						var queue:Vector.<MessageHandler> = _msgDict[type][id];
						var idx:int = queue.indexOf(handler);
						if(idx >= 0)
						{
							queue.splice(idx,1);
						}
						handlerSign[sign].splice(signIndex,1);
						
//						delete handlerSign[sign];
					}
				}
			}
		}
		
		/**
		 * 发送消息借口
		 */
		public function sendMessage(type:int,id:String,params:Object = null,sync:Boolean = false):void
		{
			if(mode == MODE_ASYNC && !sync)
			{
				//异步派发消息，进入发送队列
				if(!sendQueue)
				{
					sendQueue = new Vector.<MessageSender>();
					
				}
				var sender:MessageSender = new MessageSender();
				sender.type = type;
				sender.id = id;
				sender.params = params;
				sendQueue.push(sender);
			}
			else
			{
				//同步派发消息
				dispatchMessage(type,id,params);
			}
		}
		
		/**
		 * 派发消息
		 */
		private function dispatchMessage(type:int,id:String,params:Object = null):void
		{
			if(type in _msgDict && id in _msgDict[type])
			{
//				var funcs:Vector.<Function> = _msgDict[type][id];
				var funcs:Vector.<MessageHandler> = _msgDict[type][id];
//				for each(var func:Function in funcs)
				funcs.sort(sortPriority);
//				for each(var handler:MessageHandler in funcs)
				for(var idx:int = 0; idx<funcs.length; idx++)
				{
//					func(id,params);
					funcs[idx].handler(params);
				}
			}
		}
		
		/**
		 * 优先级排序
		 **/
		private function sortPriority(h1:MessageHandler,h2:MessageHandler):int
		{
			if(h1.priority == h2.priority)
			{
				return 0;
			}
			else if(h2.priority > h1.priority)
			{
				return -1;
			}
			else
			{
				return 1;
			}
		}
	}
}


class MessageSender
{
	public var type:int = 0;
	public var id:String = "";
	public var params:Object = null;

	public function MessageSender()
	{
		
	}
	
	public function reuse():void
	{
		type = 0;
		id = "";
		params = null;
	}
}

class MessageHandler
{
	public var id:String = "";
	public var handler:Function = null;
	public var priority:int = 0;
	
	public function MessageHandler()
	{
		
	}
}