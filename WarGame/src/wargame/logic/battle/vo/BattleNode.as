package wargame.logic.battle.vo
{
	import wargame.scene.battle.sprite.IBattleSprite;

	public class BattleNode implements IBattleNode
	{
//		protected var self:IBattleSprite = null;

//		public function BattleNode(target:IBattleSprite)
//		{
//			self = target;
//		}
		
		public function BattleNode()
		{
			
		}
		
		public function update(delta:int,left:Vector.<IBattleNode>,right:Vector.<IBattleNode>):void
		{
			
		}
		private var _dispose:Boolean = false;
		public function dispose():void
		{
			_dispose = true;
		}
		
		public function isDispose():Boolean
		{
			return _dispose;
		}
	}
}