package wargame.logic.battle.vo
{
	import wargame.scene.battle.sprite.IBattleSprite;

	/**
	 * 特效
	 * 
	 **/
	public class EffectNode extends BattleNode
	{
		public function EffectNode(target:IBattleSprite,left:Vector.<IBattleSprite>,right:Vector.<IBattleSprite>)
		{
			super(target,left,right);
		}
		
		override protected function update(delta:int):void
		{
			
		}
	}
}