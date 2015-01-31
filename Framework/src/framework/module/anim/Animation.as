package framework.module.anim
{
	import starling.core.Starling;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.textures.Texture;
	
	/**
	 * 帧动画基类
	 */
	public class Animation extends Sprite implements IAnimation
	{
		//底层
//		protected var baseLayer:Sprite = null;
		protected var clip:Image = null;
		protected var clips:Vector.<Texture> = null;
		//当前播放的下标
		private var _currentFrame:int = 0;
		//当前帧总数
		protected var clipLength:int = 0;	

		protected var completeFunc:Function = null;
		protected var loopCount:int = 0;
		protected var playLoopCount:int = 0;
		protected var duration:int = 0;
//		protected var isPause:Boolean = false;
		protected var isPlay:Boolean = false;
//		protected var _durationScale:Number = 1;
		protected var realDuration:Number = 0;
		private var _anchor:String = "";
		protected var clipWidth:Number = 0;
		protected var clipHeight:Number = 0;
		protected var orgJuggler:Boolean = false;
//		public function set durationScale(value:Number):void
//		{
//			_durationScale = value;
//			realDuration = duration / _durationScale;
//			delta = realDuration / 1000;
//		}
		public function set frameClips(value:Vector.<Texture>):void
		{
			if(value)
			{
				clips = value;
				clipLength = clips.length;
			}
		}
		
		public function Animation()
		{
//			baseLayer = new Sprite();
//			addChild(baseLayer);
			this.touchable = false;
		}
		
		private var time:Number = 0;
//		public function update(t:Number):void
//		{
//			//到达间隔时间&没有暂停动作
//			if(t - time >= duration && !isPause)
//			{
//				//播放下一帧
//				next();
//				time = t;
//			}
//		}
		
		public function advanceTime(t:Number):void
		{
			//到达间隔时间&没有暂停动作
			time += t;
			if(time >= delta && isPlay)
			{
				//播放下一帧
				next();
				time = 0;
			}
		}
		
		private var _speed:Number = 1;
		public function changeSpeed(value:Number):void
		{
			if(_speed != value)
			{
				_speed = value;
				if(isPlay)
				{
					realDuration = duration / _speed;
					delta = realDuration / 1000;
				}
			}
//			delta = realDuration / (_speed * 1000);
		}
		
		public function get speed():Number
		{
			return _speed;	
		}
		
		
		/**
		 * 变更锚点
		 */
//		public function changeAnchor(value:int):void
//		{
//			anchor = value;
//			updateAnchorPos();
//		}
		
		/**
		 * 播放完成的回调
		 */
		public function addCompleteCallback(func:Function):void
		{
			completeFunc = func;
		}
		public function clearCompleteCallback():void
		{
			completeFunc = null;
		}
		
		private var delta:Number = 0;
		//播放动画
		public function play(startFrame:int = 0,dur:int = 80,loop:int = 0,orgJuggler:Boolean = false):void
		{
			if(clips)
			{
				clipLength = clips.length;
				if(!clip)
				{
					//使用进入的参数或者初始化剪辑使用第一帧
					clip = new Image(clips[(startFrame < clipLength ? startFrame:0)]);
					
//					updateAnchorPos();
					//放入底层
//					baseLayer.addChild(clip);
					clipWidth = clip.width;
					clipHeight = clip.height;
					updateClipAnchor();
					if(fx)
					{
						flipX(fx);
					}
					if(fy)
					{
						flipY(fy);
					}
					addChild(clip);
					
				}
			}
			duration = dur;
			realDuration = duration / _speed;
			delta = realDuration / 1000;
//			isPause = false;
			isPlay = true;
			currentFrame = startFrame;
			loopCount = loop;
			this.orgJuggler = orgJuggler;
//			Starling.juggler.add(this);
			if(orgJuggler)
			{
				Starling.juggler.add(this);	
			}
			else
			{
				AnimationManager.instance.add(this);
			}
//			AnimationManager.instance.appendToQueue(this);
		}
		
		public function set anchor(value:String):void
		{
			_anchor = value;
		}
		
		private function updateClipAnchor():void
		{
			if(clip)
			{
				switch(_anchor)
				{
					case "center":
						if(clip.scaleX > 0)
						{
							clip.x = -(clipWidth >> 1);
							clip.y = -(clipHeight >> 1);
						}
						else
						{
							clip.x = +(clipWidth >> 1);
							clip.y = -(clipHeight >> 1);
						}
						break;
					case "bottom":
						clip.x = -(clipWidth >> 1);
						clip.y = -(clipHeight);
						break;
					case "top":
						clip.x = -(clipWidth >> 1);
						clip.y = 0;
						break;
				}
				clip.x += _offsetX;
				clip.y += _offsetY;
			}
		}
		
		private var _offsetX:int = 0;
		private var _offsetY:int = 0;
		protected function updateOffset(x:int,y:int):void
		{
			
			if(clip)
			{
				clip.x += _offsetX;
				clip.y += _offsetY;
			}
			else
			{
				_offsetX = x;
				_offsetY = y;
			}
		}
		
		/**
		 * 停止动画播放
		 */
		public function stop():void
		{
			if(orgJuggler)
			{
				Starling.juggler.remove(this);
			}
			else
			{
				AnimationManager.instance.remove(this);
			}
//			AnimationManager.instance.removeFromQueue(this);
//			isPause = false;
			currentFrame = 0;
			isPlay = false;
		}
		
		/**
		 * 更新当前Clip的锚点
		 */
//		protected function updateAnchorPos():void
//		{
//			if(clip)
//			{
//				switch(anchor)
//				{
//					case GlobalEumn.ANIM_ANCHOR_CENTER:
//						clip.x = -(clip.width >> 1);
//						clip.y = -(clip.height >> 1);
//						break;
//					case GlobalEumn.ANIM_ANCHOR_CENTER_BOTTOM:
//						clip.x = -(clip.width >> 1);
//						clip.y = -clip.height;
//						break;
//					case GlobalEumn.ANIM_ANCHOR_CENTER_TOP:
//						clip.x = -(clip.width >> 1);
//						clip.y = -clip.height;
//						break;
//					default:
//						clip.x = clip.y = 0;
//						break;
//				}
//			}
//		}
		
		//上一帧，下一帧
		private function next():void
		{
			if(!clips || clips.length == 0)
			{
				return;
			}
			if(!clip)
			{
				clip = new Image(clips[currentFrame]);
			}
			else
			{
				clip.texture = clips[currentFrame];
			}
			currentFrame++;
			progress(currentFrame,clipLength);
			//到达最后一帧默认返回第一帧
			if(currentFrame >= clipLength)
			{
				//播放次数+1
				playLoopCount++;
				if(loopCount > 0 && playLoopCount >= loopCount)
				{
					//已经到达最大播放次数
					if(null != completeFunc)
					{
						completeFunc(this);
					}
					//停止播放
					stop();
				}
				else
				{
					currentFrame = 0;
				}
			}
		}
		
		public function set frame(value:int):void
		{
			if(!clips || clips.length == 0)
			{
				return;
			}
			currentFrame = value;
			if(currentFrame < 0)
			{
				currentFrame = 0;
			}
			else if(currentFrame > clips.length)
			{
				currentFrame = clips.length - 1;
			}
			
			if(!clip)
			{
				clip = new Image(clips[currentFrame]);
			}
			else
			{
				clip.texture = clips[currentFrame];
			}
		}
		
		/**
		 * 跳到指定帧并且暂停播放
		 **/
		public function gotoAndPause(index:int):void
		{
			isPlay = false;
			frame = index;
		}
		
		public function pause():void
		{
//			isPlay = false;
			if(orgJuggler)
			{
				Starling.juggler.remove(this);
			}
			else
			{
				AnimationManager.instance.remove(this);
			}
		}
		public function resume():void
		{
//			isPlay = true;
			if(orgJuggler)
			{
				Starling.juggler.add(this);
			}
			else
			{
				AnimationManager.instance.add(this);
			}
		}
		
		private var fx:Number = 0;
		private var fy:Number = 0;
		
		public function flipX(ratio:int):void
		{
//			scaleX *= ratio;
			if(clip)
			{
				clip.scaleX *= ratio;
				if(ratio < 0)
				{
					clip.x = (Math.abs(ratio) * clipWidth >> 1);
				}
			}
			else
			{
				fx = ratio;
			}
		}
		
		public function flipY(ratio:int):void
		{
			scaleY *= ratio;
		}
		
		protected function progress(frame:int,total:int):void
		{
			
		}
		
		private function prev():void
		{
			if(clip && clips && clips.length)
			{
				if(currentFrame > 0)
				{
					currentFrame--;
				}
				clip.texture = clips[currentFrame];
			}
		}
		
		override public function dispose():void
		{
			stop();
			if(clip)
			{
				clip.removeFromParent(true);
				clips = null;
			}
			AnimationManager.instance.remove(this);
			completeFunc = null;
			isPlay = false;
			super.dispose();
		}

		public function get currentFrame():int
		{
			return _currentFrame;
		}

		public function set currentFrame(value:int):void
		{
			_currentFrame = value;
		}


	}
}