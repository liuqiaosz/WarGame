package lib.animation.avatar
{
	import extension.asset.AssetsManager;
	
	import lib.animation.avatar.cfg.AtomConfigManager;
	import lib.animation.avatar.cfg.ConfigAvatar;
	import lib.animation.avatar.cfg.ConfigAvatarAction;
	import lib.animation.avatar.cfg.atom.ConfigUnit;
	import lib.animation.core.AnimAsset;
	import lib.animation.core.Animation;
	
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.textures.Texture;
	import starling.textures.TextureAtlas;

	public class Avatar extends Animation implements IAvatar
	{
		private var currentAction:ConfigAvatarAction = null;
		private var config:ConfigAvatar = null;
		private var avatarFrames:Vector.<Texture> = null;
		private var actionFrames:Vector.<Texture> = null;
		private var _atom:ConfigUnit = null;
		public function get atom():ConfigUnit
		{
			return _atom;
		}
		public function Avatar(config:ConfigAvatar)
		{
			this.config = config;
			_atom = AtomConfigManager.instance.findUnitById(config.id);
			var atlas:TextureAtlas = AssetsManager.instance.getTextureAtlas(config.id);
			if(atlas)
			{
				avatarFrames = atlas.getTextures();
				frameLoaded = true;
			}
			else
			{
				AssetsManager.instance.addLoadQueue(AnimAsset.getAvatarUrl(config.id),onAssetLoadComplete);
			}
		}
		
		private function onAssetLoadComplete():void
		{
			var atlas:TextureAtlas = AssetsManager.instance.getTextureAtlas(config.id);
			if(atlas)
			{
				avatarFrames = atlas.getTextures();
				frameLoaded = true;
				if(onPlayDelay)
				{
					//running = true;
					onPlayDelay = false;
					
					if(currentAction)
					{
						if(!actionFrames)
						{
							actionFrames = new Vector.<Texture>();
						}
						else
						{
							actionFrames.length = 0;
						}
						for(var idx:int = currentAction.start;idx <= currentAction.end; idx++)
						{
							actionFrames.push(avatarFrames[idx]);
						}
						//设置帧序列
						super.frames = actionFrames;
						//播放接口调用
						super.play(currentAction.duration,_loop,_progress,_complete);
						_progress = _complete = null;
					}
				}
			}
		}
		
//		public function play(name:String,loop:int = 0,complete:Function = null):void
		public function playAction(name:String,loop:int = 0,progress:Function = null,complete:Function = null):void
		{
			playedCount = 0;
			_loop = loop;
			currentAction = null;
			var idx:int = 0;
			for(idx = 0; idx<config.actions.length; idx++)
			{
				if(name == config.actions[idx].name)
				{
					currentAction = config.actions[idx];
				}
			}
			
			if(frameLoaded)
			{
				if(currentAction)
				{
					if(!actionFrames)
					{
						actionFrames = new Vector.<Texture>();
					}
					else
					{
						actionFrames.length = 0;
					}
					for(idx = currentAction.start;idx <= currentAction.end; idx++)
					{
						actionFrames.push(avatarFrames[idx]);
					}
					//设置帧序列
					super.frames = actionFrames;
					//播放接口调用
					super.play(currentAction.duration,loop,progress,complete);
				}
			}
			else
			{
				onPlayDelay = true;
				_progress = progress;
				_complete = complete;
			}
		}
		
		private var _loop:int = 0;
		private var _progress:Function = null;
		private var _complete:Function = null;
		
		/**
		 * 重写基类的播放方法,使用avatar动画不允许直接调用底层的播放接口
		 **/
		override public function play(duration:int, loop:int=0, progress:Function=null, complete:Function=null):void
		{
			throw new Error("invalid play");
		}
		
		override public function dispose():void
		{
			currentAction = null;
			config = null;
			avatarFrames = null;
			actionFrames = null;
			super.dispose();
		}
	}
}