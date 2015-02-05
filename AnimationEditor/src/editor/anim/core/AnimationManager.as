package editor.anim.core
{
	import flash.events.Event;
	import flash.utils.Dictionary;
	import flash.utils.getTimer;
	
	import mx.core.FlexGlobals;
	
	
	public class AnimationManager
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
		
		protected var anims:Vector.<IAnimation> = null;
		private var configDict:Dictionary = null;
		private var isInit:Boolean = false;
		private var lastAdvance:int = 0;
		
		public function AnimationManager()
		{
			anims = new Vector.<IAnimation>();
			lastAdvance = getTimer();
			configDict = new Dictionary();
			FlexGlobals.topLevelApplication.addEventListener(Event.ENTER_FRAME,advanceTime);
		}
		
		public function advanceTime(event:Event):void
		{
			var now:int = getTimer();
			var delta:int = now - lastAdvance;
			for(var idx:int = 0; idx<anims.length; idx++)
			{
				anims[idx].update(delta);
			}
			lastAdvance = now;
		}
		
		public function addAnim(value:IAnimation):void
		{
			if(anims.indexOf(value) < 0)
			{
				anims.push(value);
			}
		}
		public function removeAnim(value:IAnimation):void
		{
			if(anims.indexOf(value) >= 0)
			{
				anims.splice(anims.indexOf(value),1);
			}
		}
	}
}