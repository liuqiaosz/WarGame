package editor.cfg
{
	import editor.setting.EditorSetting;
	import editor.utility.Constants;
	import editor.utility.FileSystemTool;
	
	import flash.filesystem.File;
	import flash.utils.ByteArray;
	
	import lib.avatarkit.cfg.ConfigActionTrigger;
	import lib.avatarkit.cfg.ConfigAvatar;
	import lib.avatarkit.cfg.atom.ConfigSkill;
	import lib.avatarkit.cfg.atom.ConfigUnit;

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
		public function ConfigManager()
		{
			units = new Vector.<ConfigUnit>();
			skills = new Vector.<ConfigSkill>();
		}
		
		public function refresh():void
		{
			initAtom();
			initAvatar();
		}
		
		private function initAvatar():void
		{
//			var cfgDir:File = new File(EditorSetting.instance.setting.directory.cfgDirectory);
			var cfgDir:File = new File("D:\\Github\\WarGame\\Config");
			var json:String = "";
			var data:ByteArray = null;
			if(cfgDir.exists)
			{
				var avatarFile:File = cfgDir.resolvePath(Constants.AVATAR_CFG_FILE);
				if(!avatarFile.exists)
				{
					//配置文件不存在,通过原子数据构建初始化配置
					avatars = new Vector.<ConfigAvatar>();
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
		
		/**
		 * 原子配置数据
		 **/
		private function initAtom():void
		{
			//var cfgDir:File = new File(EditorSetting.instance.setting.directory.cfgDirectory);
			var cfgDir:File = new File("D:\\Github\\WarGame\\Config");
			if(cfgDir.exists)
			{
				var data:ByteArray = null;
				var json:String = "";
				var jsonArr:Array = null;
				var obj:Object = null;
				//load unit
				var unitFile:File = cfgDir.resolvePath(Constants.EXCEL_UNIT_CFG_FILE);
				if(unitFile.exists)
				{
					data = FileSystemTool.readFile(unitFile.nativePath);
					json = data.readUTFBytes(data.length);
					jsonArr = JSON.parse(json) as Array;
					
					if(jsonArr && jsonArr.length)
					{
						for each(obj in jsonArr)
						{
							units.push(ConfigUnit.decode(obj));
						}
					}
				}
				
				var skillFile:File = cfgDir.resolvePath(Constants.EXCEL_SKILL_CFG_FILE);
				if(skillFile.exists)
				{
					data = FileSystemTool.readFile(skillFile.nativePath);
					json = data.readUTFBytes(data.length);
					jsonArr = JSON.parse(json) as Array;
					
					if(jsonArr && jsonArr.length)
					{
						for each(obj in jsonArr)
						{
							skills.push(ConfigSkill.decode(obj));
						}
					}
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
	}
}