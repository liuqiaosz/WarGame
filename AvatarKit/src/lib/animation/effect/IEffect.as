package lib.animation.effect
{
	public interface IEffect
	{
		function playEffect(loop:int,progress:Function = null,complete:Function = null):void;
	}
}