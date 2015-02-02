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
			ParseAndSaveUnitExcel("D:\\WeiyunSync\\Unit.xlsx");
			ParseAndSaveSkillExcel("D:\\WeiyunSync\\Skill.xlsx");
		}

		/**
		 *  解析并且保存Unit配置表数据
		 **/
		private void ParseAndSaveUnitExcel(string FilePath)
		{
			FileInfo existingFile = new FileInfo(FilePath);
			ExcelPackage Pack = new ExcelPackage(existingFile);
			Group Desc = new Group();
			Desc.Title = new string[]{
				"ID",
				"名称",
				"单位类型",
				"行动类型",
				"攻击类型",
				"单位描述",
				"技能",
				"SP技能"
			};
			Desc.SubTitle = new string[] { 
				"等级",
				"升级花费",
				"攻击",
				"防御",
				"生命",
				"资源"	
			};
			List<BaseDomain> Value = ExcelTools.Encode(Pack.Workbook.Worksheets[1], Desc);
			string JSON = JsonConvert.SerializeObject(Value);

			FileStream Writer = new FileStream("D:\\unit", FileMode.OpenOrCreate);
			byte[] Data = new UTF8Encoding().GetBytes(JSON);
			Writer.Write(Data, 0, Data.Length);
			Writer.Flush();
			Writer.Close();
			Console.WriteLine(JSON);
		}

		private void ParseAndSaveSkillExcel(string FilePath)
		{
			//ID	技能名称	攻击类型	解锁等级	技能范围	技能描述	技能效果	等级	升级花费	技能数值	SP消耗	资源

			FileInfo existingFile = new FileInfo(FilePath);
			ExcelPackage Pack = new ExcelPackage(existingFile);
			Group Desc = new Group();
			Desc.Title = new string[]{
				"ID",
				"技能名称",
				"攻击类型",
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
			List<BaseDomain> Value = ExcelTools.Encode(Pack.Workbook.Worksheets[1], Desc);
			string JSON = JsonConvert.SerializeObject(Value);

			FileStream Writer = new FileStream("D:\\skill", FileMode.OpenOrCreate);
			byte[] Data = new UTF8Encoding().GetBytes(JSON);
			Writer.Write(Data, 0, Data.Length);
			Writer.Flush();
			Writer.Close();
			Console.WriteLine(JSON);
		}
	}
}
