package lib.animation.core
{
	import flash.utils.Dictionary;
	import flash.utils.getTimer;
	
	import starling.animation.IAnimatable;
	import starling.core.Starling;
	
	public class AnimationManager implements IAnimatable
	{
		public static var _instance:AnimationManager = null;
		public static function get instance():AnimationManager
		{
			if(!_instance)
			{
				_instance = new AnimationManager();
			}
			return _instance;
		}
		
		protected var anims:Vector.<IAnimatable> = null;
		private var configDict:Dictionary = null;
		private var isInit:Boolean = false;
		private var lastAdvance:int = 0;
		
		public function AnimationManager()
		{
			anims = new Vector.<IAnimatable>();
			lastAdvance = getTimer();
			configDict = new Dictionary();
			Starling.juggler.add(this);
		}
		
		public function advanceTime(time:Number):void
		{
			var now:int = getTimer();
			var delta:int = now - lastAdvance;
			for(var idx:int = 0; idx<anims.length; idx++)
			{
				anims[idx].advanceTime(delta);
			}
			lastAdvance = now;
		}
		
		public function addAnim(value:IAnimatable):void
		{
			if(anims.indexOf(value) < 0)
			{
				anims.push(value);
			}
		}
		public function removeAnim(value:IAnimatable):void
		{
			if(anims.indexOf(value) >= 0)
			{
				anims.splice(anims.indexOf(value),1);
			}
		}
	}
}