package editor.vo
{
	import lib.animation.effect.cfg.ConfigEffect;

	public class EffectTreeNode
	{
		public var config:ConfigEffect = null;
		
		public function EffectTreeNode(value:ConfigEffect)
		{
			config = value;
		}
		
		public function get name():String
		{
			if(config)
			{
				return config.name;
			}
			return "";
		}
	}
}