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

namespace GameConfigTools.Domain
{
	
	public class Config
	{
		public List<BaseDomain> unit;
		public List<BaseDomain> skill;
		public List<BaseDomain> effect;
		public List<BaseDomain> level;
		public List<BaseDomain> camp;
		public List<BaseDomain> component;
		
	}
}
