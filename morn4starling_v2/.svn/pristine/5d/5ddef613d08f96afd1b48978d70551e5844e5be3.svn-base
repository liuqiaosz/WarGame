/**
 * Morn UI Version 2.4.1020 http://www.mornui.com/
 * Feedback yungzhu@gmail.com http://weibo.com/newyung
 */
package {
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	
	import morn.core.components.View;
	import morn.core.events.UIEvent;
	import morn.core.handlers.Handler;
	import morn.core.managers.AssetManager;
	import morn.core.managers.DialogManager;
	import morn.core.managers.DragManager;
	import morn.core.managers.LangManager;
	import morn.core.managers.LoaderManager;
	import morn.core.managers.LogManager;
	import morn.core.managers.RenderManager;
	import morn.core.managers.TimerManager;
	import morn.core.managers.TipManager;
	
	import starling.display.Sprite;
	import starling.display.Stage;
	
	/**全局引用入口*/
	public class App {
		/**全局stage引用*/
		public static var stage:Stage;
		/**资源管理器*/
		public static var asset:AssetManager = new AssetManager();
		/**加载管理器*/
		public static var loader:LoaderManager = new LoaderManager();
		/**时钟管理器*/
		public static var timer:TimerManager = new TimerManager();
		/**渲染管理器*/
		public static var render:RenderManager = new RenderManager();
		/**对话框管理器*/
		public static var dialog:DialogManager = new DialogManager();
		/**日志管理器*/
		public static var log:LogManager = new LogManager();
		/**提示管理器*/
		public static var tip:TipManager = new TipManager();
		/**拖动管理器*/
		public static var drag:DragManager = new DragManager();
		/**语言管理器*/
		public static var lang:LangManager = new LangManager();
		
		private static var complete:Function = null;
		public static function init(main:Sprite,onComplete:Function = null):void {
			stage = main.stage;
//			stage.frameRate = Config.GAME_FPS;
//			stage.scaleMode = StageScaleMode.NO_SCALE;
//			stage.align = StageAlign.TOP_LEFT;
//			stage.stageFocusRect = false;
//			stage.tabChildren = false;
			
			//覆盖配置
			var gameVars:Object = null;//stage.loaderInfo.parameters;
			if (gameVars != null) {
				for (var s:String in gameVars) {
					if (Config[s] != null) {
						Config[s] = gameVars[s];
					}
				}
			}
			
//			stage.addChild(dialog);
//			stage.addChild(tip);
//			stage.addChild(log);
			complete = onComplete;
			//如果UI视图是加载模式，则进行整体加载
			if (Boolean(Config.uiPath)) {
				App.loader.loadDB(Config.uiPath, new Handler(onUIloadComplete));
			}
			else
			{
				if(null != complete)
				{
					complete();
				}
			}
		}
		
		private static function onUIloadComplete(content:*):void {
			View.xmlMap = content;
			if(null != complete)
			{
				complete();
			}
		}
		
		/**获得资源路径(此处可以加上资源版本控制)*/
		public static function getResPath(url:String):String {
			return /^http:\/\//g.test(url) ? url : Config.resPath + url;
		}
	}
}