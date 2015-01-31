package framework.common.dialog
{
	import flash.geom.Point;
	import flash.utils.Dictionary;
	
	import framework.core.GameContext;
	import framework.module.scene.ISceneView;
	import framework.module.scene.SceneBase;
	import framework.module.scene.SceneManager;
	import framework.module.scene.vo.ViewParam;
	
	import starling.animation.Transitions;
	import starling.animation.Tween;
	import starling.core.Starling;
	import starling.display.DisplayObject;
	import starling.display.Quad;
	import starling.display.Sprite;
	import starling.events.TouchEvent;

	/**
	 * 弹出窗口提示管理
	 */
	public class DialogManager
	{
//		public static const ANIMATION_DURATION:Number = .2;
		private static var _instance:DialogManager = null;
//		private var dialogMask:Quad = null;
//		private var dialogShow:Boolean = false;
//		private var screenWidth:int = 0;
//		private var screenHeight:int = 0;
//		private var scaleRatio:Number = 1;
//		private var showAnimDict:Dictionary = new Dictionary();
		public function DialogManager()
		{
//			screenWidth = GameContext.instance.screenFullWidth;
//			screenHeight = GameContext.instance.screenFullHeight;
//			screenWidth = 1920;
//			screenHeight = 1080;
//			scaleRatio = screenWidth / GameContext.STAND_WIDTH;
		}
		
		public static function get instance():DialogManager
		{
			if(!_instance)
			{
				_instance = new DialogManager();
			}
			return _instance;
		}
		
//		private var viewQueue:Array = [];
//		private var currentDialogView:DisplayObject = null;
//		
//		private function onTouchListener(event:TouchEvent):void
//		{
//			event.stopImmediatePropagation();
//			event.stopPropagation();
//		}
		/**
		 * 在弹出层显示对象
		 */
//		public function showDialog(view:DisplayObject,pos:Point = null,mode:Boolean = true,anim:Boolean = true,maskAlpha:Number = .75,offset):void
		public function showDialog(view:DisplayObject,arg:ViewParam = null):void
		{
			var scene:SceneBase = SceneManager.instance.getCurrentSceneLayer() as SceneBase;
			scene.showDialog(view,arg);
//			var param:ViewParam = arg;
//			if(!param)
//			{
//				param = new ViewParam();
//			}
//			if(!dialogMask)
//			{
//				dialogMask = new Quad(screenWidth,screenHeight,0xff0000);
//				dialogMask.alpha = param.maskAlpha;
//				dialogMask.touchable = true;
//			}
//			else
//			{
//				if(dialogMask.alpha != param.maskAlpha)
//				{
//					dialogMask.alpha = param.maskAlpha;
//				}
//			}
//			
//			if(view)
//			{
//				dialogMask.visible = param.mode;
//				var idx:int = viewQueue.indexOf(view);
//				if(idx >= 0)
//				{
//					viewQueue.splice(idx,1);
//				}
//				viewQueue.push(view);
//				currentDialogView = view;
//				showAnimDict[view] = param.anim;
//				var viewWidth:int = 0;
//				var viewHeight:int = 0;
//				if(!param.pos)
//				{
//					if(view is ISceneView)
//					{
//						viewWidth = ISceneView(view).viewBounds.width;
//						viewHeight = ISceneView(view).viewBounds.height;
//					}
//					else
//					{
//						viewWidth = view.width;
//						viewHeight = view.height;
//					}
//					var posX:int = (screenWidth - viewWidth) >> 1;
//					var posY:int = (screenHeight - viewHeight) >> 1;
//					if(param.anim)
//					{
//						currentDialogView.x = screenWidth >> 1;
//						currentDialogView.y = screenHeight >> 1;
//						posX += (param.offset ? param.offset.x:0);
//						posY += (param.offset ? param.offset.y:0);
//						var eff:Tween = new Tween(currentDialogView,ANIMATION_DURATION,Transitions.EASE_IN_OUT_BACK);
//						currentDialogView.scaleX = currentDialogView.scaleY = 0;
//						eff.onComplete = onDialogShown;
//						eff.animate("scaleX", 1);
//						eff.animate("scaleY", 1);
//						eff.animate("x", posX);
//						eff.animate("y", posY);
//						Starling.juggler.add(eff); 
//					}
//					else
//					{
//						currentDialogView.x = posX;
//						currentDialogView.y = posY;
//					}
//				}
//				else
//				{
//					currentDialogView.x = param.pos.x + (param.offset ? param.offset.x:0);
//					currentDialogView.y = param.pos.y + (param.offset ? param.offset.y:0);
//				}
//				
////				SceneManager.instance.addChildToLayer(SceneManager.LAYER_DIALOG,dialogMask);
////				SceneManager.instance.addChildToLayer(SceneManager.LAYER_DIALOG,currentDialo
//				SceneManager.instance.addChildToLayer(param.layer,dialogMask);
//				SceneManager.instance.addChildToLayer(param.layer,currentDialogView);
//				dialogShow = true;
//			}
		}
		
//		private function onDialogShown():void
//		{
//			if(currentDialogView is ISceneView)
//			{
//				ISceneView(currentDialogView).onShowEnd();
//			}
//		}
		
		/**
		 * 关闭指定的弹出视图，如指定的视图为空则关闭最上层的
		 */
		public function closeDialog(view:DisplayObject,dispose:Boolean = false):void
		{
			var scene:SceneBase = SceneManager.instance.getCurrentSceneLayer() as SceneBase;
			scene.closeDialog(view,dispose);
//			if(view && viewQueue.indexOf(view) >= 0)
//			{
//				var anim:Boolean = true;
//				if(view in showAnimDict)
//				{
//					anim = showAnimDict[view];
//				}
//				
//				if(anim)
//				{
//					var eff:Tween = new Tween(currentDialogView,ANIMATION_DURATION,Transitions.EASE_IN_OUT_BACK);
//					eff.animate("scaleX", 0);
//					eff.animate("scaleY", 0);
//					eff.animate("x", (screenWidth >> 1));
//					eff.animate("y", (screenHeight >> 1));
//					eff.onComplete = function():void{
//						closeAndComplete(view,dispose);
//					};
//					Starling.juggler.add(eff); 
//				}
//				else
//				{
//					closeAndComplete(view,dispose);
//				}
//				dialogShow = false;
////				var layer:Sprite = SceneManager.instance.findLayerById(SceneManager.LAYER_UI);
////				layer.touchable = true;
//			}
		}
		
//		private function closeAndComplete(view:DisplayObject,dispose:Boolean = false):void
//		{
//			var idx:int = viewQueue.indexOf(view);
//			dialogMask.visible = false;
//			view.removeFromParent(dispose);
//			if(idx>=0)
//			{
//				viewQueue.splice(idx,1);
//			}
//			if(viewQueue.length)
//			{
//				currentDialogView = viewQueue[viewQueue.length - 1];
//				
//				dialogMask.visible = true;
//				dialogMask.parent.addChild(dialogMask);
//				currentDialogView.parent.addChild(currentDialogView);
//				
//			}
//			else
//			{
//				currentDialogView = null;
//			}
//		}
//		
		public function closeAll():void
		{
//			for each(var view:Sprite in viewQueue)
//			{
//				view.removeFromParent();
//			}
//			viewQueue = [];
//			currentDialogView = null;
			var scene:SceneBase = SceneManager.instance.getCurrentSceneLayer() as SceneBase;
			scene.closeAll();
		}
	}
}