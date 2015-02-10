package wargame.utility
{
	public class Utility
	{
		public function Utility()
		{
		}
		
		public static function get isTest():Boolean
		{
			CONFIG::test
			{
				return true;
			}
			return false;
		}
		
	}
}