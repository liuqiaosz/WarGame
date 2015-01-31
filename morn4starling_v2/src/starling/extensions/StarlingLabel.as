package starling.extensions
{
	import morn.editor.core.IComponent;
	
	import starling.extend.AdvanceTextField;
	
	public class StarlingLabel extends AdvanceTextField
	{
		public static const DEFAULT_WIDTH:int = 100;
		public static const DEFAULT_HEIGHT:int = 30;
		
		public function StarlingLabel()
		{
			super(DEFAULT_WIDTH,DEFAULT_HEIGHT,"");
		}
	}
}