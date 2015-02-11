package framework.module.scene
{
//	import flash.display.Sprite;
	import flash.geom.Point;
	import flash.utils.Dictionary;
	
	import framework.core.GameContext;
	import framework.module.notification.NotificationIds;
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
	public class SceneBase extends Sprite implements IScene
	{
		public static const LAYER_GUIDE:String = "LayerGuide";	//引导层
		public static const LAYER_DRAMA:String = "LayerDrama";	//drama层
		public static const LAYER_UI:String = "LayerUI";	//场景层
		public static const LAYER_DIALOG:String = "LayerDialog";//弹出层
		public static const LAYER_EFFECT:String = "LayerEffect";//特效层
		public static const LAYER_TIP:String = "LayerTip";		//tip层
		public static const LAYER_TOP:String = "LayerTop";
		public static const ANIMATION_DURATION:Number = .2;
		public static const LAYERS:Array = [
			LAYER_UI,LAYER_DRAMA,LAYER_EFFECT,LAYER_GUIDE,LAYER_DIALOG,LAYER_TIP,LAYER_TOP
		];
		private var layers:Vector.<Sprite> = null;	//层
		
		private var regDict:Dictionary = new Dictionary();
		private var insDict:Dictionary = new Dictionary();
		private var _id:String = "";
		private var _views:Vector.<ISceneView> = new Vector.<ISceneView>();
		private var screenWidth:int = 0;
		private var screenHeight:int = 0;
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
			
			screenWidth = GameContext.instance.screenFullWidth;
			screenHeight = GameContext.instance.screenFullHeight;
		}
		
		public function initializer():void
		{
			
		}
		
		public function findViewById(id:String):ISceneView
		{
			if(hasInstanceView(id))
			{
				return getView(id);
			}
			return null;
		}
		
		/**
		 * 显示视图消息响应
		 */
		private function onShowView(params:Object = null):void
		{
			showView(params as ViewParam);
		}
		
		/**
		 * 隐藏视图响应
		 */
		private function onHideView(params:Object = null):void
		{
			hideView(params as ViewParam);
		}
		
		/**
		 * 卸载场景
		 */
		override public function dispose():void
		{
			//onHide();
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
			addViewListener(NotificationIds.MSG_VIEW_SHOWVIEW,onShowView);
			addViewListener(NotificationIds.MSG_VIEW_HIDEVIEW,onHideView);
			
			sendViewMessage(NotificationIds.MSG_VIEW_SCENESHOWN,this._id);
			if(_isPause)
			{
				for(var idx:int = 0; idx<_views.length; idx++)
				{
					_views[idx].resume();
				}
				_isPause = false;
			}
		}
		
		/**
		 * 关闭场景
		 */
		public function onHide():void
		{
			removeViewListener(NotificationIds.MSG_VIEW_SHOWVIEW,onShowView);
			removeViewListener(NotificationIds.MSG_VIEW_HIDEVIEW,onHideView);
			if(!this.needDispose())
			{
				//暂停所有场景
				for(var idx:int = 0; idx<_views.length; idx++)
				{
					_views[idx].pause();
				}
				_isPause = true;
			}
		}
		
		private var _isPause:Boolean = false;
		
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
				if(view in popMaskDict)
				{
					popMaskDict[view].removeFromParent(true);
					delete popMaskDict[view];
				}
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
		
		//当前已经弹出的视图
		private var currentPopupView:ISceneView = null;
		/**
		 * 显示视图,重新实现逻辑
		 **/
		protected function showView(args:ViewParam):void
		{
			if(args.isPop)
			{
				popView(args);
			}
			else
			{
				var view:ISceneView = getView(args.view);
				if(view)
				{
					if(_views.indexOf(view) < 0)//没有显示的视图列表的视图,已经在显示列表的不要显示
					{
						view.data = args.data;//设置视图参数,如果有
						if(!view.isLoaded())
						{
							showProgress();
							view.loadResource(onResourceLoadProgress,function(sceneview:ISceneView):void{
								addViewToScene(view,args);
							});
						}
						else
						{
							//资源已经准备完成
							addViewToScene(view,args);
						}
					}
				}
				else
				{
					//视图为空不处理
				}
			}
		}
		
		private var popMaskDict:Dictionary = new Dictionary();
		//弹出
		protected function popView(args:ViewParam):void
		{
			var view:ISceneView = getView(args.view);
			if(view)
			{
				if(_views.indexOf(view) < 0)//没有显示的视图列表的视图,已经在显示列表的不要显示
				{
					view.data = args.data;//设置视图参数,如果有
					if(!view.isLoaded())
					{
						showProgress();
						view.loadResource(onResourceLoadProgress,function(sceneview:ISceneView):void{
							addViewToScene(view,args);
						});
					}
					else
					{
						//资源已经准备完成
						addViewToScene(view,args);
					}
				}
			}
			else
			{
				//视图为空不处理
			}
		}
		
		protected function hideView(args:ViewParam):void
		{
			var view:ISceneView = getView(args.view);
			if(view)
			{
				if(_views.indexOf(view) >= 0)
				{
					removeViewFromScene(view,args);
				}
			}
		}
		
		private function onResourceLoadProgress(ratio:Number):void
		{
			updateProgress(ratio);
		}
				
		protected function showProgress():void
		{
			
		}
		protected function hideProgress():void
		{
			
		}
		protected function updateProgress(ratio:Number):void
		{
			
		}
		
		protected function playShowViewAnim(view:ISceneView,complete:Function):void
		{
			var posX:int = (screenWidth - view.viewBounds.width) >> 1;
			var posY:int = (screenHeight - view.viewBounds.height) >> 1;
			
			var eff:Tween = new Tween(view as DisplayObject,ANIMATION_DURATION,Transitions.EASE_IN_OUT_BACK);
			
//			var eff:Tween = new Tween(currentDialogView,ANIMATION_DURATION,Transitions.EASE_IN_OUT_BACK);
			eff.scaleTo(1);
			Sprite(view).scaleX = Sprite(view).scaleY = 0;
			Starling.juggler.add(eff);
			eff.onComplete = function():void{
				if(null != complete)
				{
					complete(view);
				}
			};
		}
		
		protected function playHideViewAnim(view:ISceneView,viewid:String,complete:Function):void
		{
			var eff:Tween = new Tween(view as DisplayObject,ANIMATION_DURATION,Transitions.EASE_IN_OUT_BACK);
			eff.scaleTo(0);
			Starling.juggler.add(eff);
			eff.onComplete = function():void{
				if(null != complete)
				{
					complete(viewid,view);
				}
			};
		}
		
		protected function addViewToScene(view:ISceneView,args:ViewParam):void
		{
			var child:Sprite = (view as Sprite);
			if(args.offset)
			{
				child.x = args.offset.x;
				child.y = args.offset.y;
			}
			var layer:String = (args.layer ? args.layer:LAYER_UI);
			if(args.isPop)
			{
				//添加遮罩
				var mask:Quad = new Quad(GameContext.instance.screenFullWidth,GameContext.instance.screenFullHeight,0,true);
				mask.alpha = args.maskAlpha;
				addChildToLayer(layer,mask);
				popMaskDict[view] = mask;
			}
			addChildToLayer(layer,view as Sprite);
			view.onShow();
			
			if(args.anim)
			{
				playShowViewAnim(view,onShowAnimationComplete);
			}
			else
			{
				onShowAnimationComplete(view);
			}
		}
		
		private function onShowAnimationComplete(view:ISceneView):void
		{
			_views.push(view);
			view.onShowEnd();
		}
		
		protected function removeViewFromScene(view:ISceneView,args:ViewParam):void
		{
			var child:Sprite = (view as Sprite);
			view.onHide();
			if(args && args.anim)
			{
				playHideViewAnim(view,args.view,onHideAnimationComplete);
			}
			else
			{
				onHideAnimationComplete(args.view,view);
			}
		}
		private function onHideAnimationComplete(id:String,view:ISceneView):void
		{
			var idx:int = _views.indexOf(view);
			if(idx >= 0)
			{
				_views.splice(idx,1);
			}
			if(view in popMaskDict)
			{
				Quad(popMaskDict[view]).removeFromParent(true);
				delete popMaskDict[view];
			}
			view.onHideEnd();
			
			Sprite(view).removeFromParent(view.isAutoDispose());
			if(view.isAutoDispose())
			{
				delete this.insDict[id];
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
	}
}