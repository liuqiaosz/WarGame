package lib.ui.control
{
	import extension.asset.AssetsManager;
	
	import lib.ui.core.IComponent;
	import lib.ui.core.IContainer;
	
	import starling.display.DisplayObject;
	import starling.display.Sprite;
	import starling.text.TextField;

	public class UIView extends UIContainer
	{
		private static var ComponentClass:Object = {
			"img":UIImage,
			"button" : UIButton,
			"box" : UIContainer,
			"scroll" : UIScrollView,
			"view" : UIView,
			"scalebtn" : UIScaleButton
		};
		
		public function UIView()
		{
			
		}
		
		protected function loadUI(url:String):void
		{
			
			var doc:XML = AssetsManager.instance.getXml(url) as XML;
			if(doc)
			{
				createComponent(doc);
			}
		}
		
		protected function createComponent(xml:XML,container:IContainer = null):void
		{
			for each(var node:XML in xml.component)
			{
				var cls:Class = ComponentClass[node.@type];
				var comp:IComponent = new cls() as IComponent;
				comp.componentXml = node;
				if(!container)
				{
					addChild(comp as DisplayObject);
				}
				else
				{
					container.addChild(comp as DisplayObject);
				}
				
				var vname:String = comp.getVarName();
				if(this.hasOwnProperty(vname))
				{
					this[vname] = comp;
				}
				if(node.component)
				{
					createComponent(node,comp as IContainer);
				}
//				for each(var child:XML in node.component)
//				{
//					createComponent(child,comp as IContainer);
//				}
			}
		}
	}
}