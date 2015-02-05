package framework.core
{
	import starling.animation.IAnimatable;
	import starling.core.Starling;

	public class AnimationMarshal implements IAnimatable
	{
		private static var _instance:AnimationMarshal = null;
		public static function get instance():AnimationMarshal
		{
			if(!_instance)
			{
				_instance = new AnimationMarshal();
				_instance.initializer();
			}
			return _instance;
		}
		private var _childAnims:Vector.<IAnimatable> = null;
		private function initializer():void
		{
			Starling.juggler.add(this);
			_childAnims = new Vector.<IAnimatable>();
		}
		
		
		public function advanceTime(time:Number):void
		{
			for(var idx:int = 0; idx<_childAnims.length; idx++)
			{
				_childAnims[idx].advanceTime(time);
			}
		}
		
		public function add(anim:IAnimatable):void
		{
			if(_childAnims.indexOf(anim) < 0)
			{
				_childAnims.push(anim);
			}
		}
		
		public function remove(anim:IAnimatable):void
		{
			var index:int = _childAnims.indexOf(anim);
			if(index >= 0)
			{
				_childAnims.splice(index,1);
			}
		}
		
		public function AnimationMarshal()
		{
		}
	}
}