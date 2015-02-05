package framework.module.scene
{
	import flash.geom.Rectangle;
	
	import starling.display.DisplayObject;

	public interface ISceneView
	{
		function onHide():void;
		function onHideEnd():void;
		function onShow():void;
		function onShowEnd():void;
		function pause():void;
		function resume():void;
		function getResource():Array;
		function set data(value:Object):void;
		function get viewBounds():Rectangle;
		function isAutoDispose():Boolean;
		function get isViewShow():Boolean;
		function isLoaded():Boolean;
		function loadResource(progress:Function = null,complete:Function = null):void;
	}
}