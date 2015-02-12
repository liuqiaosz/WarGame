package
{
	import starling.animation.Tween;
	import starling.core.Starling;

	public function delayCall(delay:Number,handler:Function,... args:Array):void
	{
		Starling.juggler.delayCall(handler,delay,args);
	}
}