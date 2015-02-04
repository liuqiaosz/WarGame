package editor.utility
{
	import mx.collections.ArrayCollection;

	/**
	 * 常量参数定义
	 **/
	public class Constants
	{
		public static const EDITOR_SETTING_FILE:String = "setting/global";
		
		public static const AVATAR_CFG_FILE:String = "avatar";
		public static const EFFECT_CFG_FILE:String = "effect";
		
		//Excel配置表JSON配置
		public static const EXCEL_UNIT_CFG_FILE:String = "unit";
		public static const EXCEL_SKILL_CFG_FILE:String = "skill";
		
		
		public static const COMBOBOX_TRIGGER_TYPE:ArrayCollection = new ArrayCollection([
			{label: "特效",value:1},
			{label: "音效",value:2},
			{label: "事件",value:3},
			{label: "延时",value:4},
		]);
		
		public static const COMBOBOX_EFFECT_POS:ArrayCollection = new ArrayCollection([
			{label: "释放者",value:1},
			{label: "目标",value:2},
			{label: "屏幕",value:3},
		]);

		
		public function Constants()
		{
		}
	}
}