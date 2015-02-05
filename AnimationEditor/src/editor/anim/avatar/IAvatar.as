package editor.anim.avatar
{
	public interface IAvatar
	{
		function playAction(name:String,loop:int = 0,progress:Function = null,complete:Function = null):void;
	}
}