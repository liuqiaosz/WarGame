using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using OfficeOpenXml;
using System.Reflection;
using GameConfigTools.Domain;

namespace GameConfigTools.Tools
{
	public class ExcelTools
	{
		public static List<BaseDomain> Encode(ExcelWorksheet Sheet, Group GroupDesc)
		{
			List<BaseDomain> Config = new List<BaseDomain>();

			int TotalRow = Sheet.Dimension.Rows;
			int TotalCol = Sheet.Dimension.Columns;

			BaseDomain Domain = CreateNewDomain(GroupDesc);

			string[] Titles = new string[TotalCol];

			int Row = 1;
			int Col = 1;
			string CellValue = "";
			string Title = "";
			string[] SubValue = null;
			//加载Title
			for (int RowIndex = Row; RowIndex <= TotalRow; RowIndex++)
			{
				if (RowIndex > 1 && GroupDesc.HasSubGroup)
				{
					SubValue = new string[GroupDesc.SubTitle.Length];
				}

				for (int ColIndex = Col; ColIndex <= TotalCol; ColIndex++)
				{
					Object Value = Sheet.GetValue(RowIndex, ColIndex);
					if (null == Value)
					{
						continue;
					}
					else
					{
						if (ColIndex == 1 && RowIndex > 1)
						{
							//一条新记录
							Domain = CreateNewDomain(GroupDesc);
							Config.Add(Domain);
						}
					}
					CellValue = Value.ToString();
					if (RowIndex == 1)
					{
						//TITLE
						Titles[ColIndex - 1] = Title = CellValue;
					}
					else
					{
						Title = Titles[ColIndex - 1];

						if (GroupDesc.Title.Contains(Title))
						{
							//
							Domain.Value[Array.IndexOf<string>(GroupDesc.Title, Title)] = CellValue;
						}
						else if (GroupDesc.HasSubGroup)
						{
							//有子配置
							if (GroupDesc.SubTitle.Contains(Title))
							{
								SubValue[Array.IndexOf<string>(GroupDesc.SubTitle, Title)] = CellValue;
							}
						}
					}
				}
				if (null != SubValue && null != Domain)
				{
					Domain.SubValue.Add(SubValue);
				}
			}
			return Config;
		}

		private static BaseDomain CreateNewDomain(Group GroupDesc)
		{
			BaseDomain Domain = new BaseDomain();
			Domain.SubTitle = GroupDesc.SubTitle;
			Domain.SubValue = new List<string[]>();
			Domain.Title = GroupDesc.Title;
			Domain.Value = new string[Domain.Title.Length];
			return Domain;
		}
	}

	
}
