package lib.animation.effect
{
	import lib.animation.core.AnimAssetManager;
	import lib.animation.core.Animation;
	import lib.animation.effect.cfg.ConfigEffect;
	
	import starling.textures.TextureAtlas;

	public class Effect extends Animation implements IEffect
	{
		protected var config:ConfigEffect = null;
		private var _progress:Function = null;
		private var _complete:Function = null;
		private var _loop:int = 0;
		public function Effect(cfg:ConfigEffect)
		{
			config = cfg;
			
			var atlas:TextureAtlas = AnimAssetManager.instance.getTextureAtlas(config.id);
			if(atlas)
			{
				frames = atlas.getTextures();
			}
			else
			{
				AnimAssetManager.instance.loadAnimAsset(config.id,onAssetLoadComplete);
			}
		}
		
		private function onAssetLoadComplete():void
		{
			var atlas:TextureAtlas = AnimAssetManager.instance.getTextureAtlas(config.id);
			if(atlas)
			{
				frames = atlas.getTextures();
				
				if(onPlayDelay)
				{
					//running = true;
					onPlayDelay = false;
					
					super.play(config.duration,_loop,_progress,_complete);
					_progress = _complete = null;
				}
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
		
		/**
		 * 重写基类的播放方法,使用avatar动画不允许直接调用底层的播放接口
		 **/
		override public function play(duration:int, loop:int=0, progress:Function=null, complete:Function=null):void
		{
			throw new Error("invalid play");
		}
		
		override public function dispose():void
		{
			config = null;
			super.dispose();
		}
	}
}