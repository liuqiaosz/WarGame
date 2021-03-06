/**
 * Morn UI Version 2.4.1027 http://www.mornui.com/
 * Feedback yungzhu@gmail.com http://weibo.com/newyung
 */
package morn.core.components {
//	import flash.display.BitmapData;
	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.filters.GlowFilter;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.text.TextFormat;
	import flash.ui.Keyboard;
	
	import morn.core.utils.ObjectUtils;
	import morn.core.utils.StringUtils;
	
	import starling.core.Starling;
	import starling.display.DisplayObject;
	import starling.display.Image;
	import starling.events.KeyboardEvent;
	import starling.events.TouchEvent;
	import starling.extend.AdvanceTextField;
	import starling.text.TextField;
	import starling.text.TextFieldAutoSize;
	import starling.textures.Texture;
	import starling.textures.TextureSmoothing;
	import starling.utils.Color;
	
	/**文本发生改变后触发*/
	[Event(name="change",type="starling.events.Event")]
	
	/**文字标签*/
	public class Label extends Component {
		public static const DEFAULT_WIDTH:int = 100;
		public static const DEFAULT_HEIGHT:int = 30;
		
//		protected var _textField:flash.text.TextField;
//		protected var _format:TextFormat;
		protected var _text:String = "";
		protected var _isHtml:Boolean;
		protected var _stroke:String;
		protected var _skin:String;
//		protected var _bitmap:AutoBitmap;
		protected var _margin:Array = [0, 0, 0, 0];
//		protected var _starlingTextField:AdvanceTextField = null;
		protected var _starlingTextField:AdvanceTextField = null;
		public function Label(text:String = "", skin:String = null) {
			this.text = text;
			this.skin = skin;
			this.touchable = false;
		}
		
		override protected function preinitialize():void {
			//mouseEnabled = false;
			mouseChildren = true;
		}
		
		override protected function createChildren():void {
//			_bitmap = new AutoBitmap();
//			_textField = new flash.text.TextField();
			if(!_starlingTextField)
			{
				_starlingTextField = new AdvanceTextField(DEFAULT_WIDTH,DEFAULT_HEIGHT,"");
			}
			
		}
		
		override protected function initialize():void {
//			_format = _textField.defaultTextFormat;
//			_format.font = Styles.fontName;
//			_format.size = Styles.fontSize;
//			_format.color = Styles.labelColor;
//			_textField.selectable = false;
//			_textField.autoSize = TextFieldAutoSize.LEFT;
			
			_starlingTextField.fontName = Styles.fontName;
			_starlingTextField.fontSize = Styles.fontSize;
			_starlingTextField.color = Styles.labelColor;
			_starlingTextField.batchable = true;
			this.selectable = false;
//			_starlingTextField.autoSize = TextFieldAutoSize.HORIZONTAL;
			addChild(_starlingTextField);
//			_bitmap.sizeGrid = [2, 2, 2, 2];
		}
		
		/**显示的文本*/
		public function get text():String {
			return _text;
		}
		
		public function set text(value:String):void 
		{
			if (_text != value) 
			{
				if(value == "undefined")
				{
					value = "";
				}
				_text = value || "";
				_starlingTextField.text = _text;
				callLater(changeText);
				sendEvent(starling.events.Event.CHANGE);
			}
		}
		
		protected function changeText():void {
			_starlingTextField.redraw();
//			if(!_isBitmapFont)
//			{
//				if(_format != null) {
//					_textField.defaultTextFormat = _format;
//				}
//				_isHtml ? _textField.htmlText = App.lang.getLang(_text) : _textField.text = App.lang.getLang(_text);
//				
//				reDraw();
//			}
//			else
//			{
//				if(_starlingTextField)
//				{
//					_starlingTextField.text = _text;
//				}
//			}
		}
		
		override public function reDraw():void {
			
//			if(!_isBitmapFont)
//			{
//				removeChildren(0, -1, true);
//				//画到场景里
//				var tempWidth:Number = width;
//				if(tempWidth == 0)
//				{
//					tempWidth = _textField.textWidth + 5;
//				}
//				var tempHeight:Number = height;
//				if(tempHeight == 0)
//				{
//					tempHeight = _textField.textHeight + 5;
//				}
//				
//				if(tempWidth > 0 && tempHeight > 0)
//				{
//					if(_bitmap.clips != null)
//					{
//						var bitdata:BitmapData = new BitmapData(_bitmap.width, _bitmap.height, true, 0x0);
//						bitdata.draw(_bitmap.bitmapData);
//						var tex:Texture = Texture.fromBitmapData(bitdata);
//						bitdata.dispose();
//						var im:starling.display.Image = new starling.display.Image(tex);
//						im.scaleX = tempWidth / _bitmap.bitmapData.width;
//						im.scaleY = tempHeight / _bitmap.bitmapData.height;
//						addChild(im);
//					}
//					
//					if(_textField.type == TextFieldType.INPUT)
//					{
//						//trace("input");
//					}
//					else
//					{
//						var bitmapData:BitmapData = new BitmapData(tempWidth, tempHeight, true, 0x0);
//						bitmapData.draw(_textField, null, null, null, new Rectangle(0, 0, tempWidth, tempHeight));
//						var texture:Texture = Texture.fromBitmapData(bitmapData, false, false, scale);
//						bitmapData.dispose();
//						var mImage:starling.display.Image = new starling.display.Image(texture);
//						mImage.touchable = true;
//						mImage.smoothing = TextureSmoothing.NONE;
//						addChild(mImage);
//					}
//				}
//			}
		}
		
		override protected function changeSize():void {
			if (!isNaN(_width)) {
//				_textField.autoSize = TextFieldAutoSize.NONE;
				_starlingTextField.width = _width - _margin[0] - _margin[2];
//				_textField.width = _width - _margin[0] - _margin[2];
				if (isNaN(_height) && wordWrap) {
//					_textField.autoSize = TextFieldAutoSize.LEFT;
				} else {
					_height = isNaN(_height) ? 18 : _height;
//					_textField.height = _height - _margin[1] - _margin[3];
					_starlingTextField.height = _height - _margin[1] - _margin[3];
				}
			} else {
				_width = _height = NaN;
//				_textField.autoSize = TextFieldAutoSize.LEFT;
			}
			callLater(changeText);
			super.changeSize();
		}
		
		/**是否是html格式*/
		public function get isHtml():Boolean {
			return _isHtml;
		}
		
		public function set isHtml(value:Boolean):void {
			if (_isHtml != value) {
				_isHtml = value;
				_starlingTextField.isHtml = value;
				callLater(changeText);
			}
		}
		
		/**描边(格式:color,alpha,blurX,blurY,strength,quality)*/
		public function get stroke():String {
			return _stroke;
		}
		
		public function set stroke(value:String):void {
//			if (_stroke != value) {
//				_stroke = value;
//				ObjectUtils.clearFilter(_textField, GlowFilter);
//				if (Boolean(_stroke)) {
//					var a:Array = StringUtils.fillArray(Styles.labelStroke, _stroke);
//					ObjectUtils.addFilter(_textField, new GlowFilter(a[0], a[1], a[2], a[3], a[4], a[5]));
//				}
//			}
		}
		
		/**是否是多行*/
		public function get multiline():Boolean {
//			return _textField.multiline;
			return _starlingTextField.multiline;
		}
		
		public function set multiline(value:Boolean):void {
//			_textField.multiline = value;
			_starlingTextField.multiline = value;
		}
		
		/**是否是密码*/
		public function get asPassword():Boolean {
//			return _textField.displayAsPassword;
			return false;
		}
		
		public function set asPassword(value:Boolean):void {
//			_textField.displayAsPassword = value;
		}
		
		/**宽高是否自适应*/
		public function get autoSize():String {
//			return _textField.autoSize;
			return _starlingTextField.autoSize;
		}
		
		public function set autoSize(value:String):void {
//			if(_starlingTextField)
//			{
//				_starlingTextField.autoSize = value;
//			}
//			else
//			{
//				_textField.autoSize = value;
//			}
			_starlingTextField.autoSize = value;
		}
		
		/**是否自动换行*/
		public function get wordWrap():Boolean {
//			return _textField.wordWrap;
			return _starlingTextField.wordWrap;
		}
		
		public function set wordWrap(value:Boolean):void {
//			_textField.wordWrap = value;
			_starlingTextField.wordWrap = value;
		}
		
		/**是否可选*/
		public function get selectable():Boolean {
//			return _textField.selectable;
			return touchable;
		}
		
		public function set selectable(value:Boolean):void {
//			_textField.selectable = value;
			//mouseEnabled = value;
			touchable = value;
		}
		
		/**是否具有背景填充*/
		public function get background():Boolean {
//			return _textField.background;
			return false;
		}
		
		public function set background(value:Boolean):void {
//			_textField.background = value;
			
		}
		
		/**文本字段背景的颜色*/
		public function get backgroundColor():uint {
//			return _textField.backgroundColor;
			return 0xffffff;
		}
		
		public function set backgroundColor(value:uint):void {
//			_textField.backgroundColor = value;
		}
		
		/**字体颜色*/
		public function get color():Object {
//			return _format.color;
			return _starlingTextField.color;
		}
		
		public function set color(value:Object):void {
//			_format.color = value;
//			_starlingTextField.color = value;
			_starlingTextField.color = uint(value);
			callLater(changeText);
		}
		
		/**字体类型*/
		public function get font():String {
//			if(!_isBitmapFont)
//			{
//				return _format.font;
//			}
//			else
//			{
//				return _starlingTextField.fontName;
//			}
			return _starlingTextField.fontName;
		}
		
		public function set font(value:String):void {
//			if(Config.enableBitmapFont && Config.bitmapFonts.indexOf(value) >= 0)
//			{
//				this.setBitmapFont(value);
//			}
//			
//			if(!_isBitmapFont)
//			{
//				_format.font = value;
//				callLater(changeText);
//			}
//			else
//			{
//				_starlingTextField.fontName = value;
//				callLater(changeText);
//			}
			_starlingTextField.fontName = value;
			callLater(changeText);
		}
		
		/**对齐方式*/
		public function get align():String {
//			return _format.align;
//			return _starlingTextField.hAlign;
//			return _starlingTextField.format.align;
			return _starlingTextField.hAlign;
		}
		
		public function set align(value:String):void {
//			_format.align = value;
//			callLater(changeText);
//			_starlingTextField.format.align = value;
			_starlingTextField.hAlign = value;
			callLater(changeText);
		}
		
		/**粗体类型*/
		public function get bold():Object {
//			return _format.bold;
			return _starlingTextField.bold;
		}
		
		public function set bold(value:Object):void {
//			_format.bold = value;
			_starlingTextField.bold = value;
			callLater(changeText);
		}
		
		/**垂直间距*/
		public function get leading():Object {
//			return _format.leading;
			return _starlingTextField.format.leading;
		}
		
		public function set leading(value:Object):void {
//			_format.leading = value;
			_starlingTextField.format.leading = value;
			_starlingTextField.leading = int(value);
			callLater(changeText);
		}
		
		/**第一个字符的缩进*/
		public function get indent():Object {
//			return _format.indent;
			return _starlingTextField.format.indent;
		}
		
		public function set indent(value:Object):void {
//			_format.indent = value;
			_starlingTextField.format.indent = value;
			callLater(changeText);
		}
		
		/**字体大小*/
		public function get size():Object {
//			return _format.size;
			return _starlingTextField.fontSize;
		}
		
		public function set size(value:Object):void {
//			if(!_isBitmapFont)
//			{
//				_format.size = value;
//				callLater(changeText);
//			}
//			else
//			{
//				_starlingTextField.fontSize = Number(value);
//				callLater(changeText);
//			}
			_starlingTextField.fontSize = Number(value);
			callLater(changeText);
		}
		
		/**下划线类型*/
		public function get underline():Object {
//			return _format.underline;
			return _starlingTextField.format.underline;
		}
		
		public function set underline(value:Object):void {
//			_format.underline = value;
			_starlingTextField.format.underline = value;
			callLater(changeText);
		}
		
		/**字间距*/
		public function get letterSpacing():Object {
			return _starlingTextField.format.letterSpacing;
		}
		
		public function set letterSpacing(value:Object):void {
//			_format.letterSpacing = value;
			_starlingTextField.format.leading = value;
			callLater(changeText);
		}
		
		/**边距(格式:左边距,上边距,右边距,下边距)*/
		public function get margin():String {
			return _margin.join(",");
		}
		
		public function set margin(value:String):void {
//			_margin = StringUtils.fillArray(_margin, value, int);
//			_textField.x = _margin[0];
//			_textField.y = _margin[1];
//			callLater(changeSize);
		}
		
		/**格式*/
		public function get format():TextFormat {
//			return _format;
			return _starlingTextField.format;
		}
		
		public function set format(value:TextFormat):void {
//			_format = value;
			_starlingTextField.format = value;
//			callLater(changeText);
		}
		
		/**文本控件实体*/
		public function get textField():flash.text.TextField {
//			return _textField;
			return null;
		}
		
		/**将指定的字符串追加到文本的末尾*/
		public function appendText(newText:String):void {
//			text += newText;
			text = _text + newText;
		}
		
		/**皮肤*/
		public function get skin():String {
			return _skin;
		}
		
		public function set skin(value:String):void {
//			if (_skin != value) {
//				_skin = value;
//				_bitmap.bitmapData = App.asset.getBitmapData(_skin);
//				if(_bitmap.bitmapData)
//				{
//					_contentWidth = _bitmap.bitmapData.width;
//					_contentHeight = _bitmap.bitmapData.height;
//				}
//			}
		}
		
		/**九宫格信息(格式:左边距,上边距,右边距,下边距)*/
		public function get sizeGrid():String {
//			return _bitmap.sizeGrid.join(",");
			return "0,0,0,0,";
		}
		
		public function set sizeGrid(value:String):void {
//			_bitmap.sizeGrid = StringUtils.fillArray(Styles.defaultSizeGrid, value, int);
		}
		
		override public function commitMeasure():void {
//			exeCallLater(changeText);
			exeCallLater(changeSize);
		}
		
		override public function get width():Number {
			if (!isNaN(_width) || Boolean(_skin) || Boolean(_text)) {
				return super.width;
			}
			return 0;
		}
		
		override public function set width(value:Number):void {
			super.width = value;
//			_bitmap.width = value;
			this._starlingTextField.width = value;
			
			changeSize();
		}
		
		override public function get height():Number {
			if (!isNaN(_height) || Boolean(_skin) || Boolean(_text)) {
				return super.height;
			}
			return 0;
		}
		
		override public function set height(value:Number):void {
			super.height = value;
//			_bitmap.height = value;
			_starlingTextField.height = value;
			changeSize();
		}
		
		override public function set dataSource(value:Object):void {
			_dataSource = value;
			if (value is Number || value is String) {
				text = String(value);
			} else {
				super.dataSource = value;
			}
		}
		
		public function get textImage():DisplayObject
		{
			return _starlingTextField.textImage;
		}
//		private var _isBitmapFont:Boolean = false;
//		public function setBitmapFont(fontName:String):void
//		{
//			_isBitmapFont = true;
//			if(!_starlingTextField)
//			{
//				_starlingTextField = new AdvanceTextField(width,height,_text,"Verdana",Number(size));
//				_starlingTextField.color = Color.WHITE;
//				removeChildren();
//				addChild(_starlingTextField);
//			}
//			_starlingTextField.fontName = fontName;
//		}
//		
//		
//		public function get isBitmapFont():Boolean
//		{
//			return _isBitmapFont;
//		}
		
		public function set vAlign(value:String):void
		{
			_starlingTextField.vAlign = value;
		}
		
		public function set hAlign(value:String):void
		{
			_starlingTextField.hAlign = value;
		}
	}
}