package
{
	import editor.ui.PopUpWindowProxy;
	
	import mx.core.IFlexDisplayObject;

	public function popup(window:Class,modal:Boolean = true):IFlexDisplayObject
	{
		return PopUpWindowProxy.popup(window,modal);
	}
}