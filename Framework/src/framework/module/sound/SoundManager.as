package framework.module.sound
{
	import flash.events.Event;
	import flash.filesystem.File;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.net.URLRequest;
	import flash.utils.Dictionary;
	
	import framework.common.vo.SoundParam;
	import framework.module.BaseModuleEx;
	import framework.module.msg.MessageConstants;

	public class SoundManager extends BaseModuleEx
	{
		private static var _instance:SoundManager = null;
		public function SoundManager()
		{
			if(_instance)
			{
				throw new Error("Singlton Instance Error!");
			}
		}
		
		private var appDirectory:File = null;
//		private var soundParamDict:Dictionary = null;		//参数缓存	
		private var soundDict:Dictionary = null;			//声音SOUND对象缓存
//		private var soundChannelDict:Dictionary = null;		//声音Channel对象缓存
		private var volumn:int = 1;							//声音
		override public function initializer():void
		{
			super.initializer();
//			soundChannelDict = new Dictionary();
//			soundParamDict = new Dictionary();
			soundDict = new Dictionary();
			appDirectory = File.applicationDirectory;		//获取安装目录
			
			addFrameworkListener(MessageConstants.MSG_FMK_SOUND_PLAY,onPlay);				//播放
			addFrameworkListener(MessageConstants.MSG_FMK_SOUND_PAUSE,onPause);				//暂停
			addFrameworkListener(MessageConstants.MSG_FMK_SOUND_RESUME,onResume);			//恢复
			addFrameworkListener(MessageConstants.MSG_FMK_SOUND_REMOVE,onRemove);			//移除
//			addFrameworkListener(MessageConstants.MSG_FMK_SOUND_CHANGEVOL,onChangeVol);
			addFrameworkListener(MessageConstants.MSG_FMK_SOUND_OFF,onSoundOff);
			addFrameworkListener(MessageConstants.MSG_FMK_SOUND_ON,onSoundOn);
		}
		
		/**
		 * 关闭声音
		 **/
		private function onSoundOff(id:String,params:Object = null):void
		{
			volumn = 0;
			updateVol();
		}
		
		private function onSoundOn(id:String,params:Object = null):void
		{
			volumn = 1;
			updateVol();
		}
		
		private function updateVol():void
		{
			for each(var sound:Music in soundDict)
			{
//				sound.changeVol(volumn);
				sound.vol = volumn;
			}
		}
		
//		private function onChangeVol(id:String, params:Object = null):void
//		{
//			var param:SoundParam = params as SoundParam;
//			var soundId:String = param.soundId;
//			var sound:Music = null;
//			var soundChannel:SoundChannel = null;
//			if(soundId in soundDict)
//			{
//				sound = soundDict[soundId];
//			}
//		}
		
		private function onPlay(id:String,params:Object = null):void
		{
			var param:SoundParam = params as SoundParam;
			var soundId:String = param.soundId;
//			if(!(soundId in soundParamDict))
//			{
//				soundParamDict[soundId] = param;
//			}
			if(volumn==0)
				return;
			
			var sound:Music = null;
			var soundChannel:SoundChannel = null;
			if(!(soundId in soundDict))
			{
				sound = soundDict[soundId] = new Music(param);
//				var music:File = appDirectory.resolvePath(param.soundId + ".mp3");
//				sound.load(new URLRequest(param.soundPath));
				sound.vol = volumn;
				soundChannel = sound.play(0,param.repeatCount);
				soundChannel.soundTransform.volume = volumn;
				if(param.repeatCount > 0)
				{
					sound.onComplete = onPlayerComplete;
				}
				
//				soundChannelDict[soundId] = soundChannel;
			}
			else
			{
				sound = soundDict[soundId];
				sound.vol = volumn;
				sound.play(0,param.repeatCount);
				if(param.repeatCount > 0)
				{
					sound.onComplete = onPlayerComplete;
				}
			}
		}
		
//		private function onPlayComplete(event:Event):void
		private function onPlayerComplete(id:String):void
		{
			if(id in soundDict)
			{
				var music:Music = soundDict[id];
				if(!music.attribute.cache)
				{
					delete soundDict[id];
				}
			}
//			var playChannel:SoundChannel = event.target as SoundChannel;
//			playChannel.removeEventListener(Event.SOUND_COMPLETE,onPlayComplete);
//			var sound:Music = null;
//			if (id in soundDict)
//			{
//				sound = soundDict[id];
//				delete soundDict[id];
//				if(sound.attribute && null != sound.attribute.completeFunc)
//				{
//					sound.attribute.completeFunc(sound.attribute);
//				}
//				if(channel == playChannel)
//				{
//					var param:SoundParam = soundParamDict[key];
//					delete soundChannelDict[key];
//					delete soundParamDict[key];

//					if(param.completeFunc != null)
//					{
//						param.completeFunc(param);
//					}
//				}
//			}
		}
		
		/**
		 * 暂停正在播放的音乐
		 */
		private function onPause(id:String,params:Object = null):void
		{
			var param:SoundParam = params as SoundParam;
			if(param.soundId in soundDict)
			{
				var sound:Music = soundDict[param.soundId];
				
				sound.pause();
			}
		}
		
		/**
		 * 恢复音乐播放
		 */
		private function onResume(id:String,params:Object = null):void
		{
			var param:SoundParam = params as SoundParam;
			if(param.soundId in soundDict)
			{
				var sound:Music = soundDict[param.soundId];
				sound.play();
			}
		}
		
		/**
		 * 移除音乐
		 */
		private function onRemove(id:String,params:Object = null):void
		{
			var param:SoundParam = params as SoundParam;
			if(param.soundId in soundDict)
			{
				var sound:Music = soundDict[param.soundId];
				delete soundDict[param.soundId];
				sound.stop();
			}
		}
		
		public static function get instance():SoundManager
		{
			if(!_instance)
			{
				_instance = new SoundManager();
			}
			
			return _instance;
		}
	}
}

//import com.greensock.TweenMax;

import flash.events.Event;
import flash.media.Sound;
import flash.media.SoundChannel;
import flash.media.SoundTransform;
import flash.net.URLRequest;

import framework.common.vo.SoundParam;

import starling.animation.Tween;
import starling.core.Starling;

class Music extends Sound
{
	private var loaded:Boolean = false;
	private var _playing:Boolean = false;
	private var _channel:SoundChannel = null;
	private var _attribute:SoundParam = null;
	private var _pauseSeek:Number = 0;
	private var _isPause:Boolean = false;
	public function get id():String
	{
		if(_attribute)
		{
			return _attribute.soundId;
		}
		return "";
	}
	
	public function get attribute():SoundParam
	{
		return _attribute;
	}
	public function Music(param:SoundParam)
	{
		_attribute = param;
	}
	
	private var _vol:Number = 1;
	public function set vol(value:Number):void
	{
		_vol = value;
		if(transform)
		{
			transform.volume = _vol;
		}
	}
	
	public var onComplete:Function = null;
	private var isLoop:Boolean = false;
	private var transform:SoundTransform = null;
	override public function play(startTime:Number=0, loops:int=0, sndTransform:SoundTransform=null):SoundChannel
	{
		if(!loaded && !_channel)
		{
			prepredSound();	
		}
		isLoop = (loops == 0);
		var start:Number = startTime;
		if(_isPause)
		{
			start = _pauseSeek;
			_pauseSeek = 0;
			_isPause = false;
		}
		transform = sndTransform;
		
//		if(!_channel)
//		{
////			_channel = super.play(start, (isLoop ? int.MAX_VALUE:loops), sndTransform);
//			_channel = super.play(start, 1, sndTransform);
//			
////			if(!isLoop)
////			{
////				_channel.addEventListener(Event.SOUND_COMPLETE,onPlayComplete);
////			}
//		}
//		else
//		{
//			_channel = super.play(start, 1, sndTransform);
////			if(!isLoop)
////			{
////				_channel.addEventListener(Event.SOUND_COMPLETE,onPlayComplete);
////			}
//		}
		if(!transform)
		{
			transform = new SoundTransform();
		}
		transform.volume = _vol;
		_channel = super.play(start, 1, transform);
		if(_channel)
		{
			_channel.addEventListener(Event.SOUND_COMPLETE,onPlayComplete);
		}
		return _channel;
	}
	
	private function onPlayComplete(event:Event):void
	{
//		_channel.removeEventListener(Event.SOUND_COMPLETE,onPlayComplete);
		if(!isLoop)
		{
			if(null != onComplete)
			{
				onComplete(_attribute.soundId);
			}
		}
		else
		{
			if(_channel)
			{
				_channel.stop();
				_channel=  null;
			}
			_channel = super.play(0, 1, transform);
		}
	}
	
	private function prepredSound():void
	{
		if(_attribute)
		{
			loaded = true;
			load(new URLRequest(_attribute.soundPath));
		}
	}
	
	public function stop(tween:Boolean = true):void
	{
		if(_channel)
		{
			if(tween)
			{
				var orgVol:Number = _channel.soundTransform.volume;
				
//				var anim:Tween = new Tween(_channel.soundTransform,.3);
//				anim.animate("volume",0);
//				anim.onComplete = function():void{
//					_channel.stop();
////					_channel.soundTransform.volume = orgVol;
//				};
				
//				TweenMax.to(_channel,1,{volume:0, onComplete:function():void{
//					_channel.stop();
//					_channel.soundTransform.volume = orgVol;
//					_channel = null;
//				}})
//				Starling.juggler.add(anim);
			}
			else
			{
				_channel.stop();	
			}
			
		}
	}
	
	public function changeVol(value:Number,tween:Boolean = false):void
	{
		if(_channel)
		{
			_channel.soundTransform.volume = value;
		}
	}
	
	public function pause(tween:Boolean = true):void
	{
		if(_channel)
		{
			
			if(tween)
			{
				var orgVol:Number = _channel.soundTransform.volume;
//				TweenMax.to(_channel,1,{volume:0, onComplete:function():void{
//					_pauseSeek = _channel.position;
//					_channel.stop();
//					_channel.soundTransform.volume = orgVol;
//					_channel = null;
//				}})
			}
			else
			{
				_channel.stop();
			}
			_isPause = true;
		}
	}
}