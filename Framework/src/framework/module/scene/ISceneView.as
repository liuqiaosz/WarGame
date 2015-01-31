package framework.module.scene
{
	import flash.geom.Rectangle;
	
	import starling.display.DisplayObject;

	public interface ISceneView
	{
		function onHide():void;
		function onShow():void;
		function onShowEnd():void;
		function pause():void;
		function resume():void;
		function getResource():Array;
		function isUI():Boolean;
		function set data(value:Object):void;
		function get viewBounds():Rectangle;
		function dispose():void;
		function getViewChildById(id:String):DisplayObject;
		function isAutoDispose():Boolean;
		function get isViewShow():Boolean;
	}
}