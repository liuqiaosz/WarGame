package
{
	import editor.ui.PopUpWindowProxy;
	
	import mx.core.IFlexDisplayObject;

	public function popup(window:Object,modal:Boolean = true):IFlexDisplayObject
	{
		return PopUpWindowProxy.popup(window,modal);
	}
}