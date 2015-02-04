package editor.animation.effect
{
	import editor.asset.AvatarAssetManager;
	
	import flash.events.Event;
	import flash.utils.Dictionary;
	import flash.utils.getTimer;
	
	import lib.animation.effect.cfg.ConfigEffect;
	
	import mx.core.FlexGlobals;

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
		
		private var configDict:Dictionary = null;
		private var isInit:Boolean = false;
		private var lastAdvance:int = 0;
		protected var effects:Vector.<EffectNative> = null;
		public function EffectManager()
		{
			effects = new Vector.<EffectNative>();
			lastAdvance = getTimer();
			configDict = new Dictionary();

			FlexGlobals.topLevelApplication.addEventListener(Event.ENTER_FRAME,advanceTime);
		}
		
		/**
		 * 初始化
		 **/
		public function init(value:Array):void
		{
			if(value && value.length)
			{
				isInit = true;
				var effect:ConfigEffect = null;
				
				for each(var avr:Object in value)
				{
					effect = ConfigEffect.decode(avr);
					configDict[effect.id] = effect;
				}
			}
		}
		
		public function advanceTime(event:Event):void
		{
			var now:int = getTimer();
			var delta:int = now - lastAdvance;
			for(var idx:int = 0; idx<effects.length; idx++)
			{
				effects[idx].update(delta);
			}
			lastAdvance = now;
		}
		
		public function addEffect(effect:EffectNative):void
		{
			if(effects.indexOf(effect) < 0)
			{
				effects.push(effect);
			}
		}
		
		public function removeEffect(effect:EffectNative):void
		{
			if(effects.indexOf(effect) >= 0)
			{
				effects.splice(effects.indexOf(effect),1);
			}
		}
		
		/**
		 * 通过ID查找avatar
		 **/
		public function createtAvatarById(id:String):EffectNative
		{
			if(id in configDict)
			{
				var cfg:ConfigEffect = configDict[id];
				return new EffectNative(cfg,AvatarAssetManager.instance.getAssetById(id));
			}
			return null;
		}
	}
}