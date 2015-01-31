package framework.core
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.geom.Point;
	import flash.utils.Dictionary;

	/**
	 * Flash原生显示舞台的管理
	 * 
	 * 处理flash原生的UI处理
	 */
	public class FlashStageManager
	{
		public static const LAYER_UI:String = "LayerUI";		//UI层
		public static const LAYER_GUIDE:String = "LayerGuide";	//引导层
		public static const LAYER_DRAMA:String = "LayerDrama";	//drama层
		
		public static const LAYERS:Array = [
			LAYER_UI,LAYER_GUIDE,LAYER_DRAMA
		];
		private static var _instance:FlashStageManager = null;
		private var layers:Dictionary = null;
		private var stage:Stage = null;
		public function FlashStageManager()
		{
			if(_instance)
			{
				throw new Error("Singlton Instance Error!");
			}
			
			layers = new Dictionary();
			stage = GameContext.instance.flashStage;
			var child:DisplayObject = null;
			//初始化层级
			for each(var layerName:String in LAYERS)
			{
				child = stage.addChild(new Sprite());
				child.name = layerName;
				
				layers[layerName] = child;
			}
		}
		
		public static function get instance():FlashStageManager
		{
			if(!_instance)
			{
				_instance = new FlashStageManager();
			}
			return _instance;
		}
		
		/**
		 * 添加到某个层级
		 * 
		 * @param		layerName		层名称
		 * @param		child			子对象
		 * @param		offset			坐标偏移
		 */
		public function addToLayer(layerName:String,child:Sprite,offset:Point = null):void
		{
			if(layerName in layers && child)
			{
				if(offset)
				{
					child.x = offset.x;
					child.y = offset.y;
				}
				else
				{
//					child.x = (stage.fullScreenWidth - child.width >> 1);
//					child.y = (stage.fullScreenHeight - child.height >> 1);
					child.x = child.y = 0;
				}
				layers[layerName].addChild(child);
			}
		}
		
		/**
		 * 从指定层级移除
		 */
		public function removeFromLayer(layerName:String,child:Sprite):void
		{
			if(layerName in layers && child && layers[layerName].contains(child))
			{
				layers[layerName].removeChild(child);
			}
		}
		
		public function getLayerByName(layerName:String):Sprite
		{
			if(layerName in layers)
			{
				return layers[layerName];
			}
			return null;
		}
	}
}