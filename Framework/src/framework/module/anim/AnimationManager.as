package framework.module.anim
{
	import starling.animation.IAnimatable;
	import starling.animation.Juggler;
	import starling.core.Starling;

	/**
	 * 动画管理模块
	 */
	public class AnimationManager extends Juggler
	{
		private static var _instance:AnimationManager = null;
		public function AnimationManager()
		{
			if(_instance)
			{
				throw new Error("Singlton Instance Error!");
			}
			
			Starling.juggler.add(this);
		}
		
		public static function get instance():AnimationManager
		{
			if(!_instance)
			{
				_instance = new AnimationManager();
			}
			return _instance;
		}
		private var isPause:Boolean = false;
		public function pause():void
		{
			isPause = true;
		}
		public function resume():void
		{
			isPause = false;
		}
		
		private var _lastAdvance:Number = 0;
		override public function advanceTime(time:Number):void
		{
			if(!isPause)
			{
				if(_slowDelay > 0)
				{
					_lastAdvance += (time * 1000);
					if(_lastAdvance >= _slowDelay)
					{
						_lastAdvance = 0;
						super.advanceTime(time);
					}
				}
				else
				{
					super.advanceTime(time);
				}
			}
		}
		
		private var _slowDelay:int = 0;
		/**
		 * 慢镜头每帧的间隔
		 **/
		public function set slowDelay(value:int):void
		{
			_slowDelay = value;
		}
	}
}