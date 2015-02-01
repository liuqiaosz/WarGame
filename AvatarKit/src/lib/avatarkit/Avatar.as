package lib.avatarkit
{
	import lib.avatarkit.cfg.ConfigAvatar;
	import lib.avatarkit.cfg.ConfigAvatarAction;
	
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.textures.Texture;
	import starling.textures.TextureAtlas;

	public class Avatar extends Sprite implements IAvatar
	{
		protected var frames:Vector.<Texture> = null;
		private var config:ConfigAvatar = null;
		private var content:Image = null;
		protected var _running:Boolean = false;
		private var currentAction:ConfigAvatarAction = null;
		private var currentFrame:int = 0;
		private var onPlayDelay:Boolean = false;
		private var frameLoaded:Boolean = false;
		private var loopCount:int = 0;
		private var playedCount:int = 0;
		public function set running(value:Boolean):void
		{
			_running = value;
			if(_running)
			{
				AvatarManager.instance.addAvatar(this);
			}
			else
			{
				AvatarManager.instance.removeAvatar(this);
			}
		}
		public function get running():Boolean
		{
			return _running;
		}
		
		public function Avatar(config:ConfigAvatar)
		{
			this.config = config;
			frames = new Vector.<Texture>();
			var atlas:TextureAtlas = AvatarAssetManager.instance.getTextureAtlas(config.id);
			
			if(atlas)
			{
				frames = atlas.getTextures();
				frameLoaded = true;
			}
			else
			{
				AvatarAssetManager.instance.loadAvatarAsset(config.id,onAssetLoadComplete);
			}
		}
		
		private function onAssetLoadComplete():void
		{
			var atlas:TextureAtlas = AvatarAssetManager.instance.getTextureAtlas(config.id);
			if(atlas)
			{
				frames = atlas.getTextures();
				frameLoaded = true;
				
				if(onPlayDelay)
				{
					running = true;
					onPlayDelay = false;
				}
			}
		}
		
		private var playCompleteFunc:Function = null;
		public function play(name:String,loop:int = 0,complete:Function = null):void
		{
			lastChange = 0;
			playedCount = 0;
			loopCount = loop;
			currentAction = null;
			if(name == config.actions[idx].name)
			{
				currentAction = config.actions[idx];
				currentFrame = currentAction.start;
			}
			
			if(frameLoaded)
			{
				for(var idx:int = 0; idx<config.actions.length; idx++)
				{
//					if(name == config.actions[idx].name)
					if(currentAction)
					{
						//currentAction = config.actions[idx];
						running = true;
						playCompleteFunc = complete;
						break;
					}
				}
			}
			else
			{
				onPlayDelay = true;
			}
		}
			
		public function stop():void
		{
			
		}
		
		public function gotoAndStop(frame:int):void
		{
			
		}
		
		private var navTexture:Texture = null;
		private var lastChange:int = 0;
		public function update(delta:int):void
		{
			if(running && frames && currentFrame < frames.length)
			{
				lastChange += delta;
				if(lastChange >= currentAction.duration)
				{
					lastChange = 0;
					navTexture = frames[currentFrame];
					content.texture = navTexture;
					content.x = navTexture.width >> 1;
					content.y = -navTexture.height;
					currentFrame++;
					if(currentFrame > currentAction.end)
					{
						playedCount++;
						if(loopCount > 0 && loopCount == playedCount)
						{
							if(null != playCompleteFunc)
							{
								//播放完毕回调
								playCompleteFunc(this);
								running = false;
								navTexture = null;
							}
						}
						else
						{
							//循环播放
							currentFrame = currentAction.start;
							playedCount = 0;
						}
					}
				}
			}
		}
		
		override public function dispose():void
		{
			navTexture = null;
			super.dispose();
		}
	}
}