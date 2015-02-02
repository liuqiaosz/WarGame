using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace GameConfigTools.Domain
{
	public class SkillLevel
	{
		//升级花费
		public int UpgradeCost;

		public int Value;

		public int SpCost;

		//技能映射的资源ID,图标显示之类
		public string Resource;
	}
}
