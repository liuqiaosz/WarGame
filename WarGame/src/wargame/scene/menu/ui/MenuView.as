package wargame.scene.menu.ui
{
	import flash.geom.Point;
	
	import lib.animation.core.AnimationTween;
	import lib.ui.control.UIImage;
	import lib.ui.control.UIScaleButton;
	import lib.ui.control.UIView;
	
	import starling.animation.Transitions;
	import starling.animation.Tween;
	import starling.core.Starling;

	/**
	 * 菜单UI视图
	 * 
	 * start
	 * 	-> save1
	 * 	-> save2
	 * 	-> save3
	 * continue
	 * option
	 * 	-> sound
	 * 	
	 **/
	public class MenuView extends UIView
	{
		public var itemBar1:UIScaleButton = null;
		public var itemBar2:UIScaleButton = null;
		public var itemBar3:UIScaleButton = null;
		
		public var onSelect:Function = null;
		public function MenuView()
		{
			loadUI("MenuUI");
			itemBar1.onSelect = onMenuClick;
			itemBar2.onSelect = onMenuClick;
			itemBar3.onSelect = onMenuClick;
		}
		
		private function onMenuClick(img:UIImage):void
		{
			if(null != onSelect)
			{
				onSelect();
			}
		}
		
		public function fadeFlyOut():void
		{
			var distance:int = 0;
			
			var pos:Point = itemBar1.localToGlobal(new Point());
			
			distance = -(pos.x + itemBar1.width);
			
			var anim:Tween = new Tween(itemBar1,.3,Transitions.EASE_IN_OUT_BACK);
			anim.moveTo(distance,itemBar1.y);
			anim.fadeTo(0);
			Starling.juggler.add(anim);

			Starling.juggler.delayCall(function():void{
				anim = new Tween(itemBar2,.3,Transitions.EASE_IN_OUT_BACK);
				anim.moveTo(distance,itemBar2.y);
				anim.fadeTo(0);
				Starling.juggler.add(anim);
			
			},.1);
			
			Starling.juggler.delayCall(function():void{
				anim = new Tween(itemBar3,.3,Transitions.EASE_IN_OUT_BACK);
				anim.moveTo(distance,itemBar3.y);
				anim.fadeTo(0);
				Starling.juggler.add(anim);
				
			},.2);
		}
		
		public function fadeFlyIn():void
		{
			
		}
	}
}