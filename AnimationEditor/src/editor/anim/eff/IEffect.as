package editor.anim.eff
{
	public interface IEffect
	{
		function playEffect(loop:int,progress:Function = null,complete:Function = null):void;
	}
}