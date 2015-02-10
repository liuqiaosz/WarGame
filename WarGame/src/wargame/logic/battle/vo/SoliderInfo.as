package wargame.logic.battle.vo
{
	import lib.animation.avatar.cfg.atom.ConfigUnit;
	import lib.animation.avatar.cfg.atom.ConfigUnitLevel;

	public class SoliderInfo
	{
		private var atom:ConfigUnit = null;
		public var id:String = "";
		public var level:int = 0;
		public var levelInfo:ConfigUnitLevel = null;
		
		public function SoliderInfo(atom:ConfigUnit,lv:int)
		{
			this.atom = atom;
			level = lv;
			if(level <= 0 || level > atom.level.length)
			{
				level = 1;
			}
					
			levelInfo = atom.level[level - 1];
		}
	}
}