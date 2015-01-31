package framework.module.cfg
{
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.utils.ByteArray;
	
	import framework.common.CommonTools;
	import framework.core.GameContext;

	public class ConfigLoader
	{
		public function ConfigLoader()
		{
			
		}
		
		public function load(path:String):Boolean
		{
			var cfgFile:File = GameContext.instance.appDirectory.resolvePath(path);
			if(cfgFile.exists)
			{
				var reader:FileStream = new FileStream();
				reader.open(cfgFile,FileMode.READ);
				var data:ByteArray = new ByteArray();
				reader.readBytes(data);
				data.position = 0;
				var suffix:String = CommonTools.getSuffix(path);
				var cfgData:String = "";
				if(suffix == "xml")
				{
					cfgData = data.readUTFBytes(data.length);
					parse(new XML(cfgData));
				}
				else if(suffix == "json")
				{
					cfgData = data.readUTFBytes(data.length);
					var json:Object = JSON.parse(cfgData);
					parse(json);
				}
				else if(suffix == "xlsx")
				{
					parse(data);
				}
				else
				{
					cfgData = data.readUTFBytes(data.length);
					parse(cfgData);
				}
				return true;
			}
			else
			{
				parse(null);
			}
			return false;
		}

		
		protected function parse(cfg:Object):void
		{
			
		}
	}
}