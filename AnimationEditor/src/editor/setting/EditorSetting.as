package editor.setting
{
	import editor.setting.vo.Setting;
	import editor.setting.vo.SettingDirectory;
	import editor.utility.Constants;
	import editor.utility.EditorStorageTools;
	
	import flash.utils.ByteArray;

	/**
	 * 编辑器一些常规设置
	 * 
	 **/
	public class EditorSetting
	{
		private static var _instance:EditorSetting = null;
		public static function get instance():EditorSetting
		{
			if(!_instance)
			{
				_instance = new EditorSetting();
				_instance.initializer();
			}
			return _instance;
		}
		
		private var _setting:Setting = null;
		public function get setting():Setting
		{
			return _setting;
		}
		private function initializer():void
		{
			_setting = new Setting();
			//load config from storage
			var data:ByteArray = EditorStorageTools.load(Constants.EDITOR_SETTING_FILE);
			if(data)
			{
				var json:String = data.readUTFBytes(data.length);
				var obj:Object = JSON.parse(json);
				if(obj.hasOwnProperty("directory"))
				{
					_setting.directory = new SettingDirectory();
					_setting.directory.cfgDirectory = obj.directory.cfgDirectory;
					_setting.directory.avatarDirectory = obj.directory.avatarDirectory;
					_setting.directory.effectDirectory = obj.directory.effectDirectory;
					_setting.directory.publisherDirectory = obj.directory.publisherDirectory;
				}
			}
		}
		
		/**
		 * 保存设置
		 **/
		public function save():void
		{
			EditorStorageTools.load(Constants.EDITOR_SETTING_FILE);
			if(_setting)
			{
				var value:String = JSON.stringify(_setting);
				var data:ByteArray = new ByteArray();
				data.writeUTFBytes(value);
				EditorStorageTools.save(Constants.EDITOR_SETTING_FILE,data);
				
				if(null != _onUpdate)
				{
					_onUpdate();
				}
			}
		}
		
		private var _onUpdate:Function = null;
		public function set onUpdate(value:Function):void
		{
			_onUpdate = value;
		}
		
		public function EditorSetting()
		{
			
		}
	}
}