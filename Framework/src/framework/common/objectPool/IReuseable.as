package framework.common.objectPool
{
	/**
	 * 可复用对象实现的接口
	 */

	public interface IReuseable
	{
		/**
		 * 调用此方法后，会对对象进行复位
		 * 为下一次的重用作好准备
		 */
		function reuse():void;
	}
}