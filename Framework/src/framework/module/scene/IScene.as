package framework.module.scene
{
	import flash.geom.Point;
	
	import starling.display.DisplayObject;
	import starling.display.Sprite;

	/**
	 * 场景借口
	 */
	public interface IScene
	{
		function onShow():void;					//暂停场景
		function onHide():void;					//恢复场景
		function get id():String;				//场景ID
		function changeView(view:String,offset:Point = null):void;	//切换视图
		function scale(ratio:Number):void;
		function findLayerById(id:String):Sprite;
		function addChildToLayer(layerName:String,child:DisplayObject,offset:Point = null,convert:Boolean = false):void;
		function removeChildByLayer(layerName:String,child:DisplayObject):void;
		function dispose():void;
		
		function needDispose():Boolean;
		
		function findViewById(id:String):ISceneView;
	}
}