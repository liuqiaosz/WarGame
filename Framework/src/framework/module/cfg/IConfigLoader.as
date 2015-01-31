package framework.module.cfg
{
	/**
	 * 扩展用配置加载器
	 */
	public interface IConfigLoader
	{
		function load(path:String):Boolean;
		function getConfig():Object;
	}
}