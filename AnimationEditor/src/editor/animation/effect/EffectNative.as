package editor.animation.effect
{
	import flash.display.Bitmap;
	import flash.display.Shape;
	import flash.display.Sprite;
	
	import lib.animation.effect.cfg.ConfigEffect;
	
	public class EffectNative extends Sprite
	{
		protected var frames:Vector.<Bitmap> = null;
		private var config:ConfigEffect = null;
		
		public function EffectNative(cfg:ConfigEffect,imgs:Vector.<Bitmap>)
		{
			this.config = cfg;
			this.frames = imgs;
			
			content = new Bitmap();
			addChild(content);
			gotoAndStop(0);
			
			var point:Shape = new Shape();
			point.graphics.beginFill(0xff0000);
			point.graphics.drawCircle(0,0,2);
			point.graphics.endFill();
			addChild(point);
		}
		
		public function getConfig():ConfigEffect
		{
			return config;
		}
		
		private var content:Bitmap = null;
		protected var _running:Boolean = false;
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
				EffectManager.instance.addEffect(this);
			}
			else
			{
				EffectManager.instance.removeEffect(this);
			}
		}
		public function get running():Boolean
		{
			return _running;
		}
		
		private var playCompleteFunc:Function = null;
		public function play(loop:int = 0,complete:Function = null):void
		{
			lastChange = 0;
			playedCount = 0;
			loopCount = loop;
			
			currentFrame = 0;
			running = true;
			playCompleteFunc = complete;
		}
		
		public function stop():void
		{
			
		}
		
		public function gotoAndStop(frame:int):void
		{
			running = false;
			if(frames && frame < frames.length)
			{
				navTexture = frames[frame];
				currentFrame = frame;
				content.bitmapData = navTexture.bitmapData;
				content.x = -(navTexture.width >> 1);
				content.y = -navTexture.height;
			}
		}
		
		private var navTexture:Bitmap = null;
		private var lastChange:int = 0;
		public function update(delta:int):void
		{
			if(running && frames && currentFrame < frames.length)
			{
				lastChange += delta;
				if(lastChange >= config.duration)
				{
					lastChange = 0;
					navTexture = frames[currentFrame];
					content.bitmapData = navTexture.bitmapData;
					content.x = -(navTexture.width >> 1);
					content.y = -(navTexture.height >> 1);
					currentFrame++;
					if(currentFrame >= frames.length)
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
							currentFrame = 0;
							playedCount = 0;
						}
					}
				}
			}
		}
		public function changeDuration(value:int):void
		{
			if(config)
			{
				config.duration = value;
			}
		}
	}
}