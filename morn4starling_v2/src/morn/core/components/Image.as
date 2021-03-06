/**
 * Morn UI Version 2.4.1027 http://www.mornui.com/
 * Feedback yungzhu@gmail.com http://weibo.com/newyung
 */
package morn.core.components {
	import com.adobe.utils.AGALMiniAssembler;
	
	import flash.display.BitmapData;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.Dictionary;
	
	import morn.core.events.UIEvent;
	import morn.core.handlers.Handler;
	import morn.core.utils.StringUtils;
	import morn.editor.core.IComponent;
	
	import starling.display.Image;
	import starling.display.QuadBatch;
	import starling.display.Sprite;
	import starling.textures.Texture;
	import starling.textures.TextureAtlas;
	
	/**图片被加载后触发*/
	[Event(name="imageLoaded",type="morn.core.events.UIEvent")]
	
	/**图像类*/
//	public class Image extends Component {
	public class Image extends Component
	{
//		protected var _bitmap:AutoBitmap;
		
		protected static var ScaleCache:Dictionary = new Dictionary();
		
		protected var _url:String;
		protected var _img:starling.display.Image = null;
		protected var _scaleGridBatch:QuadBatch = null;
		protected var _frame:Rectangle = null;
		protected var isScaleGrid:Boolean = false;
		protected var gridSize:Array = null;
		protected var scaleRect:Rectangle = null;
		protected var scaleTexture:Scale9Texture = null;
		
		public function Image(url:String = null) 
		{
			super();
			this.url = url;
		}
		
//		override protected function createChildren():void {
//			_bitmap = new AutoBitmap();
			//addChild(_bitmap = new AutoBitmap());
//		}
		
		/**图片地址*/
		public function get url():String {
			return _url;
		}
		private var idx:int = 0;
		private var atlas:TextureAtlas = null;
		private var len:int = 0;
		private var texture:Texture = null;
		public function set url(value:String):void 
		{
			if (_url != value)
			{
				if(texture)
				{
					texture.dispose();
					texture = null;
				}
				_url = value;
				if (Boolean(value))
				{
					if(Config.resAtlas)
					{
						texture = UITextureAtlas.getTexture(_url);
						if(texture)
						{
							reDraw();
							dispatchEvent(new UIEvent(UIEvent.IMAGE_LOADED,null));
						}
					}
					else
					{
						var bmp:BitmapData = null;
						if (App.asset.hasClass(_url)) 
						{
							bmp = App.asset.getBitmapData(_url);
							if(bmp)
							{
								texture = Texture.fromBitmapData(bmp);
								reDraw();
							}
						}
						else
						{
							App.loader.loadBMD(_url, new Handler(setBitmapData, [_url]));
						}
					}
				}
//				else 
//				{
//					bitmapData = null;
//				}
			}
		}
		
		override public function reDraw():void
		{
			if(texture)
			{
				if(isScaleGrid)//九宫格处理
				{
					_frame = texture.frame;
					if(!_frame)
					{
						_frame = new Rectangle(0,0,texture.width,texture.height);
					}
					if(_img)
					{
						_img.removeFromParent(true);
						_img = null;
					}
					scale9GridDraw();
				}
				else
				{
					if(!_img)
					{
						_img = new starling.display.Image(texture);
						addChild(_img);
					}
					else
					{
						_img.texture = texture;
					}
				}
			}
		}
		
		/**
		 * 更新内容锚点
		 **/
		public function updatePivot(px:Number,py:Number):void
		{
			if(_img)
			{
				_img.x = px;
				_img.y = py;
			}
			else if(this._scaleGridBatch)
			{
				_scaleGridBatch.x = px;
				_scaleGridBatch.y = py;
			}
		}
		
		private var gridClip:starling.display.Image = null;
		private function scale9GridDraw():void
		{
			scaleRect = new Rectangle();
			//构造scalegrid数据
			scaleRect.x = gridSize[0];
			scaleRect.y = gridSize[1];
			scaleRect.width = _frame.width - scaleRect.x - gridSize[2];
			scaleRect.height = _frame.height - scaleRect.y - gridSize[3];
			
			//这里用资源路径+九宫格设置来生成KEY值查询缓存是否已经有相同的面板缓存
			var key:String = _url + "_" + _gridSize;
			
			if(key in ScaleCache)
			{
				scaleTexture = ScaleCache[key];
			}
			else
			{
				scaleTexture = new Scale9Texture(texture,scaleRect);
				ScaleCache[key] = scaleTexture;
			}
			if(!_scaleGridBatch)
			{
				_scaleGridBatch = new QuadBatch();
				_scaleGridBatch.batchable = true;
				addChild(_scaleGridBatch);
			}
			_scaleGridBatch.reset();
			
			if(!gridClip)
			{
				gridClip = new starling.display.Image(scaleTexture.topLeft);
			}
//			clip.smoothing = this.smoothing;
//			clip.color = this.color;
			
			var scaledLeftWidth:Number = scaleRect.x;
			var scaledTopHeight:Number = scaleRect.y;
			var scaledRightWidth:Number = (this._frame.width - scaleRect.x - scaleRect.width);
			var scaledBottomHeight:Number = (this._frame.height - scaleRect.y - scaleRect.height);
			const scaledCenterWidth:Number = this._width - scaledLeftWidth - scaledRightWidth;
			const scaledMiddleHeight:Number = this._height - scaledTopHeight - scaledBottomHeight;
			if(scaledCenterWidth < 0)
			{
				var offset:Number = scaledCenterWidth / 2;
				scaledLeftWidth += offset;
				scaledRightWidth += offset;
			}
			if(scaledMiddleHeight < 0)
			{
				offset = scaledMiddleHeight / 2;
				scaledTopHeight += offset;
				scaledBottomHeight += offset;
			}
			
			if(scaledTopHeight > 0)
			{
				if(scaledLeftWidth > 0)
				{
					gridClip.texture = scaleTexture.topLeft;
					gridClip.readjustSize();
					gridClip.width = scaledLeftWidth;
					gridClip.height = scaledTopHeight;
					gridClip.x = scaledLeftWidth - gridClip.width;
					gridClip.y = scaledTopHeight - gridClip.height;
					_scaleGridBatch.addImage(gridClip);
				}
				
				if(scaledCenterWidth > 0)
				{
					gridClip.texture = scaleTexture.topCenter;
					gridClip.readjustSize();
					gridClip.width = scaledCenterWidth;
					gridClip.height = scaledTopHeight;
					gridClip.x = scaledLeftWidth;
					gridClip.y = scaledTopHeight - gridClip.height;
					_scaleGridBatch.addImage(gridClip);
				}
				
				if(scaledRightWidth > 0)
				{
					gridClip.texture = scaleTexture.topRight;
					gridClip.readjustSize();
					gridClip.width = scaledRightWidth;
					gridClip.height = scaledTopHeight;
					gridClip.x = this._width - scaledRightWidth;
					gridClip.y = scaledTopHeight - gridClip.height;
					_scaleGridBatch.addImage(gridClip);
				}
			}
			
			if(scaledMiddleHeight > 0)
			{
				if(scaledLeftWidth > 0)
				{
					gridClip.texture = scaleTexture.middleLeft;
					gridClip.readjustSize();
					gridClip.width = scaledLeftWidth;
					gridClip.height = scaledMiddleHeight;
					gridClip.x = scaledLeftWidth - gridClip.width;
					gridClip.y = scaledTopHeight;
					_scaleGridBatch.addImage(gridClip);
				}
				
				if(scaledCenterWidth > 0)
				{
					gridClip.texture = scaleTexture.middleCenter;
					gridClip.readjustSize();
					gridClip.width = scaledCenterWidth;
					gridClip.height = scaledMiddleHeight;
					gridClip.x = scaledLeftWidth;
					gridClip.y = scaledTopHeight;
					_scaleGridBatch.addImage(gridClip);
				}
				
				if(scaledRightWidth > 0)
				{
					gridClip.texture = scaleTexture.middleRight;
					gridClip.readjustSize();
					gridClip.width = scaledRightWidth;
					gridClip.height = scaledMiddleHeight;
					gridClip.x = this._width - scaledRightWidth;
					gridClip.y = scaledTopHeight;
					_scaleGridBatch.addImage(gridClip);
				}
			}
			
			if(scaledBottomHeight > 0)
			{
				if(scaledLeftWidth > 0)
				{
					gridClip.texture = scaleTexture.bottomLeft;
					gridClip.readjustSize();
					gridClip.width = scaledLeftWidth;
					gridClip.height = scaledBottomHeight;
					gridClip.x = scaledLeftWidth - gridClip.width;
					gridClip.y = this._height - scaledBottomHeight;
					_scaleGridBatch.addImage(gridClip);
				}
				
				if(scaledCenterWidth > 0)
				{
					gridClip.texture = scaleTexture.bottomCenter;
					gridClip.readjustSize();
					gridClip.width = scaledCenterWidth;
					gridClip.height = scaledBottomHeight;
					gridClip.x = scaledLeftWidth;
					gridClip.y = this._height - scaledBottomHeight;
					_scaleGridBatch.addImage(gridClip);
				}
				
				if(scaledRightWidth > 0)
				{
					gridClip.texture = scaleTexture.bottomRight;
					gridClip.readjustSize();
					gridClip.width = scaledRightWidth;
					gridClip.height = scaledBottomHeight;
					gridClip.x = this._width - scaledRightWidth;
					gridClip.y = this._height - scaledBottomHeight;
					_scaleGridBatch.addImage(gridClip);
				}
			}
		}
		
		/**源位图数据*/
//		public function get bitmapData():BitmapData 
//		{
//			return _bitmap.bitmapData;
//		}
//		
//		public function set bitmapData(value:BitmapData):void {
//			if (value) {
//				_contentWidth = value.width;
//				_contentHeight = value.height;
//			}
//			_bitmap.bitmapData = value;
//			sendEvent(UIEvent.IMAGE_LOADED);
//			
//			reDraw();
//		}
		
		protected function setBitmapData(url:String, bmd:BitmapData):void 
		{
			if (url == _url && bmd)
			{
				texture = Texture.fromBitmapData(bmd);
				bmd.dispose();
				callLater(reDraw);
			}
		}
				
		public static const ANCHOR_LT:int = 1;
		public static const ANCHOR_CENTER:int = 2;
		
		public function set anchor(value:int):void
		{
			switch(value)
			{
				case ANCHOR_CENTER:
					if(_img)
					{
						var w:Number = _img.width >> 1;
						var h:Number = _img.height >> 1;
						_img.x = -w;
						_img.y = -h;
						x += w;
						y += h;
					}
					break;
				default:
					break;
			}
		}
		
		override public function set width(value:Number):void
		{
			super.width = value;
			callLater(reDraw);
//			_bitmap.width = width;
//			
//			App.render.callLater(reDraw);
		}
		
		override public function set height(value:Number):void {
			super.height = value;
			callLater(reDraw);
//			_bitmap.height = height;
//			
//			App.render.callLater(reDraw);
		}
		
		/**九宫格信息(格式:左边距,上边距,右边距,下边距)*/
		public function get sizeGrid():String 
		{
//			if (_bitmap.sizeGrid) {
//				return _bitmap.sizeGrid.join(",");
//			}
			return null;
		}
		
		private var _gridSize:String = "";
		public function set sizeGrid(value:String):void
		{
			if(value)
			{
				_gridSize = value;
				gridSize = StringUtils.fillArray(Styles.defaultSizeGrid, value);
				isScaleGrid = true;
				scaleRect = null;
				scaleTexture = null;
//				callLater(reDraw);
				reDraw();
			}
		}
		
		/**位图控件实例*/
//		public function get bitmap():AutoBitmap
//		{
//			return _bitmap;
//		}
		
		/**是否对位图进行平滑处理*/
//		public function get smoothing():Boolean
//		{
////			return _bitmap.smoothing;
//			return this.smoothing;
//		}
		
//		public function set smoothing(value:Boolean):void
//		{
////			_bitmap.smoothing = value;
//			smoothing = value;
//		}
		
//		override public function set dataSource(value:Object):void 
//		{
//			_dataSource = value;
//			if (value is String) {
//				url = String(value);
//			} else {
//				super.dataSource = value;
//			}
//		}
		
		/**销毁资源
		 * @param	clearFromLoader 是否同时删除加载缓存*/
//		public function dispose(clearFromLoader:Boolean = false):void {
//			App.asset.disposeBitmapData(_url);
//			_bitmap.bitmapData = null;
//			if (clearFromLoader) {
//				App.loader.clearResLoaded(_url);
//			}
//		}
		
		
		override public function dispose():void
		{
			if(_img)
			{
				_img.removeFromParent(true);
				_img = null;
			}
			if(texture)
			{
				texture.dispose();
				texture = null;
			}
			if(this._scaleGridBatch)
			{
				_scaleGridBatch.removeFromParent(true);
				_scaleGridBatch = null;
			}
			super.dispose();
		}
	}
}

import flash.geom.Rectangle;

import starling.textures.Texture;

class Scale9Texture
{
	private var _texture:Texture = null;
	private var _scale9Grid:Rectangle = new Rectangle();

	public var topLeft:Texture = null;
	public var topCenter:Texture = null;
	public var topRight:Texture = null;
	public var middleLeft:Texture = null;
	public var middleCenter:Texture = null;
	public var middleRight:Texture = null;
	public var bottomLeft:Texture;
	public var bottomCenter:Texture = null;
	public var bottomRight:Texture = null;
	
	public function Scale9Texture(value:Texture,grid:Rectangle)
	{
		_texture = value;
		_scale9Grid = grid.clone();
		
		var texWidth:Number = _texture.width;
		var texHeight:Number = _texture.height;
		
		var textureFrame:Rectangle = _texture.frame;
		if(!textureFrame)
		{
			textureFrame = new Rectangle(0,0,_texture.width,_texture.height);
		}
		const leftWidth:Number = _scale9Grid.x;
		const centerWidth:Number = _scale9Grid.width;
		const rightWidth:Number = textureFrame.width - _scale9Grid.width - _scale9Grid.x;
		const topHeight:Number = _scale9Grid.y;
		const middleHeight:Number = _scale9Grid.height;
		const bottomHeight:Number = textureFrame.height - _scale9Grid.height - _scale9Grid.y;
		
		const regionLeftWidth:Number = leftWidth + textureFrame.x;
		const regionTopHeight:Number = topHeight + textureFrame.y;
		const regionRightWidth:Number = rightWidth - (textureFrame.width - texWidth) - textureFrame.x;
		const regionBottomHeight:Number = bottomHeight - (textureFrame.height - texHeight) - textureFrame.y;
		
		const hasLeftFrame:Boolean = regionLeftWidth != leftWidth;
		const hasTopFrame:Boolean = regionTopHeight != topHeight;
		const hasRightFrame:Boolean = regionRightWidth != rightWidth;
		const hasBottomFrame:Boolean = regionBottomHeight != bottomHeight;
		
		const topLeftRegion:Rectangle = new Rectangle(0, 0, regionLeftWidth, regionTopHeight);
		const topLeftFrame:Rectangle = (hasLeftFrame || hasTopFrame) ? new Rectangle(textureFrame.x, textureFrame.y, leftWidth, topHeight) : null;
		topLeft = Texture.fromTexture(_texture, topLeftRegion, topLeftFrame);
		
		const topCenterRegion:Rectangle = new Rectangle(regionLeftWidth, 0, centerWidth, regionTopHeight);
		const topCenterFrame:Rectangle = hasTopFrame ? new Rectangle(0, textureFrame.y, centerWidth, topHeight) : null;
		topCenter = Texture.fromTexture(_texture, topCenterRegion, topCenterFrame);
		
		const topRightRegion:Rectangle = new Rectangle(regionLeftWidth + centerWidth, 0, regionRightWidth, regionTopHeight);
		const topRightFrame:Rectangle = (hasTopFrame || hasRightFrame) ? new Rectangle(0, textureFrame.y, rightWidth, topHeight) : null;
		topRight = Texture.fromTexture(_texture, topRightRegion, topRightFrame);
		
		const middleLeftRegion:Rectangle = new Rectangle(0, regionTopHeight, regionLeftWidth, middleHeight);
		const middleLeftFrame:Rectangle = hasLeftFrame ? new Rectangle(textureFrame.x, 0, leftWidth, middleHeight) : null;
		middleLeft = Texture.fromTexture(_texture, middleLeftRegion, middleLeftFrame);
		
		const middleCenterRegion:Rectangle = new Rectangle(regionLeftWidth, regionTopHeight, centerWidth, middleHeight);
		middleCenter = Texture.fromTexture(_texture, middleCenterRegion);
		
		const middleRightRegion:Rectangle = new Rectangle(regionLeftWidth + centerWidth, regionTopHeight, regionRightWidth, middleHeight);
		const middleRightFrame:Rectangle = hasRightFrame ? new Rectangle(0, 0, rightWidth, middleHeight) : null;
		middleRight = Texture.fromTexture(_texture, middleRightRegion, middleRightFrame);
		
		const bottomLeftRegion:Rectangle = new Rectangle(0, regionTopHeight + middleHeight, regionLeftWidth, regionBottomHeight);
		const bottomLeftFrame:Rectangle = (hasLeftFrame || hasBottomFrame) ? new Rectangle(textureFrame.x, 0, leftWidth, bottomHeight) : null;
		bottomLeft = Texture.fromTexture(_texture, bottomLeftRegion, bottomLeftFrame);
		
		const bottomCenterRegion:Rectangle = new Rectangle(regionLeftWidth, regionTopHeight + middleHeight, centerWidth, regionBottomHeight);
		const bottomCenterFrame:Rectangle = hasBottomFrame ? new Rectangle(0, 0, centerWidth, bottomHeight) : null;
		bottomCenter = Texture.fromTexture(_texture, bottomCenterRegion, bottomCenterFrame);
		
		const bottomRightRegion:Rectangle = new Rectangle(regionLeftWidth + centerWidth, regionTopHeight + middleHeight, regionRightWidth, regionBottomHeight);
		const bottomRightFrame:Rectangle = (hasBottomFrame || hasRightFrame) ? new Rectangle(0, 0, rightWidth, bottomHeight) : null;
		bottomRight = Texture.fromTexture(_texture, bottomRightRegion, bottomRightFrame);
	}
}