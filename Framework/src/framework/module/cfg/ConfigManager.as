package framework.module.cfg
{
	import flash.utils.Dictionary;
	
	import framework.module.BaseModule;

	/**
	 * 基础配置模块管理器
	 */
	public class ConfigManager extends BaseModule
	{
		private var loaderDict:Dictionary = null;
		private static var _instance:ConfigManager = null;
		public function ConfigManager()
		{
			if(_instance)
			{
				throw new Error("Singlton Instance Error!");
			}
			loaderDict = new Dictionary();
		}
		
		public static function get instance():ConfigManager
		{
			if(!_instance)
			{
				_instance = new ConfigManager();
			}
			return _instance;
		}
		
		override public function initializer():void
		{
			super.initializer();
		}
		
		/**
		 * 加载配置
		 * 
		 * @param		id		配置ID
		 * @param		cfg		配置路径
		 * @param		loader	加载器
		 */
		public function load(id:String,cfg:String,loader:Class):Object
		{
			var cfgLoader:IConfigLoader = null;
			if(id in loaderDict)
			{
				cfgLoader = loaderDict[id];
			}
			else
			{
				cfgLoader = loaderDict[id] = new loader();
			}
			
			if(cfgLoader)
			{
				var result:Boolean = cfgLoader.load(cfg);
				if(result)
				{
					return cfgLoader.getConfig();
				}
			}
			return null;
		}
		
		/**
		 * 用ID获取配置加载器
		 * 
		 * @param		id			配置加载器ID
		 */
		public function getLoaderById(id:String):IConfigLoader
		{
			if(id in loaderDict)
			{
				return loaderDict[id];
			}
			return null;
		}
		
	}
}