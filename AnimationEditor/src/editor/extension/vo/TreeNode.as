package editor.extension.vo
{
	import editor.utility.FileInfo;

	public class TreeNode
	{
		public var id:String = "";
		public var filePath:String = "";
		public var fileName:String = "";
		public var loaded:Boolean = false;
		public var childrenFiles:Vector.<FileInfo> = null;
		public var isDirectory:Boolean = false;
		public var content:Object = null;//文件内容
		public function TreeNode()
		{
		}
	}
}