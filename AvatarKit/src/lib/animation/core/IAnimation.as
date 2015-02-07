package lib.animation.core
{
	import starling.animation.IAnimatable;

	public interface IAnimation extends IAnimatable
	{
		function play(duration:int,loop:int = 0,progress:Function = null,complete:Function = null):void;
		function stop():void;
		function gotoAndStop(frame:int):void;
		//function update(delta:int):void;
		function pause():void;
		function resume():void;
	}
}