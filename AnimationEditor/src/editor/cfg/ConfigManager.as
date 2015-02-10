package editor.cfg
{
	import editor.setting.EditorSetting;
	import editor.utility.Constants;
	import editor.utility.FileSystemTool;
	
	import flash.filesystem.File;
	import flash.utils.ByteArray;
	
	import lib.animation.avatar.cfg.AtomConfigManager;
	import lib.animation.avatar.cfg.ConfigActionTrigger;
	import lib.animation.avatar.cfg.ConfigAvatar;
	import lib.animation.avatar.cfg.atom.ConfigSkill;
	import lib.animation.avatar.cfg.atom.ConfigUnit;
	import lib.animation.effect.cfg.ConfigEffect;

	/**
	 * 配置文件数据管理
	 **/
	public class ConfigManager
	{
		private static var _instance:ConfigManager = null;
		public static function get instance():ConfigManager
		{
			if(!_instance)
			{
				_instance = new ConfigManager();
			}
			return _instance;
		}
		
		public var units:Vector.<ConfigUnit> = null;
		public var skills:Vector.<ConfigSkill> = null;
		public var avatars:Vector.<ConfigAvatar> = null;
		public var effects:Vector.<ConfigEffect> = null;
		public function ConfigManager()
		{
			units = new Vector.<ConfigUnit>();
			skills = new Vector.<ConfigSkill>();
		}
		
		public function refresh():void
		{
			initAtom();
			initAvatar();
			initEffect();
		}
		
		private function initAvatar():void
		{
			var cfgDir:File = new File(EditorSetting.instance.setting.directory.cfgDirectory);
			//var cfgDir:File = new File("D:\\Github\\WarGame\\Config");
			var json:String = "";
			var data:ByteArray = null;
			if(cfgDir.exists)
			{
				avatars = new Vector.<ConfigAvatar>();
				var avatarFile:File = cfgDir.resolvePath(Constants.AVATAR_CFG_FILE);
				if(!avatarFile.exists)
				{
					//配置文件不存在,通过原子数据构建初始化配置
					if(units && units.length)
					{
						var avatar:ConfigAvatar = null;
						for each(var unit:ConfigUnit in units)
						{
							avatar = new ConfigAvatar();
							avatar.id = unit.id;
							avatars.push(avatar);
						}
					}
					json = JSON.stringify(avatars);
					data = new ByteArray();
					data.writeUTFBytes(json);
					FileSystemTool.writeFile(avatarFile.nativePath,data);
				}
				else
				{
					//读取
					data = FileSystemTool.readFile(avatarFile.nativePath);
					if(data)
					{
						json = data.readUTFBytes(data.length);
						var jsonArr:Array = JSON.parse(json) as Array;
						for each(var obj:Object in jsonArr)
						{
							avatars.push(ConfigAvatar.decode(obj));
						}
					}
				}
			}
		}
		
		private function initEffect():void
		{
			var cfgDir:File = new File(EditorSetting.instance.setting.directory.cfgDirectory);
			//var cfgDir:File = new File("D:\\Github\\WarGame\\Config");
			var json:String = "";
			var data:ByteArray = null;
			if(cfgDir.exists)
			{
				effects = new Vector.<ConfigEffect>();
				if(!EditorSetting.instance.setting.directory.effectDirectory)
				{
					return;
				}
				var effectFile:File = cfgDir.resolvePath(Constants.EFFECT_CFG_FILE);
				if(!effectFile.exists && EditorSetting.instance.setting.directory.effectDirectory)
				{
					//加载特效资源目录所有文件夹构建基础配置文件
					var effAssetDir:File = new File(EditorSetting.instance.setting.directory.effectDirectory);
					if(effAssetDir.exists)
					{
						var subDirs:Array = effAssetDir.getDirectoryListing();
						var cfg:ConfigEffect = null;
						for each(var dir:File in subDirs)
						{
							cfg = new ConfigEffect();
							cfg.id = cfg.name = dir.name;
							effects.push(cfg);
						}
						
						json = JSON.stringify(effects);
						data = new ByteArray();
						data.writeUTFBytes(json);
						FileSystemTool.writeFile(effectFile.nativePath,data);
					}
				}
				else
				{
					data = FileSystemTool.readFile(effectFile.nativePath);
					if(data)
					{
						json = data.readUTFBytes(data.length);
						var jsonArr:Array = JSON.parse(json) as Array;
						for each(var obj:Object in jsonArr)
						{
							effects.push(ConfigEffect.decode(obj));
						}
					}
				}
			}
		}
		
		/**
		 * 原子配置数据
		 **/
		private function initAtom():void
		{
			var cfgDir:File = new File(EditorSetting.instance.setting.directory.cfgDirectory);
			if(cfgDir.exists)
			{
				var data:ByteArray = null;
				var json:String = "";
				var jsonArr:Array = null;
				//load unit
				var cfgFile:File = cfgDir.resolvePath(Constants.EXCEL_CFG_FILE);
				if(cfgFile.exists)
				{
					data = FileSystemTool.readFile(cfgFile.nativePath);
					json = data.readUTFBytes(data.length);
					
					var obj:Object = JSON.parse(json);
					AtomConfigManager.instance.loadUnitAtomByJson(obj.unit as Array);
					AtomConfigManager.instance.loadSkillAtomByJson(obj.skill as Array);
					
					units = AtomConfigManager.instance.units;
					skills = AtomConfigManager.instance.skills;
				}
			}
		}
		
		public function findUnitAtomById(id:String):ConfigUnit
		{
			for each(var value:ConfigUnit in units)
			{
				if(value.id == id)
				{
					return value;
				}
			}
			return null;
		}
		
		public function findSkillAtomById(id:String):ConfigSkill
		{
			for each(var value:ConfigSkill in skills)
			{
				if(value.id == id)
				{
					return value;
				}
			}
			return null;
		}
		
		public function saveAvatar():Boolean
		{
			var cfgDir:File = new File(EditorSetting.instance.setting.directory.cfgDirectory);
			if(cfgDir.exists)
			{
				var avatarFile:File = cfgDir.resolvePath(Constants.AVATAR_CFG_FILE);
				var json:String = JSON.stringify(avatars);
				var data:ByteArray = new ByteArray();
				data.writeUTFBytes(json);
				FileSystemTool.writeFile(avatarFile.nativePath,data);
				return true;
			}
			return false;
		}
		public function saveEffect():Boolean
		{
			var cfgDir:File = new File(EditorSetting.instance.setting.directory.cfgDirectory);
			if(cfgDir.exists)
			{
				var effectFile:File = cfgDir.resolvePath(Constants.EFFECT_CFG_FILE);
				var json:String = JSON.stringify(effects);
				var data:ByteArray = new ByteArray();
				data.writeUTFBytes(json);
				FileSystemTool.writeFile(effectFile.nativePath,data);
				return true;
			}
			return false;
		}
	}
}