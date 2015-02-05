package  editor.anim.eff
{
	import editor.anim.core.Animation;
	import editor.asset.ResourceManager;
	import editor.setting.EditorSetting;
	
	import lib.animation.effect.cfg.ConfigEffect;

	public class Effect extends Animation implements IEffect
	{
		protected var config:ConfigEffect = null;
		private var _progress:Function = null;
		private var _complete:Function = null;
		private var _loop:int = 0;
		public function Effect(cfg:ConfigEffect)
		{
			config = cfg;
			
			if(ResourceManager.instance.hasAsset(config.id))
			{
				frames = ResourceManager.instance.getAssetById(config.id);
			}
			else
			{
				ResourceManager.instance.loadAssetDirectory(config.id,EditorSetting.instance.setting.directory.effectDirectory + "/" + config.id,onAssetLoadComplete);
			}
		}
		
		private function onAssetLoadComplete():void
		{
			frames = ResourceManager.instance.getAssetById(config.id);
			
			if(onPlayDelay)
			{
				//running = true;
				onPlayDelay = false;
				
				super.play(config.duration,_loop,_progress,_complete);
				_progress = _complete = null;
			}
		}
		
		public function playEffect(loop:int,progress:Function = null,complete:Function = null):void
		{
			_loop = loop;
			if(frameLoaded)
			{
				super.play(config.duration,_loop,_progress,_complete);
			}
			else
			{
				onPlayDelay = true;
				_progress = progress;
				_complete = complete;
			}
		}
		
		override public function dispose():void
		{
			config = null;
			super.dispose();
		}
	}
}