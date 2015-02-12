package wargame.logic.battle.vo
{
	import lib.animation.avatar.cfg.atom.ConfigUnit;
	import lib.animation.avatar.cfg.atom.ConfigUnitLevel;

	public class SoliderInfo
	{
		public var atom:ConfigUnit = null;
		public var id:String = "";
		public var level:int = 0;
		public var levelInfo:ConfigUnitLevel = null;
		public var clan:int = 0;
		public var hp:int = 0;
		public function SoliderInfo(atom:ConfigUnit,lv:int,cl:int)
		{
			this.atom = atom;
			level = lv;
			clan = cl;
			if(level <= 0 || level > atom.level.length)
			{
				level = 1;
			}
					
			levelInfo = atom.level[level - 1];
			//生命
			hp = levelInfo.hp;
			
			id = atom.id;
		}
	}
}