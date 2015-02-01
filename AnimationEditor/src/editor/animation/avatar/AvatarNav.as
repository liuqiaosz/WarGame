package lib.avatarkit
{
	import flash.display.Bitmap;
	import flash.display.Sprite;
	
	import lib.avatarkit.cfg.ConfigAvatar;
	import lib.avatarkit.cfg.ConfigAvatarAction;

	public class AvatarNav extends Sprite implements IAvatar
	{
		protected var frames:Vector.<Bitmap> = null;
		private var config:ConfigAvatar = null;
		public function getConfig():ConfigAvatar
		{
			return config;
		}
		private var content:Bitmap = null;
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
		
		public function AvatarNav(config:ConfigAvatar,frames:Vector.<Bitmap>)
		{
			this.config = config;
			this.frames = frames;
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
		
		private var navTexture:Bitmap = null;
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
					content.bitmapData = navTexture.bitmapData;
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
	}
}