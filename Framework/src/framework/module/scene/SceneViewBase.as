package framework.module.scene
{
	import extension.asset.AssetsManager;
	
	import flash.geom.Rectangle;
	
	import framework.module.notification.NotificationIds;
	import framework.module.scene.vo.ViewParam;
	
	import starling.display.Sprite;

	public class SceneViewBase extends Sprite implements ISceneView
	{
		protected var _id:String = "";
		public function SceneViewBase(id:String,resources:Array = null)
		{
			_resources = resources;
			_id = id;
		}
		
		public function onHide():void
		{
			
		}
		
		public function onHideEnd():void
		{
			
		}
		
		public function onShow():void
		{
			
		}
		public function onShowEnd():void
		{
			
		}
		public function pause():void
		{
			
		}
		public function resume():void
		{
			
		}
		
		private var _resources:Array = null;
		public function getResource():Array
		{
			return _resources;
		}
		
		private var _data:Object = null;
		public function set data(value:Object):void
		{
			_data = value;
		}
		public function get data():Object
		{
			return _data;
		}
		public function get viewBounds():Rectangle
		{
			return null;
		}
		
		public function isAutoDispose():Boolean
		{
			return false;
		}
		
		public function get isViewShow():Boolean
		{
			return false;	
		}
		
		private var _resourceReady:Boolean = false;
		/**
		 * 视图需要资源是否准备完毕
		 **/
		public function isLoaded():Boolean
		{
			return _resourceReady;
		}
		
		protected function onResourceLoadComplete():void
		{
			
		}
		
		/**
		 * 开始视图资源准备
		 **/
		public function loadResource(progress:Function = null,complete:Function = null):void
		{
			var resources:Array = getResource();
			var self:ISceneView = this;

			AssetsManager.instance.addLoadQueue(resources,function():void{
				_resourceReady = true;
				onResourceLoadComplete();
				if(null != complete)
				{
					complete(self);
				}
			},function(ratio:Number):void{
				if(null != progress)
				{
					progress(ratio);
				}
			});
		}
		
		public function close():void
		{
			var param:ViewParam = new ViewParam();
			param.view = _id;
			param.anim = false;
			sendViewMessage(NotificationIds.MSG_VIEW_HIDEVIEW,param);
		}
		
	}
}