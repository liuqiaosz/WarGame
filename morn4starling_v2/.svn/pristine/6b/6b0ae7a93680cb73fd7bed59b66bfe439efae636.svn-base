/**
 * Morn UI Version 2.1.0623 http://www.mornui.com/
 * Feedback yungzhu@gmail.com http://weibo.com/newyung
 */
package morn.core.components {
	import flash.events.KeyboardEvent;
	import flash.events.TextEvent;
	import flash.geom.Rectangle;
	import flash.text.TextFieldType;
	
	import morn.core.events.UIEvent;
	
	import starling.core.Starling;
	import starling.display.DisplayObject;
	import starling.events.Event;
	
	/**当用户输入文本时调度*/
	[Event(name="textInput",type="starling.events.Event")]
	
	/**文本发生改变后触发*/
	[Event(name="change",type="starling.events.Event")]
	
	/**输入框*/
	public class TextInput extends Label {
		
		public function TextInput(text:String = "", skin:String = null) {
			super(text, skin);
		}
		
		override protected function initialize():void {
			width = 128;
			height = 22;
			selectable = true;
			_textField.type = TextFieldType.INPUT;
			_textField.autoSize = "none";
			_textField.needsSoftKeyboard = true;
			_textField.requestSoftKeyboard();
			super.initialize();
			
			addEventListener(Event.REMOVED_FROM_STAGE, onRemoveFromStage);
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			addEventListener(UIEvent.MOVE, onMoving);
		}
		
		private function onMoving(e:UIEvent):void {
			callLater(changeSize);
		}
		
		private function onAddedToStage(e:Event):void {
			if(editable) {
				Starling.current.nativeOverlay.addChild(_textField);
			}
		}
		
		private function onRemoveFromStage(e:Event):void {
			if(editable) {
				Starling.current.nativeOverlay.removeChild(_textField);
			}
		}
		
		/**指示用户可以输入到控件的字符集*/
		public function get restrict():String {
			return _textField.restrict;
		}
		
		public function set restrict(value:String):void {
			_textField.restrict = value;
		}
		
		override protected function changeSize():void {
			_textField.x = x;
			_textField.y = y;
			var parentObj:DisplayObject = parent;
			while(parentObj) {
				_textField.x += parentObj.x;
				_textField.y += parentObj.y;
				
				parentObj = parentObj.parent;
			}
			super.changeSize();
		}
		
		/**是否可编辑*/
		public function get editable():Boolean {
			return _textField.type == TextFieldType.INPUT;
		}
		
		public function set editable(value:Boolean):void {
			_textField.type = value ? TextFieldType.INPUT : TextFieldType.DYNAMIC;
		}
		
		/**最多可包含的字符数*/
		public function get maxChars():int {
			return _textField.maxChars;
		}
		
		public function set maxChars(value:int):void {
			_textField.maxChars = value;
		}
	}
}