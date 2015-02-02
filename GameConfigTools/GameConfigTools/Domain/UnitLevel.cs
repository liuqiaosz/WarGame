using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace GameConfigTools.Domain
{
	/**
	 * 单位等级配置
	 **/
	public class UnitLevel
	{
		//等级
		public int Level;

		public int Attack;
		public int Defense;
		public int Hp;

		//升级花费
		public int UpgradeCost;

		//等级的资源ID
		public string Resource;

		
	}
}
