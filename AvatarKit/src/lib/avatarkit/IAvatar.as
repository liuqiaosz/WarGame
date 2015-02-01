package lib.avatarkit
{
	public interface IAvatar
	{
		function play(name:String,loop:int = 0,complete:Function = null):void;
		function stop():void;
		function gotoAndStop(frame:int):void;
		function update(delta:int):void;
	}
}