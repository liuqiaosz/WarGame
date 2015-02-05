package framework.core
{
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
			AnimationMarshal.instance.remove(this);
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
			AnimationMarshal.instance.add(this);
		}
		
		public function stop():void
		{
			AnimationMarshal.instance.remove(this);
		}
	}
}