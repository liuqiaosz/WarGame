package framework.module.scene
{
//	import flash.display.Sprite;
	import flash.geom.Point;
	import flash.utils.Dictionary;
	
	import framework.core.GameContext;
	import framework.module.asset.AssetsManager;
	import framework.module.msg.MessageConstants;
	import framework.module.scene.vo.ViewParam;
	
	import starling.animation.Transitions;
	import starling.animation.Tween;
	import starling.core.Starling;
	import starling.display.DisplayObject;
	import starling.display.Quad;
	import starling.display.Sprite;
	import starling.events.TouchEvent;

	/**
	 * 场景基类
	 */
	public class SceneBase extends starling.display.Sprite implements IScene
	{
		public static const LAYER_GUIDE:String = "LayerGuide";	//引导层
		public static const LAYER_DRAMA:String = "LayerDrama";	//drama层
		public static const LAYER_UI:String = "LayerUI";	//场景层
		public static const LAYER_DIALOG:String = "LayerDialog";//弹出层
		public static const LAYER_EFFECT:String = "LayerEffect";//特效层
		public static const LAYER_TIP:String = "LayerTip";		//tip层
		public static const LAYER_TOP:String = "LayerTop";
		
		public static const LAYERS:Array = [
			LAYER_UI,LAYER_DRAMA,LAYER_EFFECT,LAYER_GUIDE,LAYER_DIALOG,LAYER_TIP,LAYER_TOP
		];
		private var layers:Vector.<Sprite> = null;	//层
		
		private var regDict:Dictionary = new Dictionary();
		private var insDict:Dictionary = new Dictionary();
		private var _id:String = "";
		private var _viewStack:Vector.<ISceneView> = new Vector.<ISceneView>();
		private var viewPopStack:Vector.<ISceneView> = new Vector.<ISceneView>();
		
		public function get id():String
		{
			return _id;
		}
		public function SceneBase(value:String)
		{
			_id = value;
			//注册字典
			regDict = new Dictionary();
			//场景实例字典
			insDict = new Dictionary();
			
			layers = new Vector.<Sprite>();
			var gameLayer:Sprite = null;
//			var scale:Number = GameContext.instance.dpiScale();
			for each(var layer:String in LAYERS)
			{
				gameLayer = new Sprite();
				addChild(gameLayer);
				gameLayer.name = layer;
				layers.push(gameLayer);
			}
			
			screenWidth = GameContext.STAND_WIDTH;
			screenHeight = GameContext.STAND_HEIGHT;
//			scaleRatio = screenWidth / GameContext.STAND_WIDTH;
//			scaleRatio = screenHeight / GameContext.STAND_HEIGHT;
		}
		
		public function scale(ratio:Number):void
		{
//			var realHeight:int = GameContext.instance.realContentHeight;
//			var offset:int = ((GameContext.instance.screenFullHeight  - realHeight) >> 1);
//			for each(var layer:Sprite in layers)
//			{
//				layer.y = offset;
//			}
		}
		
		public function findViewById(id:String):ISceneView
		{
			if(hasInstanceView(id))
			{
				return getView(id);
			}
			return null;
		}
		
		private var curPopView:String = "";
		private function onPopView(id:String,params:Object = null):void
		{
			var arg:ViewParam = params as ViewParam;
			if(arg && arg.view != curPopView)
			{
				curPopView = arg.view;
				var ins:Boolean = hasInstanceView(arg.view);
				var view:ISceneView = getView(arg.view);
				if(view && !view.isViewShow)
				{
					view.data = arg.data;
					if(!ins && view)
					{
						var res:Array = view.getResource();
						if(res)
						{
							loadViewResource(view,null,null,function():void{
								view.onShow();
//								DialogManager.instance.showDialog(view as DisplayObject,arg);
								showDialog(view as DisplayObject,arg);
								curPopView = "";
							});
						}
						else
						{
							view.onShow();
//							DialogManager.instance.showDialog(view as DisplayObject,arg);
							showDialog(view as DisplayObject,arg);
							curPopView = "";
						}
					}
					else
					{
						view.onShow();
//						DialogManager.instance.showDialog(view as DisplayObject,arg);
						showDialog(view as DisplayObject,arg);
						curPopView = "";
					}
					if(viewPopStack.indexOf(view) < 0)
					{
						viewPopStack.push(view);
					}
				}
			}
		}
		
		/**
		 * 显示视图消息响应
		 */
		private function onShowView(id:String,params:Object = null):void
		{
			var args:Array = params as Array;
			if(args && args.length)
			{
				showView(args[0],args);
			}
		}
		
		/**
		 * 隐藏视图响应
		 */
		private function onHideView(id:String,params:Object = null):void
		{
			hideView(params as String);
		}
		
		/**
		 * 卸载场景
		 */
		override public function dispose():void
		{
			onHide();
			for each(var id:ISceneView in insDict)
			{
				if(_viewStack.indexOf(id) >= 0)
				{
					_viewStack.splice(_viewStack.indexOf(id),1);
				}
				if(viewPopStack.indexOf(id) >= 0)
				{
					viewPopStack.splice(viewPopStack.indexOf(id),1);
				}
				
				id.dispose();
			}
			
			var view:Sprite = null;
			for each(view in _viewStack)
			{
				view.removeFromParent(true);	
			}
			for each(view in viewPopStack)
			{
				view.removeFromParent(true);	
			}

			_viewStack = null;
			viewPopStack = null;
			insDict = null;
			regDict = null;
			//移除监听
			super.dispose();
		}
		
		/**
		 * 暂停场景
		 */
		public function onShow():void
		{
//			if(insDict)
//			{
//				var offset:Point = new Point();
//				for each(var view:ISceneView in insDict)
//				{
//					addChild(view as starling.display.Sprite);
//				}
//			}
			addViewListener(MessageConstants.MSG_VIEW_SHOWVIEW,onShowView);
			addViewListener(MessageConstants.MSG_VIEW_HIDEVIEW,onHideView);
			addViewListener(MessageConstants.MSG_VIEW_POPVIEW,onPopView);
			
//			for each(var view:ISceneView in insDict)
//			{
//				view.onShow();
//			}
			for each(var view:ISceneView in viewPopStack)
			{
				if(currentView != view)
				{
					view.onShow();
				}
			}
			if(currentView)
			{
				currentView.onShow();
			}
			
			sendViewMessage(MessageConstants.MSG_VIEW_SCENESHOWN,this._id);
		}
		
		/**
		 * 关闭场景
		 */
		public function onHide():void
		{
			removeViewListener(MessageConstants.MSG_VIEW_SHOWVIEW,onShowView);
			removeViewListener(MessageConstants.MSG_VIEW_HIDEVIEW,onHideView);
			removeViewListener(MessageConstants.MSG_VIEW_POPVIEW,onPopView);
			
//			for each(var view:ISceneView in insDict)
//			{
//				view.onHide();
//			}
			for each(var view:ISceneView in viewPopStack)
			{
				if(currentView != view)
				{
					view.onHide();
				}
			}
			if(currentView)
			{
				currentView.onHide();
			}
		}
		
		/**
		 * 注册视图
		 */
		public function registerView(id:String,view:Class):void
		{
			regDict[id] = view;
		}
		
		/**
		 * 卸载视图
		 */
		protected function unregisterView(id:String):void
		{
			if(id in regDict)
			{
				delete regDict[id];
			}
			
			if(id in insDict)
			{
				var view:ISceneView = insDict[id];
				delete insDict[id];
				if(view)
				{
					Sprite(view).dispose();
					view = null;
				}
			}
		}
		
		private var currentView:ISceneView = null;
		private var currentViewId:String = "";
		/**
		 * 显示视图，如果没有则先创建再添加
		 */
		//protected function showView(id:String,offset:Point = null,isPop:Boolean = false):void
		protected function showView(id:String,args:Array,isPop:Boolean = false):void
		{
			var ins:Boolean = hasInstanceView(id);
			var view:ISceneView = getView(id);
			//(args.length > 1 ? args[1]:null),(args.length > 2 ? args.length[2] : null)
			var argLen:int = args.length;
			var data:Object = argLen > 1 ? args[1]:null;
			var offset:Point = argLen > 2 ? args[2]:null;
			
			if(view != currentView)
			{
				view.data = data;
				hideView(currentViewId);
			
				if(_viewStack.indexOf(view) >= 0)
				{
					_viewStack.splice(_viewStack.indexOf(view),1);
				}
				_viewStack.push(view);
				currentViewId = id;
				currentView = view;
				
				if(!ins)
				{
					var res:Array = view.getResource();
					if(res)
					{
						loadViewResource(view,offset,data,function():void{
							addView(view,offset,data);
							view.onShow();
						});
					}
					else
					{
						addView(view,offset,data);
						view.onShow();
						view.onShowEnd();
					}
				}
				else
				{
					addView(view,offset,data);
					view.onShow();
					view.onShowEnd();
				}
			}
		}
		
		protected function addView(view:ISceneView,offset:Point,data:Object = null):void
		{
			currentView = view;
			var child:starling.display.Sprite = (view as starling.display.Sprite);
			if(offset)
			{
				child.x = offset.x;
				child.y = offset.y;
			}
//			else
//			{
//				child.x = child.y = 0;
//			}
			this.addChildToLayer(LAYER_UI,child);
			currentView.data = data;
		}
		
		/**
		 * 加载视图必要的资源
		 */
		protected function loadViewResource(view:ISceneView,offset:Point,data:Object = null,complete:Function = null):void
		{
			function loadResComplete():void
			{
				addView(view,offset,data);
			};
			
			function loadResProgress(ratio:Number):void
			{
				
			};
			
			AssetsManager.instance.addLoadQueue(view.getResource(),loadResComplete,loadResProgress);
		}
		
		/**
		 * 隐藏视图
		 * 
		 * @param		id			要隐藏的视图ID
		 * @param
		 */
		protected function hideView(id:String):void
		{
			var view:ISceneView = getView(id);
			if(view)
			{
				var needDispose:Boolean = view.isAutoDispose();
				var child:starling.display.Sprite = (view as starling.display.Sprite);
				var idx:int = _viewStack.indexOf(view);
				if(idx >= 0)
				{
					_viewStack.splice(idx,1);
				}
				
				if(viewPopStack.indexOf(view) >= 0)
				{
//					DialogManager.instance.closeDialog(view as DisplayObject);
					closeDialog(view as DisplayObject);
				}
				else
				{
					if(contains(child))
					{
						this.removeChildByLayer(LAYER_UI,child);
					}
					view.onHide();
				}
				
				if(needDispose)
				{
					view.dispose();
					removeView(id);
				}
				
				currentView = null;
				if(_viewStack.length)
				{
					currentView = _viewStack[_viewStack.length - 1];
				}
			}
		}
		
		/**
		 * 视图是否初始化
		 */
		private function hasInstanceView(id:String):Boolean
		{
			return (insDict && id in insDict);
		}
		
		private function getView(id:String):ISceneView
		{
			var view:ISceneView = null;
			if(!(id in insDict))
			{
				if(id in regDict)
				{
					var cls:Class = regDict[id];
					view = insDict[id] = new cls(id);
				}
			}
			else
			{
				view = insDict[id];
			}
			return view;
		}
		
		private function removeView(id:String):void
		{
			if(id in insDict)
			{
				delete insDict[id];
			}
		}
		
		
		public function changeView(view:String,offset:Point = null):void
		{
			var viewIns:ISceneView = getView(view);
//			if(view && (view in insDict))
			if(view)
			{
				showView(view,[view,offset]);
			}
		}
		
		public function findLayerById(id:String):Sprite
		{
			return getChildByName(id) as Sprite;
		}
		
		/**
		 * 添加到指定层级
		 */
		public function addChildToLayer(layerName:String,child:DisplayObject,offset:Point = null,convert:Boolean = false):void
		{
			var layer:Sprite = getChildByName(layerName) as Sprite;
			if(layer)
			{
				if(offset)
				{
					if(convert)
					{
						offset = layer.globalToLocal(offset);
					}
					child.x = offset.x;
					child.y = offset.y;
				}
				layer.addChild(child);
			}
		}
		
		public function removeChildByLayer(layerName:String,child:DisplayObject):void
		{
			var layer:Sprite = getChildByName(layerName) as Sprite;
			if(layer && layer.contains(child))
			{
				layer.removeChild(child);
			}
		}
		
		public function needDispose():Boolean
		{
			return false;
		}
		
		//DIALOG logic
		private var viewQueue:Array = [];
		private var currentDialogView:DisplayObject = null;
		public static const ANIMATION_DURATION:Number = .2;
		private var dialogMask:Quad = null;
		private var dialogShow:Boolean = false;
		private var screenWidth:int = 0;
		private var screenHeight:int = 0;
		private var scaleRatio:Number = 1;
		private var dialogShowView:DisplayObject = null;
		private var showAnimDict:Dictionary = new Dictionary();
		private function onTouchListener(event:TouchEvent):void
		{
			event.stopImmediatePropagation();
			event.stopPropagation();
		}
		/**
		 * 在弹出层显示对象
		 */
		//		public function showDialog(view:DisplayObject,pos:Point = null,mode:Boolean = true,anim:Boolean = true,maskAlpha:Number = .75,offset):void
		public function showDialog(view:DisplayObject,arg:ViewParam = null):void
		{
			var param:ViewParam = arg;
			if(!param)
			{
				param = new ViewParam();
			}
			if(!dialogMask)
			{
				dialogMask = new Quad(screenWidth,screenHeight,0);
				dialogMask.alpha = param.maskAlpha;
				dialogMask.touchable = true;
			}
			else
			{
				if(dialogMask.alpha != param.maskAlpha)
				{
					dialogMask.alpha = param.maskAlpha;
				}
			}
			
			if(view)
			{
				if(currentDialogView == view)
				{
					return;
				}
				
				dialogMask.visible = param.mode;
				var idx:int = viewQueue.indexOf(view);
				if(idx >= 0)
				{
					viewQueue.splice(idx,1);
				}
				
//				viewQueue.push(view);
				currentDialogView = view;
				showAnimDict[view] = param.anim;
				var viewWidth:int = 0;
				var viewHeight:int = 0;
				if(!param.pos)
				{
					if(view is ISceneView)
					{
						viewWidth = ISceneView(view).viewBounds.width;
						viewHeight = ISceneView(view).viewBounds.height;
					}
					else
					{
						viewWidth = view.width;
						viewHeight = view.height;
					}
					var posX:int = (screenWidth - viewWidth) >> 1;
					var posY:int = (screenHeight - viewHeight) >> 1;
//					if(param.anim)
					if(false)
					{
						posX += (param.offset ? param.offset.x:0);
						posY += (param.offset ? param.offset.y:0);
						currentDialogView.x = screenWidth >> 1;
						currentDialogView.y = screenHeight >> 1;
						var eff:Tween = new Tween(currentDialogView,ANIMATION_DURATION,Transitions.EASE_IN_OUT_BACK);
						eff.animate("scaleX", currentDialogView.scaleX);
						eff.animate("scaleY", currentDialogView.scaleY);
						eff.animate("x", posX);
						eff.animate("y", posY);
						currentDialogView.scaleX = currentDialogView.scaleY = 0;
						eff.onComplete = function():void{
							dialogShow = false;
							onDialogShown(view);
						};
						Starling.juggler.add(eff); 
					}
					else
					{
						currentDialogView.x = posX;
						currentDialogView.y = posY;
//						onDialogShown(currentDialogView);
					}
				}
				else
				{
					currentDialogView.x = param.pos.x + (param.offset ? param.offset.x:0);
					currentDialogView.y = param.pos.y + (param.offset ? param.offset.y:0);
//					onDialogShown(currentDialogView);
				}
				
				//				SceneManager.instance.addChildToLayer(SceneManager.LAYER_DIALOG,dialogMask);
				//				SceneManager.instance.addChildToLayer(SceneManager.LAYER_DIALOG,currentDialo
//				SceneManager.instance.addChildToLayer(param.layer,dialogMask);
//				SceneManager.instance.addChildToLayer(param.layer,currentDialogView);
				addChildToLayer(param.layer,dialogMask);
				addChildToLayer(param.layer,currentDialogView);
				dialogShowView = view;
//				dialogShow = true;
				dialogShow = false;
				onDialogShown(currentDialogView);
			}
		}
		
		private function onDialogShown(view:DisplayObject):void
		{
			if(view is ISceneView)
			{
				ISceneView(view).onShowEnd();
			}
			else if("onShow" in view)
			{
				view["onShow"]();
			}
			if(viewQueue.indexOf(view) < 0)
			{
				viewQueue.push(view);
			}
		}
		
		/**
		 * 关闭指定的弹出视图，如指定的视图为空则关闭最上层的
		 */
		public function closeDialog(view:DisplayObject,dispose:Boolean = false):void
		{
			if(view)
			{
				if(viewQueue.indexOf(view) >= 0)
				{
					var anim:Boolean = true;
					if(view in showAnimDict)
					{
						anim = showAnimDict[view];
					}
					
					if(anim)
					{
	//					var eff:Tween = new Tween(currentDialogView,ANIMATION_DURATION,Transitions.EASE_IN_OUT_BACK);
	//					eff.animate("scaleX", 0);
	//					eff.animate("scaleY", 0);
	//					eff.animate("x", (screenWidth >> 1));
	//					eff.animate("y", (screenHeight >> 1));
	//					eff.onComplete = function():void{
	//						closeAndComplete(view,dispose);
	//					};
	//					Starling.juggler.add(eff); 
						closeAndComplete(view,dispose);
					}
					else
					{
						closeAndComplete(view,dispose);
					}
				}
				else
				{
					view.removeFromParent(dispose);
				}
				dialogShow = false;
				//				var layer:Sprite = SceneManager.instance.findLayerById(SceneManager.LAYER_UI);
				//				layer.touchable = true;
			}
		}
		
		private function closeAndComplete(view:DisplayObject,dispose:Boolean = false):void
		{
			if(view is ISceneView)
			{
				ISceneView(view).onHide();	
			}
			
			var idx:int = viewQueue.indexOf(view);
			
			view.removeFromParent(dispose);
			if(idx>=0)
			{
				viewQueue.splice(idx,1);
			}
			idx = viewPopStack.indexOf(view);
			
			if(idx >= 0)
			{
				viewPopStack.splice(idx,1);
			}
			if(viewQueue.length)
			{
				currentDialogView = viewQueue[viewQueue.length - 1];
				curPopView = "";
				dialogMask.visible = true;
//				dialogMask.parent.addChild(dialogMask);
				currentDialogView.parent.addChild(dialogMask);
				currentDialogView.parent.addChild(currentDialogView);
				
			}
			else
			{
//				if(!dialogShow)
//				{
//					dialogMask.visible = false;
//					currentDialogView = null;
//				}
				dialogMask.visible = false;
				currentDialogView = null;
			}
		}
		
		public function closeAll():void
		{
			var tmp:Array = viewQueue.concat();
			for each(var view:Sprite in tmp)
			{
//				view.removeFromParent();
				closeDialog(view,false);
			}
			tmp = null;
			viewQueue = [];
			currentDialogView = null;
		}
	}
}