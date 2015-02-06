package framework.module.scene
{
	import flash.geom.Point;
	import flash.utils.Dictionary;
	
	import framework.common.CommonTools;
	import framework.core.GameContext;
	import framework.module.BaseModule;
	import framework.module.notification.NotificationIds;
	import framework.module.scene.vo.ViewParam;
	
	import starling.display.DisplayObject;
	import starling.display.DisplayObjectContainer;
	import starling.display.Sprite;

	/**
	 * 场景管理器
	 */
	public class SceneManager extends BaseModule
	{
		public static const LAYER_GUIDE:String = "LayerGuide";	//引导层
		public static const LAYER_DRAMA:String = "LayerDrama";	//drama层
		public static const LAYER_UI:String = "LayerUI";	//场景层
		public static const LAYER_DIALOG:String = "LayerDialog";//弹出层
		public static const LAYER_EFFECT:String = "LayerEffect";//特效层
		public static const LAYER_TIP:String = "LayerTip";		//tip层
		public static const LAYER_TOP:String = "LayerTop";
		
		public static const LAYERS:Array = [
			LAYER_UI,LAYER_DIALOG,LAYER_EFFECT,LAYER_TIP,LAYER_TOP
		];
		
		private static var _instance:SceneManager = null;
		private var screen:Sprite = null;
		private var regDict:Dictionary = null;
		private var insDict:Dictionary = null;
		private var _currentScene:IScene = null;//当前显示的场景
		private var sceneLayer:Sprite = null;
		private var scaleRatio:Number = 1;
//		private var layers:Vector.<Sprite> = null;	//层
		private var dramaLayer:Sprite = null;
		public function SceneManager()
		{
			if(_instance)
			{
				throw new Error("Singlton Instance Error!");
			}
			screen = GameContext.instance.screenStage;
			regDict = new Dictionary();
			insDict = new Dictionary();
			sceneLayer = new Sprite();
			screen.addChild(sceneLayer);
			
			dramaLayer = new Sprite();
			dramaLayer.name = LAYER_DRAMA;
			screen.addChild(dramaLayer);
		}
		
		public var sceneOffset:Point = new Point();
		public var sceneGlobalOffset:Point = new Point();
		
		override public function initializer():void
		{
			//监听场景变更消息
			addViewListener(NotificationIds.MSG_VIEW_CHANGESCENE,onChangeScene);
		}
		
		/**
		 * 变更场景消息相应
		 */
		private function onChangeScene(params:Object = null):void
		{
			if(params is Array && (params as Array).length > 1)
			{
				changeScene(params[0],params[1]);
			}
			else
			{
				changeScene(String(params));
			}
		}
		
		public static function get instance():SceneManager
		{
			if(!_instance)
			{
				_instance = new SceneManager();
			}
			return _instance;
		}
		
		/**
		 * 注册场景
		 */
		public function register(id:String,cls:Class):void
		{
			regDict[id] = cls;
		}
		
		public function unregister(id:String):void
		{
			if(id in regDict)
			{
				delete regDict[id];
			}
			
			var scene:IScene = null;
			if(id in insDict)
			{
				scene = insDict[id];
				delete insDict[id];
//				if(!sceneLayer)
//				{
//					//获取场景层
//					sceneLayer = screen.getChildByName(LAYER_UI) as Sprite;
//				}
//				if(sceneLayer.contains(scene as DisplayObject))//从starling舞台移除
//				{
//					sceneLayer.removeChild(scene as DisplayObject);
//				}
				sceneLayer.removeChild(scene as DisplayObject,true);
				//销毁
			}
		}
		
//		private var sceneLayer:Sprite = null;
		/**
		 * 场景切换
		 * 
		 * @param		id		场景ID
		 * @param		view	视图ID，空则显示默认视图
		 */
//		public function changeScene(id:String,view:String = null):void
		public function changeScene(id:String,view:ViewParam = null):void
		{
			if(id in regDict)
			{
				var scene:IScene = null;
				var cls:Class = regDict[id];
				if(!(id in insDict))
				{
					scene = insDict[id] = new cls();
					scene.initializer();
					//scene.scale(scaleRatio);
				}
				scene = insDict[id];
				if(scene != _currentScene)
				{
					if(_currentScene)
					{
						_currentScene.onHide();
						var needDispose:Boolean = _currentScene.needDispose();
						(_currentScene as DisplayObject).removeFromParent(needDispose);
						if(needDispose)
						{
							//释放场景
							if(_currentScene.id in insDict)
							{
								delete insDict[_currentScene.id];
							}
						}
					}
					
//					Sprite(scene).x = Math.abs(sceneLayer.x);
//					Sprite(scene).y = Math.abs(sceneLayer.y);
					sceneLayer.addChild(scene as DisplayObject);
					_currentScene = scene;
					scene.onShow();
				}
				
				if(view)
				{
//					var sceneView:ISceneView = SceneBase(_currentScene).findViewById(view.view);
//					if(sceneView)
//					{
//						SceneBase(_currentScene).closeAll();
//						SceneBase(_currentScene).showDialog(sceneView as DisplayObject,view);
//					}
					//SceneBase(_currentScene).closeAll();
					sendViewMessage(NotificationIds.MSG_VIEW_SHOWVIEW,view);
//					_currentScene.changeView(view);
				}
			}
		}
		
		public function findSceneById(id:String):IScene
		{
			if(id in insDict)
			{
				return insDict[id];
			}
			return null;
		}
		
		public function findLayerById(id:String):Sprite
		{
			if(this._currentScene)
			{
				return _currentScene.findLayerById(id);
			}
			return null;
		}
		
		public function getCurrentSceneLayer():IScene
		{
			return _currentScene;
		}
		
		/**
		 * 给指定的场景注册视图
		 */
//		public function registerSceneView(sceneId:String,viewId:String,viewClass:Class):void
//		{
//			var scene:SceneBase = findSceneById(sceneId) as SceneBase;
//			if(scene)
//			{
//				scene.registerView(viewId,viewClass);
//			}
//		}
		
		/**
		 * 添加到指定层级
		 */
		public function addChildToLayer(layerName:String,child:DisplayObject,offset:Point = null,convert:Boolean = false):void
		{
			if(layerName == LAYER_DRAMA)
			{
				addChild(child,dramaLayer,offset,convert);
			}
			else
			{
				if(_currentScene)
				{
					_currentScene.addChildToLayer(layerName,child,offset,convert);
				}
			}
		}
		
		public function layerPositionCovert(layerName:String,pos:Point):Point
		{
			if(_currentScene)
			{
				var layer:Sprite = _currentScene.findLayerById(layerName);
//				return Sprite(_currentScene).globalToLocal(pos);
				return layer.globalToLocal(pos);
			}
			return pos;
		}
		
		public function removeChildByLayer(layerName:String,child:DisplayObject):void
		{
			child.removeFromParent();
			
//			_currentScene.removeChildByLayer(layerName,child);
		}
		
		private function addChild(child:DisplayObject,container:DisplayObjectContainer,offset:Point = null,convert:Boolean = false):void
		{
			if(offset)
			{
				if(convert)
				{
					offset = container.globalToLocal(offset);
				}
				child.x = offset.x;
				child.y = offset.y;
			}
			container.addChild(child);
		}
		
		public function findViewById(id:String):ISceneView
		{
			if(_currentScene)
			{
				return _currentScene.findViewById(id);
			}
			return null;
		}
		
		public function lockScene():void
		{
			sceneLayer.touchable = false;
		}
		
		public function unlockScene():void
		{
			sceneLayer.touchable = true;
		}
		
		public function sceneShake(time:int):void
		{
			if(sceneLayer)
			{
				CommonTools.shake(sceneLayer,time,10);
				
			}
		}
		
	}
}