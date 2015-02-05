package framework.module.scene.vo
{
	import flash.geom.Point;
	
	import framework.module.scene.SceneManager;

	public class ViewParam
	{
		public var anim:Boolean = true;
		public var modal:Boolean = true;
		public var isPop:Boolean = false;
		public var view:String = "";
		public var data:Object = null;
		public var pos:Point = null;
		public var maskAlpha:Number = .75;
		public var offset:Point = null;
		public var layer:String = SceneManager.LAYER_DIALOG;
		public var name:String = "";
		public function ViewParam()
		{
		}
	}
}