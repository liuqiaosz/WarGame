package lib.animation.core
{
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.textures.Texture;

	public class Animation extends Sprite implements IAnimation
	{
		private var content:Image = null;
		protected var _frames:Vector.<Texture> = null;
		protected var _running:Boolean = false;
		protected var currentFrame:int = 0;
		protected var onPlayDelay:Boolean = false;
		protected var frameLoaded:Boolean = false;
		protected var loopCount:int = 0;
		protected var playedCount:int = 0;
		protected var duration:int = 0;
		protected var isPause:Boolean = false;
		public function Animation(frames:Vector.<Texture> = null)
		{
			_frames = frames;
		}
		
		public function set frames(value:Vector.<Texture>):void
		{
			_frames = value;
			if(_frames)
			{
				frameLoaded = true;
			}
		}
		
		public function set running(value:Boolean):void
		{
			_running = value;
			if(_running)
			{
				AnimationManager.instance.addAnim(this);
			}
			else
			{
				AnimationManager.instance.addAnim(this);
			}
		}
		
		public function get running():Boolean
		{
			return _running;
		}
		
		public function stop():void
		{
			isPause = running = false;
		}
		
		public function pause():void
		{
			isPause = true;
		}
		
		public function resume():void
		{
			isPause = false;
		}
		
		public function gotoAndStop(frame:int):void
		{
			
		}
		
		private var onComplete:Function = null;
		private var onProgress:Function = null;
		public function play(duration:int,loop:int = 0,progress:Function = null,complete:Function = null):void
		{
			if(_frames)
			{
				onProgress = progress;
				onComplete = complete;
				this.duration = duration;
				loopCount = loop;
				lastChange = 0;
				playedCount = 0;
				running = true;
			}
			else
			{
				if(null != complete)
				{
					complete(this);
				}
			}
		}
		
		private var navTexture:Texture = null;
		private var lastChange:int = 0;
		public function update(delta:int):void
		{
			if(isPause || !_running)
			{
				return;
			}
			if(_frames && currentFrame < _frames.length)
			{
				lastChange += delta;
				if(lastChange >= duration)
				{
					lastChange = 0;
					navTexture = _frames[currentFrame];
					content.texture = navTexture;
					content.x = -(navTexture.width >> 1);
					content.y = -navTexture.height;
					currentFrame++;
					if(currentFrame >= _frames.length)
					{
						playedCount++;
						if(loopCount > 0 && loopCount == playedCount)
						{
							if(null != onComplete)
							{
								//播放完毕回调
								onComplete(this);
								running = false;
								navTexture = null;
							}
						}
						else
						{
							//循环播放
							currentFrame = 0;
						}
					}
				}
			}
		}
		
		override public function dispose():void
		{
			navTexture = null;
			_frames = null;
			super.dispose();
		}
	}
}