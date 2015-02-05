package editor.anim.eff
{
	import flash.utils.Dictionary;
	
	import lib.animation.effect.cfg.ConfigEffect;

	public class EffectManager
	{
		public static var _instance:EffectManager = null;
		public static function get instance():EffectManager
		{
			if(!_instance)
			{
				_instance = new EffectManager();
			}
			return _instance;
		}
		
		private var cfgDict:Dictionary = new Dictionary();
		public function EffectManager()
		{
		}
		
		public function loadConfig(path:String):void
		{
			
		}
		
		public function getEffect(id:String):IEffect
		{
			if(id in cfgDict)
			{
				return new Effect(cfgDict[id] as ConfigEffect);
			}
			return null;
		}
		
	}
}