package editor.extension
{
	import flash.events.Event;

	public class ExEvent extends Event
	{
		public static const UI_MENU_SELECT:String = "onMenuSelect";
		public static const UI_PROGRESS_UPDATE:String = "onProgress";
		
		public static const UI_TREE_SELECT_FILE:String = "onTreeFileSelect";
		public static const UI_TREE_SELECT_DIR:String = "onTreeDirectorySelect";
		
		public var params:Object = null;
		public function ExEvent(type:String,bubbles:Boolean = true)
		{
			super(type,bubbles);
		}
	}
}