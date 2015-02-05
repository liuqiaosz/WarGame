package  editor.anim.avatar
{
	import editor.anim.core.Animation;
	import editor.asset.ResourceManager;
	import editor.cfg.ConfigManager;
	import editor.setting.EditorSetting;
	
	import flash.display.Bitmap;
	
	import lib.animation.avatar.cfg.ConfigAvatar;
	import lib.animation.avatar.cfg.ConfigAvatarAction;


	public class Avatar extends Animation implements IAvatar
	{
		private var currentAction:ConfigAvatarAction = null;
		private var config:ConfigAvatar = null;
		private var avatarFrames:Vector.<Bitmap> = null;
		private var actionFrames:Vector.<Bitmap> = null;
		public function Avatar(config:ConfigAvatar)
		{
			this.config = config;
			//var atlas:TextureAtlas = AnimAssetManager.instance.getTextureAtlas(config.id);
			if(ResourceManager.instance.hasAsset(config.id))
			{
				avatarFrames = ResourceManager.instance.getAssetById(config.id);
				frameLoaded = true;
			}
			else
			{
				ResourceManager.instance.loadAssetDirectory(config.id,EditorSetting.instance.setting.directory.avatarDirectory + "/" + config.id,onAssetLoadComplete);
			}
		}
		
		private function onAssetLoadComplete():void
		{
			avatarFrames = ResourceManager.instance.getAssetById(config.id);
			frameLoaded = true;
			if(onPlayDelay)
			{
				//running = true;
				onPlayDelay = false;
				
				if(currentAction)
				{
					if(!actionFrames)
					{
						actionFrames = new Vector.<Bitmap>();
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
					super.frames = avatarFrames;
					//播放接口调用
					super.play(currentAction.duration,_loop,_progress,_complete);
					_progress = _complete = null;
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
						actionFrames = new Vector.<Bitmap>();
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
					super.frames = avatarFrames;
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