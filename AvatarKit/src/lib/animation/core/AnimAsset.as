package lib.animation.core
{
	public class AnimAsset
	{
		public static var avatarDirectory:String = "";
		public static var effectDirectory:String = "";
		public static var isDebug:Boolean = false;
		public function AnimAsset()
		{
		}
		
		public static function getAvatarUrl(id:String):Array
		{
			if(isDebug)
			{
				return [avatarDirectory + "/" + id + ".png",avatarDirectory + "/" + id + ".xml"];
			}
			else
			{
				return [avatarDirectory + "/" + id + ".tap"];
			}
		}
		
		public static function getEffectUrl(id:String):Array
		{
			if(isDebug)
			{
				return [effectDirectory + "/" + id + ".png",effectDirectory + "/" + id + ".xml"];
			}
			else
			{
				return [effectDirectory + "/" + id + ".tap"];
			}
		}
	}
}