package editor.anim.core
{
	public interface IAnimation
	{
		function play(duration:int,loop:int = 0,progress:Function = null,complete:Function = null):void;
		function stop():void;
		function gotoAndStop(frame:int):void;
		function update(delta:int):void;
		function pause():void;
		function resume():void;
	}
}