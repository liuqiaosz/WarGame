using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace GameConfigTools.Domain
{
	/**
	 * 单位技能数据配置
	 **/
	public class Skill
	{
		//技能ID
		public string Id;

		public string Name;

		public string Desc;

		public int UnlockLevel;

		//技能类型
		//1: 近战 2:远程
		public int AtkType;

		public int AtkRange;

		public int Effect;

		public SkillLevel[] Levels;

	}
}
