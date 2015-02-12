package
{
	public function get isTest():Boolean
	{
		CONFIG::test
		{
			return true;
		}
		return false;
	}
}