/**
 * Morn UI Version 2.4.1027 http://www.mornui.com/
 * Feedback yungzhu@gmail.com http://weibo.com/newyung
 */
package morn.core.components {
	import flash.events.MouseEvent;
	
	import morn.core.utils.ObjectUtils;
	
	import starling.display.DisplayObject;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	
	/**单选框按钮*/
	public class RadioButton extends Button {
		protected var _value:Object;
		
		public function RadioButton(skin:String = null, label:String = "") {
			super(skin, label);
		}
		
		override protected function preinitialize():void {
			super.preinitialize();
			_toggle = false;
			_autoSize = false;
		}
		
		override protected function initialize():void {
			super.initialize();
			_btnLabel.autoSize = "left";
			//addEventListener(TouchEvent.TOUCH, onClick);
		}
		
		override protected function changeLabelSize():void {
			_btnLabel.width = _btnLabel.textField.textWidth + 5 + _btnLabel.format.letterSpacing + _bitmap.width;
			_btnLabel.height = _btnLabel.textField.textHeight + 5;
			_btnLabel.x = _bitmap.width + _labelMargin[0];
			_btnLabel.y = (_bitmap.height - _btnLabel.height) * 0.5 + _labelMargin[1];
			
			reDraw();
		}
		
		override public function commitMeasure():void {
			exeCallLater(changeLabelSize);
		}
		
		protected function onClick(e:TouchEvent):void {
			var touch:Touch = e.getTouch(e.currentTarget as DisplayObject, TouchPhase.BEGAN);
			if(touch)
			{
				selected = !selected;
			}
		}
		
		/**组件关联的可选用户定义值*/
		public function get value():Object {
			return _value != null ? _value : label;
		}
		
		public function set value(obj:Object):void {
			_value = obj;
		}
	}
}