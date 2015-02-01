package editor.utility
{
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.utils.ByteArray;

	/**
	 * 编辑器私有存储的工具类
	 **/
	public class EditorStorageTools
	{
		public function EditorStorageTools()
		{
		}
		
		/**
		 * 保存文件到私有存储
		 **/
		public static function save(filePath:String,data:ByteArray):Boolean
		{
			var file:File = File.applicationStorageDirectory.resolvePath(filePath);
			var writer:FileStream = new FileStream();
			writer.open(file,FileMode.WRITE);
			writer.writeBytes(data);
			writer.close();
			return true;
		}
		
		public static function load(filePath:String):ByteArray
		{
			var file:File = File.applicationStorageDirectory.resolvePath(filePath);
			if(file.exists)
			{
				var reader:FileStream = new FileStream();
				reader.open(file,FileMode.READ);
				var data:ByteArray = new ByteArray();
				reader.readBytes(data);
				return data;
			}
			return null;
		}
	}
}