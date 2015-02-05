package framework.core
{
	import flash.display.Bitmap;
	import flash.display.LoaderInfo;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.events.IEventDispatcher;
	import flash.geom.Rectangle;
	import flash.system.Capabilities;
	import flash.text.TextField;
	
//	import guoyou.framework.module.anim.AnimationManager;
	import framework.module.asset.AssetsManager;
	import framework.module.cfg.ConfigManager;
	import framework.module.notification.NotificationIds;
	import framework.module.scene.SceneManager;
	import framework.module.sound.SoundManager;
	
	import starling.core.Starling;
	import starling.events.Event;
	import starling.utils.RectangleUtil;
	import starling.utils.ScaleMode;

	public class GameApp extends Sprite
	{
		private var restore:Bitmap = null;
		private var slash:Bitmap = null;
		private var starlingApp:Starling = null;
		public function GameApp(args:Object = null)
		{
			addEventListener(flash.events.Event.ADDED_TO_STAGE,onAdded);
			GameContext.instance.appArgs = args;
		}
		
		private function onAdded(event:flash.events.Event):void
		{
			removeEventListener(flash.events.Event.ADDED_TO_STAGE,onAdded);
			AssetsManager.instance.initializer();
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
			GameContext.instance.flashStage = stage;
//			var loaderInfo:LoaderInfo = stage.loaderInfo;
//			if (loaderInfo.hasOwnProperty('uncaughtErrorEvents'))
//			{
//				IEventDispatcher(loaderInfo["uncaughtErrorEvents"]).addEventListener("uncaughtError", uncaughtErrorHandler);
//			}
			
			addFrameworkListener(NotificationIds.MSG_FMK_START_COMPLETE,onStartComplete);

			if(GameContext.instance.appArgs)
			{
				if(GameContext.instance.appArgs.hasOwnProperty("slash"))
				{
					//构建slash页面
					slash = GameContext.instance.appArgs.slash as Bitmap;
//					slash.scaleX = GameContext.instance.screenFullWidth / slash.width;
					slash.scaleY = GameContext.instance.screenFullHeight / slash.height;
					slash.scaleX = slash.scaleY;
					
					slash.x = ((GameContext.instance.screenFullWidth - slash.width) >> 1);
//					slash.x = -(((slash.scaleY - 1) * slash.width) >> 1);
					stage.addChild(slash);
				}
				
				if(GameContext.instance.appArgs.hasOwnProperty("restore"))
				{
					restore = GameContext.instance.appArgs.restore as Bitmap;
				}
			}
			startGame();
		}
		
//		private function uncaughtErrorHandler(evt:ErrorEvent):void 
//		{
//			//取消默认的错误弹框
//			evt.preventDefault();
//			
////			var info:String = getErrorEventDetail(evt);
//			//MSG_LOGIC_ERROR
//			trace("error:global");
//			sendLogicMessage(MessageConstants.MSG_LOGIC_ERROR,evt);
//		}
		
		private function onStartComplete(id:String,params:Object = null):void
		{
			if(GameContext.instance.appArgs)
			{
				if(GameContext.instance.appArgs.hasOwnProperty("preload"))
				{
					//预加载资源
					AssetsManager.instance.addLoadQueue(GameContext.instance.appArgs.preload as Array,
						function():void{
							addFrameworkListener(NotificationIds.MSG_FMK_FRAME_UPDATE,onFrameUpdate);
							onStageReady();
						},
						function(ratio:Number):void{
							
						});
				}
			}
			else
			{
				addFrameworkListener(NotificationIds.MSG_FMK_FRAME_UPDATE,onFrameUpdate);
				onStageReady();
			}
		}
		
		private function onFrameUpdate(id:String,params:Object = null):void
		{
			onUpdate(int(params));
		}
		
		protected function onUpdate(t:Number):void
		{
			
		}
		
		protected function onStageReady():void
		{
			//音效模块管理器
			SoundManager.instance.initializer();
			//场景模块管理器
			SceneManager.instance.initializer();
			//配置管理器
			ConfigManager.instance.initializer();
		}
		
		/**
		 * 关闭SLASH界面
		 */
		protected function closeSlashScreen():void
		{
			if(slash && stage.contains(slash))
			{
				stage.removeChild(slash);
				slash.bitmapData.dispose();
				slash.bitmapData = null;
				slash = null;
			}
		}
		
		/**
		 * 开始游戏
		 * 
		 */
		protected function startGame():void
		{
			if((Capabilities.version.substr(0, 3) == "AND"))
			{
				Starling.handleLostContext = true;
			}
			
//			var viewport:Rectangle=new Rectangle(0,0,stage.fullScreenWidth,stage.fullScreenHeight);
			var viewport:Rectangle = RectangleUtil.fit( new Rectangle(0, 0, stage.fullScreenWidth, stage.fullScreenHeight), 
				new Rectangle(0, 0, stage.fullScreenWidth, stage.fullScreenHeight), 
				ScaleMode.SHOW_ALL);
			
			starlingApp = new Starling(StarlingGame,stage,viewport);
//			starlingApp.stage.stageWidth = 1930;
//			starlingApp.stage.stageHeight = 1080;
			starlingApp.start();
		}
		
		private var isRestoreShow:Boolean = false;
		protected function showRestore():void
		{
			if(restore && !isRestoreShow)
			{
				restore.scaleY = GameContext.instance.screenFullHeight / restore.height;
				restore.scaleX = restore.scaleY;
				restore.x = ((GameContext.instance.screenFullWidth - restore.width) >> 1);
				stage.addChild(restore);
				isRestoreShow = true;
			}
		}
		
		protected function hideRestore():void
		{
//			starlingApp.removeEventListener(starling.events.Event.TEXTURES_RESTORED,onRestoreComplete);
			isRestoreShow = false;
			if(restore)
			{
				stage.removeChild(restore);
			}
		}
	}
}