using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using OfficeOpenXml;
using System.Reflection;

namespace GameConfigTools.Domain
{
	/**
	 * 单位配置
	 **/
	public class Unit
	{
		//配置	ID
		public string Id;
		
		//名称
		public string Name;

		//单位类型: 1:普通召唤单位,2:英雄3:BOSS
		public int UnitType;

		//行动类型
		//1: 地面，2:飞行
		public int ActionType;

		//攻击类型
		//1: 近战 ,2:远程
		public int AttackType;

		//单位描述
		public string Desc;

		//普通技能
		public string NormalSkill;
		//特效技能
		public string SpecialSkill;

		public UnitLevel[] Levels;

	}
}
