package lib.animation.avatar
{
	public interface IAvatar
	{
		function playAction(name:String,loop:int = 0,progress:Function = null,complete:Function = null,trigger:Function = null):void;
	}
}