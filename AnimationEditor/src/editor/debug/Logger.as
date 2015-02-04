package editor.debug
{
	import editor.ui.LoggerPanel;

	public class Logger
	{
		private static var _instance:Logger = null;
		public static function get instance():Logger
		{
			if(!_instance)
			{
				_instance = new Logger();
			}
			return _instance;
		}
		
		private var logs:Vector.<String> = null;
		public function Logger()
		{
			logs = new Vector.<String>();
		}
		
		public function getLogs():Vector.<String>
		{
			return logs;
		}
		
		public function debug(value:String):void
		{
			logs.push("[DEBUG]: " + value); 
			trigger(logs[logs.length - 1]);
		}
		
		public function warn(value:String):void
		{
			logs.push("[WARN]: " + value); 
			trigger(logs[logs.length - 1]);
		}
		
		public function error(value:String):void
		{
			logs.push("[ERROR]: " + value); 
			trigger(logs[logs.length - 1]);
		}
		
		private function trigger(value:String):void
		{
			if(logPanel)
			{
				logPanel.appendLog(value);
			}
		}
		
		private var logPanel:LoggerPanel = null;
		public function showPanel():void
		{
			if(!logPanel)
			{
				logPanel = new LoggerPanel();
				popup(logPanel,false);
			}
		}
		public function hidePanel():void
		{
			
		}
	}
}