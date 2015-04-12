package wargame.sm
{
	import wargame.logic.battle.vo.ArmyInfo;

	public interface IState
	{
		function execute(sm:StateMachine,t:int):void;
		function onBegin():void;
		function onExit():void;
	}
}