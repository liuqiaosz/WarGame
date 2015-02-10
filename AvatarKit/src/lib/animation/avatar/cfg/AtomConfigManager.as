package lib.animation.avatar.cfg
{
	import lib.animation.avatar.cfg.atom.ConfigSkill;
	import lib.animation.avatar.cfg.atom.ConfigUnit;

	public class AtomConfigManager
	{
		public static var _instance:AtomConfigManager = null;
		public static function get instance():AtomConfigManager
		{
			if(!_instance)
			{
				_instance = new AtomConfigManager();
			}
			return _instance;
		}
		
		public function AtomConfigManager()
		{
		}
		
		private var _units:Vector.<ConfigUnit> = new Vector.<ConfigUnit>();
		public function get units():Vector.<ConfigUnit>
		{
			return _units;
		}
		private var _skills:Vector.<ConfigSkill> = new Vector.<ConfigSkill>();
		public function get skills():Vector.<ConfigSkill>
		{
			return _skills;
		}
		
		public function loadUnitAtomByJson(jsonArr:Array):void
		{
			for each(var obj:Object in jsonArr)
			{
				_units.push(ConfigUnit.decode(obj));
			}
		}
		public function loadSkillAtomByJson(jsonArr:Array):void
		{
			for each(var obj:Object in jsonArr)
			{
				_skills.push(ConfigSkill.decode(obj));
			}
		}
		
		public function loadUnitAtom(json:String):void
		{
			_units.length = 0;
			var jsonArr:Array = JSON.parse(json) as Array;
			
			if(jsonArr && jsonArr.length)
			{
				for each(var obj:Object in jsonArr)
				{
					_units.push(ConfigUnit.decode(obj));
				}
			}
		}
		public function loadSkillAtom(json:String):void
		{
			_skills.length = 0;
			var jsonArr:Array = JSON.parse(json) as Array;
			
			if(jsonArr && jsonArr.length)
			{
				for each(var obj:Object in jsonArr)
				{
					_skills.push(ConfigSkill.decode(obj));
				}
			}
		}
		
		public function findUnitById(id:String):ConfigUnit
		{
			for each(var unit:ConfigUnit in units)
			{
				if(unit.id == id)
				{
					return unit;
				}
			}
			return null;
		}
	}
}