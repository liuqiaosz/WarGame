package framework.core
{
	import flash.utils.Dictionary;
	
	import framework.common.objectPool.ObjectPool;
	import framework.common.vo.SchedulerItem;
	import framework.module.msg.MessageConstants;

	/**
	 * 定时管理器
	 */
	public class TimerScheduler
	{
		private var isUpdating:Boolean = false;
		private var taskDict:Dictionary = null;
		private var taskList:Vector.<SchedulerItem> = null;
		private static var _instance:TimerScheduler = null;
		public function TimerScheduler()
		{
			taskList = new Vector.<SchedulerItem>();
			taskDict = new Dictionary();
			cycle = new Vector.<SchedulerItem>();
			addFrameworkListener(MessageConstants.MSG_FMK_FRAME_UPDATE,onUpdate);
		}
		
		private var len:int = 0;
		private var item:SchedulerItem = null;
		private var now:int = 0;
		private var keyFunc:Function = null;
		private var cycle:Vector.<SchedulerItem> = null;
		private function onUpdate(id:String,params:Object = null):void
		{
			isUpdating = true;
			len = taskList.length;
			now = int(params);

			for(var idx:int = 0; idx<len; idx++)
			{
				item = taskList[idx];
				if((now - item.lastTodo) >= item.delay)
				{
					item.todo(now);
					if(item.repeat > 0 && item.runCount >= item.repeat && cycle.indexOf(item) < 0)
					{
						if(null != item.comleteHandler)
						{
							item.comleteHandler(item);
						}
						cycle.push(item);
					}
				}
			}
			
			while(cycle.length)
			{
				item = cycle.pop();
				taskList.splice(taskList.indexOf(item),1);
				delete taskDict[item.handler];
				ObjectPool.returnInstance(item);
			}
			item = null;
			isUpdating = false;
		}
		
		public static function get instance():TimerScheduler
		{
			if(!_instance)
			{
				_instance = new TimerScheduler();
			}
			return _instance;
		}
		
		/**
		 * 注册一个定时调度任务
		 */
		public function registerScheduler(delay:int,handler:Function,repeatCount:int = -1,onComplete:Function = null):void
		{
			if(!(handler in taskDict))
			{
				var info:SchedulerItem = ObjectPool.getInstanceOf(SchedulerItem);
				info.delay = delay;
				info.handler = handler;
				info.repeat = repeatCount;
				info.comleteHandler = onComplete;
				taskList.push(info);
				taskDict[handler] = info;
				info.init();
			}
		}
		
		/**
		 * 取消注册一个时间调度
		 */
		public function unregisterScheduler(handler:Function):void
		{
			if(handler in taskDict)
			{
				var info:SchedulerItem = taskDict[handler];
				if(!isUpdating)
				{
					//非更新状态
					delete taskDict[handler];
					taskList.splice(taskList.indexOf(info),1);
					ObjectPool.returnInstance(info);
				}
				else
				{
					//更新中，放入回收队列
					cycle.push(info);
				}
			}
		}
	}
}