package editor.animation.avatar
{
	import editor.asset.ResourceManager;
	
	import flash.events.Event;
	import flash.utils.Dictionary;
	import flash.utils.getTimer;
	
	import lib.animation.avatar.IAvatar;
	import lib.animation.avatar.cfg.ConfigAvatar;
	
	import mx.core.FlexGlobals;

	public class AvatarManager
	{
		public static var _instance:AvatarManager = null;
		public static function get instance():AvatarManager
		{
			if(!_instance)
			{
				_instance = new AvatarManager();
			}
			return _instance;
		}
		
		private var configDict:Dictionary = null;
		private var isInit:Boolean = false;
		private var lastAdvance:int = 0;
		protected var avatars:Vector.<AvatarNav> = null;
		public function AvatarManager()
		{
			avatars = new Vector.<AvatarNav>();
			lastAdvance = getTimer();
			configDict = new Dictionary();
			
			FlexGlobals.topLevelApplication.addEventListener(Event.ENTER_FRAME,advanceTime);
		}
		
		/**
		 * 初始化
		 **/
		public function init(value:Array):void
		{
			if(value && value.length)
			{
				isInit = true;
				var avatar:ConfigAvatar = null;
				for each(var avr:Object in value)
				{
					avatar = ConfigAvatar.decode(avr);
					configDict[avatar.id] = avatar;
				}
			}
		}
		
		public function advanceTime(event:Event):void
		{
			var now:int = getTimer();
			var delta:int = now - lastAdvance;
			for(var idx:int = 0; idx<avatars.length; idx++)
			{
				avatars[idx].update(delta);
			}
			lastAdvance = now;
		}
		
		public function addAvatar(avatar:AvatarNav):void
		{
			if(avatars.indexOf(avatar) < 0)
			{
				avatars.push(avatar);
			}
		}
		
		public function removeAvatar(avatar:AvatarNav):void
		{
			if(avatars.indexOf(avatar) >= 0)
			{
				avatars.splice(avatars.indexOf(avatar),1);
			}
		}
		
		/**
		 * 通过ID查找avatar
		 **/
		public function createtAvatarById(id:String):AvatarNav
		{
			if(id in configDict)
			{
				var cfg:ConfigAvatar = configDict[id];
				return new AvatarNav(cfg,ResourceManager.instance.getAssetById(id));
			}
			return null;
		}
	}
}