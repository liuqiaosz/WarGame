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
		function onShow():void;
		function onHide():void;
		function get id():String;				//场景ID
		function findLayerById(id:String):Sprite;
		function addChildToLayer(layerName:String,child:DisplayObject,offset:Point = null,convert:Boolean = false):void;
		function removeChildByLayer(layerName:String,child:DisplayObject):void;
		function dispose():void;
		function needDispose():Boolean;
		function findViewById(id:String):ISceneView;
		function initializer():void;
	}
}