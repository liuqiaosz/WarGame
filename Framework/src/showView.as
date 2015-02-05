package
{
	import flash.geom.Point;
	
	import framework.module.notification.NotificationIds;
	import framework.module.scene.SceneManager;
	import framework.module.scene.vo.ViewParam;

	public class showView
	{
		
		public function showView(view:String,data:Object = null,
								 animation:Boolean = true,isPopup:Boolean = false,modal:Boolean = false,pos:Point = null,
								 offset:Point = null,maskAlpha:Number = .75,layer:String = "LayerDialog")
		{
			var viewParam:ViewParam = new ViewParam();
			viewParam.view = view;
			viewParam.data = data;
			viewParam.anim = animation;
			viewParam.isPop = isPopup;
			viewParam.modal = modal;
			viewParam.pos = pos;
			viewParam.offset = offset;
			viewParam.maskAlpha = maskAlpha;
			viewParam.layer = layer;
			
			sendViewMessage(NotificationIds.MSG_VIEW_SHOWVIEW,viewParam);
		}
	}
}