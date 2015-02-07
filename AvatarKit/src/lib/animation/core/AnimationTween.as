package lib.animation.core
{
	import lib.animation.core.AnimationManager;
	
	import starling.animation.Tween;

	public class AnimationTween extends Tween
	{
		public function AnimationTween(target:Object, time:Number, transition:Object="linear")
		{
			super(target,time,transition);	
		}
		
		private var _update:Function = null;
		private var _complete:Function = null;
		
		override public function set onComplete(value:Function):void
		{
			AnimationManager.instance.removeAnim(this);
			if(null != _complete)
			{
				_complete();
			}
		}
		
		override public function set onUpdate(value:Function):void
		{
			
		}
		
		public function play(complete:Function = null,update:Function = null):void
		{
			_update = update;
			_complete = complete;

			AnimationManager.instance.addAnim(this);
		}
		
		public function stop():void
		{
			AnimationManager.instance.removeAnim(this);
		}
	}
}