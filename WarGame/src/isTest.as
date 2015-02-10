package
{
	public function isTest():Boolean
	{
		CONFIG::test
		{
			return true;
		}
		return false;
	}
}