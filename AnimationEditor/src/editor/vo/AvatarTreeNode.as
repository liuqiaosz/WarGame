package editor.vo
{
	import flash.display.Bitmap;
	
	import lib.animation.avatar.cfg.ConfigAvatar;
	import lib.animation.avatar.cfg.atom.ConfigUnit;

	public class AvatarTreeNode
	{
		public var avatar:ConfigAvatar = null;
		public var atom:ConfigUnit = null;
		
		public var levelRes:Vector.<Vector.<Bitmap>> = null;
		public function get name():String
		{
			if(atom)
			{
				return atom.name;
			}
			return "";
		}
		
		public function AvatarTreeNode()
		{
			
		}
		
		public function init():void
		{
			if(atom && atom.level && atom.level.length)
			{
				levelRes = new Vector.<Vector.<Bitmap>>(atom.level.length);
			}
		}
		
		public function getResByLv(lv:int):Vector.<Bitmap>
		{
			if(levelRes && lv > 0 && lv <= levelRes.length)
			{
				return levelRes[lv - 1];
			}
			
			return null;
		}
	}
}