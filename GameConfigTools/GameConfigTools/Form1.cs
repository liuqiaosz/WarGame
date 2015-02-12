using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Windows.Forms;
using OfficeOpenXml;
using System.IO;
using Newtonsoft.Json;
using GameConfigTools.Domain;
using GameConfigTools.Tools;

namespace GameConfigTools
{
	public partial class GameConfigTools : Form
	{
		public GameConfigTools()
		{
			InitializeComponent();
		}

		private void OptionMenuClick(object sender, EventArgs e)
		{

		}

		/**
		 * 导出数据
		 **/
		private void OnExportClick(object sender, EventArgs e)
		{
			Config Cfg = new Config();
			//ParseAndSaveSkillExcel("D:\\Github\\WarGame\\Config\\Config.xlsx");
			FileInfo existingFile = new FileInfo("D:\\Github\\WarGame\\Config\\Config.xlsx");
			ExcelPackage Pack = new ExcelPackage(existingFile);
			int Count = Pack.Workbook.Worksheets.Count;
			ExcelWorksheet Sheet;
			Group Desc = null;
			for (int Index = 1; Index <= Count; Index++)
			{
				Sheet = Pack.Workbook.Worksheets[Index];
				switch (Sheet.Name)
				{
					case "关卡配置":
						Desc = new Group();
						Desc.Title = new string[]{
							"ID",
							"名称",
							"描述",
							"奖励货币",
							"奖励经验",
							"掉落道具",
							"掉落机率",
							"NPC阵营等级",
							"NPC阵营零件等级"
						};
						Desc.SubTitle = new string[] { 
							"出战单位",
							"出战等级"
						};
						//Cfg.level = ParseAndSave(Sheet, Desc, "D:\\Github\\WarGame\\Config\\level");
						Cfg.level = ExcelTools.Encode(Sheet, Desc);
						break;
					case "阵地等级配置":
						Desc = new Group();
						Desc.Title = new string[]{
							"等级",
							"生命",
							"基础攻击",
						};
						//ParseAndSave(Sheet, Desc, "D:\\Github\\WarGame\\Config\\camp");
						Cfg.camp = ExcelTools.Encode(Sheet, Desc);
						break;
					case "单位配置":
						Desc = new Group();
						Desc.Title = new string[]{
							"ID",
							"名称",
							"单位类型",
							"行动类型",
							"攻击类型",
							"伤害距离",
							"移动速度",
							"单位描述",
							"技能",
							"SP技能"
						};
						Desc.SubTitle = new string[] { 
							"等级",
							"建造花费",
							"升级花费",
							"攻击",
							"防御",
							"生命",
							"资源"	
						};
						//ParseAndSave(Sheet, Desc, "D:\\Github\\WarGame\\Config\\unit");
						Cfg.unit = ExcelTools.Encode(Sheet, Desc);
						break;
					case "技能配置":
						Desc = new Group();
						Desc.Title = new string[]{
							"ID",
							"技能名称",
							"攻击类型",
							"伤害距离",
							"解锁等级",
							"技能范围",
							"技能描述",
							"技能效果"
						};
						Desc.SubTitle = new string[] { 
							"等级",
							"升级花费",
							"技能数值",
							"SP消耗",
							"资源"
						};
						//ParseAndSave(Sheet, Desc, "D:\\Github\\WarGame\\Config\\skill");
						Cfg.skill = ExcelTools.Encode(Sheet, Desc);
						break;
					case "零件配置":
						//ID	名称	描述	类型	开启等级	默认开启	资源	范围	数值
						Desc = new Group();
						Desc.Title = new string[]{
							"ID",
							"名称",
							"描述",
							"类型",
							"开启等级",
							"默认开启"
						};
						Desc.SubTitle = new string[] { 
							"资源",
							"范围",
							"数值"
						};
						//ParseAndSave(Sheet, Desc, "D:\\Github\\WarGame\\Config\\component");
						Cfg.component = ExcelTools.Encode(Sheet, Desc);
						break;
				}
			}

			string JSON = JsonConvert.SerializeObject(Cfg);
			FileStream Writer = new FileStream("D:\\Github\\WarGame\\Config\\Config", FileMode.OpenOrCreate);
			byte[] Data = new UTF8Encoding().GetBytes(JSON);
			Writer.Write(Data, 0, Data.Length);
			Writer.Flush();
			Writer.Close();
			Console.WriteLine(JSON);
		}

	
	}
}
