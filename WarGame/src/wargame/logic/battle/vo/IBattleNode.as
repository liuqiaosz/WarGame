package wargame.logic.battle.vo
{
	public interface IBattleNode
	{
		function update(delta:int,left:Vector.<IBattleNode>,right:Vector.<IBattleNode>):void;
		
		function isDispose():Boolean;
	}
}