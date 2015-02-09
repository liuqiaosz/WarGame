package wargame.logic
{
	public interface IGameLogic
	{
		function update(delta:int):void;
		function dispose():void;
	}
}