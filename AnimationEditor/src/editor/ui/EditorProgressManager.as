package editor.ui
{
	import flash.display.DisplayObject;
	
	import mx.core.FlexGlobals;
	import mx.core.IFlexDisplayObject;
	import mx.managers.PopUpManager;

	/**
	 * 需要锁屏显示进度的界面管理器
	 * 
	 **/
	public class EditorProgressManager
	{
		private static var _instance:EditorProgressManager = null;
		public static function get instance():EditorProgressManager
		{
			if(!_instance)
			{
				_instance = new EditorProgressManager();
			}
			return _instance;
		}
		
		private var _view:EditorProgressPanel = null;
		public function showProgress():void
		{
			if(!_view)
			{
				_view = new EditorProgressPanel();
			}
			
			PopUpManager.addPopUp(_view as IFlexDisplayObject,FlexGlobals.topLevelApplication as DisplayObject,true);
			PopUpManager.centerPopUp(_view);
			PopUpManager.bringToFront(_view);
		}
		public function hideProgress():void
		{
			PopUpManager.removePopUp(_view);
		}
		public function updateProgress(current:int,total:int):void
		{
			
		}
		
		public function update(title:String,content:String):void
		{
			_view.title = title;
			_view.content = content;
		}
		
		public function EditorProgressManager()
		{
		}
	}
}