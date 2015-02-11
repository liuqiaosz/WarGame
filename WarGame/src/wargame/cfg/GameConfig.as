package wargame.cfg
{
	import extension.asset.AssetsManager;
	
	import flash.utils.ByteArray;
	
	import lib.animation.avatar.AvatarManager;
	import lib.animation.avatar.cfg.AtomConfigManager;
	import lib.animation.effect.EffectManager;
	
	import wargame.cfg.vo.ConfigCamp;
	import wargame.cfg.vo.ConfigComponent;
	import wargame.cfg.vo.ConfigLevel;

	public class GameConfig
	{
		private static var _instance:GameConfig = null;
		public static function get instance():GameConfig
		{
			if(!_instance)
			{
				_instance = new GameConfig();
			}
			return _instance;
		}
		
		public function GameConfig()
		{
			_camps = new Vector.<ConfigCamp>();
			_components = new Vector.<ConfigComponent>();
			_levels = new Vector.<ConfigLevel>();
		}
		
		private function loadVer():void
		{
			
		}
		private var _defaultCom:Vector.<ConfigComponent> = new Vector.<ConfigComponent>();
		private var _camps:Vector.<ConfigCamp> = null;
		private var _components:Vector.<ConfigComponent> = null;
		private var _levels:Vector.<ConfigLevel> = null;
		private var _complete:Function = null;
		private var _progress:Function = null;
		public function loadConfig(complete:Function,progress:Function = null):void
		{
			AssetsManager.instance.addLoadQueue([
				"assets/cfg/Config",
				"assets/cfg/avatar",
				"assets/cfg/effect",
			],function():void{
				//游戏配置
				var data:Object = AssetsManager.instance.getObject("Config");
				if(data)
				{
					AtomConfigManager.instance.loadUnitAtomByJson(data.unit as Array);
					AtomConfigManager.instance.loadSkillAtomByJson(data.skill as Array);
					loadCamp(data.camp);
					loadLevel(data.level);
					loadComponent(data.component);
				}
				
				debug("开始加载avatar配置");
				//动画配置
				data = AssetsManager.instance.getObject("avatar");
				AvatarManager.instance.loadConfigByJson(data as Array);
				
				debug("开始加载effect配置");
				data = AssetsManager.instance.getObject("effect");
				EffectManager.instance.loadConfigByJson(data as Array);
			},function(ratio:Number):void{});
		}
		
		
		private function loadCamp(arr:Array):void
		{
			for each(var obj:Object in arr)
			{
				_camps.push(ConfigCamp.decode(obj));
			}
		}
		
		private function loadLevel(arr:Array):void
		{
			for each(var obj:Object in arr)
			{
				_levels.push(ConfigLevel.decode(obj));
			}
		}
		private function loadComponent(arr:Array):void
		{
			_defaultCom.length = 0;
			var component:ConfigComponent = null;
			for each(var obj:Object in arr)
			{
				component = ConfigComponent.decode(obj);
				if(component.defaultOpen == 1)
				{
					_defaultCom.push(component);
				}
				else
				{
					_components.push(ConfigComponent.decode(obj));
				}
			}
		}
		
		//默认挂载的城堡组件
		public function get defaultCampComponent():Vector.<ConfigComponent>
		{
			return _defaultCom;
		}
		
		public function findLevelById(id:String):ConfigLevel
		{
			for(var idx:int = 0; idx<_levels.length; idx++)
			{
				if(_levels[idx].id == id)
				{
					return _levels[idx];
				}
			}
			return null;
		}
		
		public function findCampByLevel(lv:int):ConfigCamp
		{
			if(lv > 0 && lv < _camps.length)
			{
				return _camps[lv -1 ];
			}
			return null;
		}
		
		public function findCompById(id:String):ConfigComponent
		{
			for(var idx:int = 0; idx<_components.length; idx++)
			{
				if(_components[idx].id == id)
				{
					return _components[idx];
				}
			}
			return null;
		}
	}
}