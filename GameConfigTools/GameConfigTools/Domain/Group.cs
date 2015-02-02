using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace GameConfigTools.Domain
{
	public class Group
	{
		public string[] Title;
		public string[] SubTitle;
		
		public bool HasSubGroup
		{
			get
			{
				return (null != SubTitle && SubTitle.Length > 0);
			}
		}
	}
}
