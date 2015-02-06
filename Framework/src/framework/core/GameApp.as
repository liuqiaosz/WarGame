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
	
	import framework.device.DeviceInfo;
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
			var success:Boolean = GameContext.instance.initContext(stage);
			if(success)
			{
				addFrameworkListener(NotificationIds.MSG_FMK_START_COMPLETE,onStartComplete);
				if(GameContext.instance.appArgs)
				{
					if(GameContext.instance.appArgs.hasOwnProperty("slash"))
					{
						//构建slash页面
						slash = GameContext.instance.appArgs.slash as Bitmap;
						slash.scaleY = GameContext.instance.flashStage.height / slash.height;
						slash.scaleX = slash.scaleY;
						slash.x = ((GameContext.instance.flashStage.width - slash.width) >> 1);
						stage.addChild(slash);
					}
					
					if(GameContext.instance.appArgs.hasOwnProperty("restore"))
					{
						restore = GameContext.instance.appArgs.restore as Bitmap;
					}
				}
				startStarling();
			}
			else
			{
				//初始化失败
			}
		}
		
		
		private function onStartComplete(params:Object = null):void
		{
			if(GameContext.instance.appArgs)
			{
				if(GameContext.instance.appArgs.hasOwnProperty("preload"))
				{
					//预加载资源
					AssetsManager.instance.addLoadQueue(GameContext.instance.appArgs.preload as Array,
						function():void{
							onStageReady();
						},
						function(ratio:Number):void{
							
						});
				}
				else
				{
					onStageReady();
				}
			}
			else
			{
				
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
		
		private function onStageReady():void
		{
			//音效模块管理器
			SoundManager.instance.initializer();
			//场景模块管理器
			SceneManager.instance.initializer();
			//配置管理器
			ConfigManager.instance.initializer();
			
			addFrameworkListener(NotificationIds.MSG_FMK_FRAME_UPDATE,onFrameUpdate);
			
			gameReady();
		}
		
		protected function gameReady():void
		{
			
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
		private function startStarling():void
		{
			var info:DeviceInfo = GameContext.instance.getDesignPixelAspect();
			var viewport:Rectangle = new Rectangle(0,0,stage.fullScreenWidth,stage.fullScreenHeight);
			starlingApp = new Starling(StarlingGame,stage,viewport);
			starlingApp.stage.stageWidth = info.screenWidth;
			starlingApp.stage.stageHeight = info.screenHeight;
			starlingApp.start();
		}
	}
}