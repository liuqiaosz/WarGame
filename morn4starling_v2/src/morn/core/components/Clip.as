/**
 * Morn UI Version 2.4.1020 http://www.mornui.com/
 * Feedback yungzhu@gmail.com http://weibo.com/newyung
 */
package morn.core.components {
	import flash.display.BitmapData;
	import flash.geom.Rectangle;
	
	import morn.core.events.UIEvent;
	import morn.core.handlers.Handler;
	import morn.core.utils.BitmapUtils;
	import morn.core.utils.StringUtils;
	import morn.editor.core.IClip;
	
	import starling.display.Image;
	import starling.events.Event;
	import starling.textures.Texture;
	import starling.textures.TextureAtlas;
	
	/**图片加载后触发*/
	[Event(name="imageLoaded",type="morn.core.events.UIEvent")]
	/**当前帧发生变化后触发*/
	[Event(name="frameChanged",type="morn.core.events.UIEvent")]
	
	/**位图剪辑*/
	public class Clip extends Component implements IClip {
		protected var _autoStopAtRemoved:Boolean = true;
//		protected var _bitmap:AutoBitmap;
		protected var _clipX:int = 1;
		protected var _clipY:int = 1;
		protected var _clipWidth:Number;
		protected var _clipHeight:Number;
		protected var _url:String;
		protected var _autoPlay:Boolean;
		protected var _interval:int = Config.MOVIE_INTERVAL;
		protected var _from:int = -1;
		protected var _to:int = -1;
		protected var _complete:Handler;
		protected var _isPlaying:Boolean;
		private var textureWidth:int = 0;
		private var textureHeight:int = 0;
		private var clipCount:int = 0;
		private var _frame:int = 0;
		/**位图切片
		 * @param url 资源类库名或者地址
		 * @param clipX x方向个数
		 * @param clipY y方向个数*/
		public function Clip(url:String = null, clipX:int = 1, clipY:int = 1) {
			_clipX = clipX;
			_clipY = clipY;
			this.url = url;
		}
		
		override protected function createChildren():void {
//			_bitmap = new AutoBitmap();
		}
		
		override protected function initialize():void {
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			addEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);
		}
		
		protected function onAddedToStage(e:Event):void {
			if (_autoPlay) {
				play();
			}
		}
		
		protected function onRemovedFromStage(e:Event):void {
			if (_autoStopAtRemoved) {
				stop();
			}
		}
		
		/**位图剪辑地址*/
		public function get url():String {
			return _url;
		}
		
		public function set url(value:String):void {
			if(value && Config.resAtlas)
			{
				_url = value;
//				_url = value.substr(value.lastIndexOf(".") + 1);	
				callLater(changeClip);
			}
			else
			{
				if (_url != value && Boolean(value)) {
					_url = value;
					callLater(changeClip);
				}
			}
		}
		
		/**切片X轴数量*/
		public function get clipX():int {
			return _clipX;
		}
		
		public function set clipX(value:int):void {
			if (_clipX != value) {
				_clipX = value;
				callLater(changeClip);
			}
		}
		
		/**切片Y轴数量*/
		public function get clipY():int {
			return _clipY;
		}
		
		public function set clipY(value:int):void {
			if (_clipY != value) {
				_clipY = value;
				callLater(changeClip);
			}
		}
		
		/**单切片宽度，同时设置优先级高于clipX*/
		public function get clipWidth():Number {
			return _clipWidth;
		}
		
		public function set clipWidth(value:Number):void {
			_clipWidth = value;
			_rect.width = value;
			callLater(changeClip);
		}
		
		/**单切片高度，同时设置优先级高于clipY*/
		public function get clipHeight():Number {
			return _clipHeight;
		}
		
		public function set clipHeight(value:Number):void {
			_clipHeight = value;
//			_rect.height = value;
			callLater(changeClip);
		}
		
		private var idx:int = 0;
		private var atlas:TextureAtlas = null;
		private var len:int = 0;
		private var texture:Texture = null;
		protected function changeClip():void {
			if (App.asset.hasClass(_url)) {
				if(!texture)
				{
					loadComplete(_url, App.asset.getBitmapData(_url));
				}
				else
				{
					reDraw();
				}
			} else 
			{
				/**2014-04-15 modify by liuqiao**/
				if(Config.resAtlas)
				{
					texture = UITextureAtlas.getTexture(_url);
					if(texture)
					{
//						if(_bitmap)
//						{
//							_bitmap.texture = texture;
//							_bitmap.isClip = true;
							textureWidth = texture.width;
							clipCount = textureWidth / this._clipWidth;
							_rect.height = textureHeight = texture.height;
							texture = null;
							reDraw();
//						}
					}
//					len = Config.resAtlasNode.length;
//					for(idx = 0; idx<Config.resAtlasNode.length; idx++)
//					{
//						atlas = Config.resAtlasNode[idx].atlas;	
//						texture = atlas.getTexture(_url);
//						if(texture)
//						{
//							if(_bitmap)
//							{
//								_bitmap.texture = texture;
//								_bitmap.isClip = true;
//								textureWidth = texture.width;
//								_rect.height = textureHeight = texture.height;
//								texture = null;
//								reDraw();
//							}
//							break;
//						}
//					}
				}
				else
				{
					App.loader.loadBMD(_url, new Handler(loadComplete, [_url]));
				}
			}
		}
		
		protected function loadComplete(url:String, bmd:BitmapData):void {
			if (url == _url && bmd) {
				if (!isNaN(_clipWidth)) {
					_clipX = Math.ceil(bmd.width / _clipWidth);
				}
				if (!isNaN(_clipHeight)) {
					_clipY = Math.ceil(bmd.height / _clipHeight);
				}
//				clips = BitmapUtils.createClips(bmd, _clipX, _clipY);
				
				reDraw();
			}
		}
		
		/**源位图数据*/
//		public function get clips():Vector.<BitmapData> {
//			return _bitmap.clips;
//		}
		
//		public function set clips(value:Vector.<BitmapData>):void {
//			if (value) {
//				_bitmap.clips = value;
//				_contentWidth = _bitmap.width;
//				_contentHeight = _bitmap.height;
//			}
//			sendEvent(UIEvent.IMAGE_LOADED);
//		}
		
		override public function set width(value:Number):void {
			super.width = value;
//			_bitmap.width = value;
		}
		
		override public function set height(value:Number):void {
			super.height = value;
//			_bitmap.height = value;
		}
		
		override public function commitMeasure():void {
			exeCallLater(changeClip);
		}
		
		/**九宫格信息(格式:左边距,上边距,右边距,下边距)*/
//		public function get sizeGrid():String {
//			if (_bitmap.sizeGrid) {
//				return _bitmap.sizeGrid.join(",");
//			}
//			return null;
//		}
//		
//		public function set sizeGrid(value:String):void {
//			_bitmap.sizeGrid = StringUtils.fillArray(Styles.defaultSizeGrid, value);
//		}
		
		/**当前帧*/
		public function get frame():int {
//			return _bitmap.index;
			return _frame;
		}
		
		public function set frame(value:int):void {
			if(_frame == value)
			{
				return;
			}
//			_bitmap.index = value;
			_frame = value;
			if(_frame < 0)
			{
				_frame = 0;
			}
			if(clipCount > 0 && _frame >= clipCount)
			{
				_frame = clipCount - 1;
			}
			sendEvent(UIEvent.FRAME_CHANGED);
//			if (_bitmap.index == _to) {
//				stop();
//				_to = -1;
//				if (_complete != null) {
//					var handler:Handler = _complete;
//					_complete = null;
//					handler.execute();
//				}
//			}
			
			reDraw();
		}
		
		/**切片帧的总数*/
		public function get totalFrame():int {
//			return _bitmap.clips ? _bitmap.clips.length : 0;
			return clipCount;
		}
		
		/**从显示列表删除后是否自动停止播放*/
		public function get autoStopAtRemoved():Boolean {
			return _autoStopAtRemoved;
		}
		
		public function set autoStopAtRemoved(value:Boolean):void {
			_autoStopAtRemoved = value;
		}
		
		/**自动播放*/
		public function get autoPlay():Boolean {
			return _autoPlay;
		}
		
		public function set autoPlay(value:Boolean):void {
//			if (_autoPlay != value) {
//				_autoPlay = value;
//				_autoPlay ? play() : stop();
//			}
		}
		
		/**动画播放间隔(单位毫秒)*/
		public function get interval():int {
			return _interval;
		}
		
		public function set interval(value:int):void {
			if (_interval != value) {
				_interval = value;
				if (_isPlaying) {
					play();
				}
			}
		}
		
		/**是否正在播放*/
		public function get isPlaying():Boolean {
			return _isPlaying;
		}
		
		public function set isPlaying(value:Boolean):void {
			_isPlaying = value;
		}
		
		/**开始播放*/
		public function play():void {
//			_isPlaying = true;
//			frame = _bitmap.index;
//			App.timer.doLoop(_interval, loop);
		}
		
		protected function loop():void {
			frame++;
		}
		
		/**停止播放*/
		public function stop():void {
			App.timer.clearTimer(loop);
			_isPlaying = false;
		}
		
		/**从指定的位置播放*/
		public function gotoAndPlay(frame:int):void {
			this.frame = frame;
			play();
		}
		
		/**跳到指定位置并停止*/
		public function gotoAndStop(frame:int):void {
			stop();
			this.frame = frame;
		}
		
		/**从某帧播放到某帧，播放结束发送事件
		 * @param from 开始帧(为-1时默认为第一帧)
		 * @param to 结束帧(为-1时默认为最后一帧) */
		public function playFromTo(from:int = -1, to:int = -1, complete:Handler = null):void {
			_from = from == -1 ? 0 : from;
			_to = to == -1 ? _clipX * _clipY - 1 : to;
			_complete = complete;
			gotoAndPlay(_from);
		}
		
		override public function set dataSource(value:Object):void {
			_dataSource = value;
			if (value is int || value is String) {
				frame = int(value);
			} else {
				super.dataSource = value;
			}
		}
		
		/**是否对位图进行平滑处理*/
		public function get smoothing():Boolean {
//			return _bitmap.smoothing;
			return false;
		}
		
		public function set smoothing(value:Boolean):void {
//			_bitmap.smoothing = value;
		}
		
		/**位图实体*/
		public function get bitmap():AutoBitmap {
//			return _bitmap;
			return null;
		}
		
		private var _img:starling.display.Image = null;
		private var _rectTexture:Texture = null;
		private var _rect:Rectangle = new Rectangle();
		private var _region:Rectangle = null;
		private var _maxFrame:int = 0;
//		private var _index:int = 0;
		
		override public function reDraw():void {
			if(!texture)
			{
				if(!Config.resAtlas)
				{
					removeChildren(0, -1, true);
					App.asset.destroyClips(_url);
					App.loader.clearResLoaded(_url);
					
//					var bitdata:BitmapData = new BitmapData(clipWidth, _bitmap.clips[_bitmap.index].height, true, 0x0);
//					bitdata.draw(_bitmap);
					var bmp:BitmapData = App.asset.getBitmapData(_url);
					if(bmp)
					{
						clipHeight = bmp.height;
						texture = Texture.fromBitmapData(bmp);
						textureHeight = texture.height;
//						bmp.dispose();
					}
//					_img = new starling.display.Image(tex);
//					_img.scaleX = width / _bitmap.clips[_bitmap.index].width;
//					_img.scaleY = height / _bitmap.clips[_bitmap.index].height;
//					addChild(_img);
				}
				else
				{
					texture = UITextureAtlas.getTexture(_url);
					if(texture)
					{
						textureHeight = texture.height;
						//横向
//						_rect.x = _clipWidth * _frame;
//						_rect.y = 0;
//						if(!_region)
//						{
//							_region = new Rectangle(0,0,_clipWidth,textureHeight);
//						}
//						
//						_rectTexture = Texture.fromTexture(texture,_rect,_region);
//						if(!_img)
//						{
//							_img = new starling.display.Image(_rectTexture);
//							addChild(_img);
//						}
//						else
//						{
//							_img.texture = _rectTexture;
//						}
					}
//					if(_bitmap.texture)
//					{
//						_index = _bitmap.index;
//						if(_maxFrame == 0)
//						{
//							_maxFrame = textureWidth / _clipWidth;
//						}
//						if(_index >= _maxFrame)
//						{
//							_index = _maxFrame - 1;
//						}
//						//横向
//						_rect.x = _clipWidth * _frame;
//						_rect.y = 0;
//						if(!_region)
//						{
//							_region = new Rectangle(0,0,_clipWidth,textureHeight);
//						}
//						
//						_rectTexture = Texture.fromTexture(_bitmap.texture,_rect,_region);
//						if(!_img)
//						{
//							_img = new starling.display.Image(_rectTexture);
//							addChild(_img);
//						}
//						else
//						{
//							_img.texture = _rectTexture;
//						}
//					}
				}
			}
			if(texture)
			{
				_rect.x = _clipWidth * _frame;
				_rect.y = 0;
				if(!_region)
				{
					_region = new Rectangle(0,0,_clipWidth,textureHeight);
				}
				_rect.height = textureHeight;
				_rectTexture = Texture.fromTexture(texture,_rect,_region);
				if(!_img)
				{
					_img = new starling.display.Image(_rectTexture);
					addChild(_img);
				}
				else
				{
					_img.texture = _rectTexture;
				}
			}
		}
		
		/**销毁资源
		 * @param	clearFromLoader 是否同时删除加载缓存*/
//		public function dispose(clearFromLoader:Boolean = false):void {
//			App.asset.destroyClips(_url);
//			_bitmap.bitmapData = null;
//			if (clearFromLoader) {
//				App.loader.clearResLoaded(_url);
//			}
//		}
		
	}
}