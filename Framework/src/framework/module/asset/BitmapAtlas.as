package framework.module.asset
{
	import flash.display.BitmapData;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.Dictionary;
	
	public class BitmapAtlas
	{
		private var mAtlasTexture:BitmapData;
		private var mTextureRegions:Dictionary;
		private var mTextureFrames:Dictionary;
		private var regionDict:Dictionary = null;
		private static var sNames:Vector.<String> = new <String>[];
		public function BitmapAtlas(texture:BitmapData, atlasXml:XML=null)
		{
			mTextureRegions = new Dictionary();
			mTextureFrames  = new Dictionary();
			regionDict = new Dictionary();
			mAtlasTexture   = texture;
			
			if (atlasXml)
				parseAtlasXml(atlasXml);
		}
		
		/** Disposes the atlas texture. */
		public function dispose():void
		{
			mAtlasTexture.dispose();
		}
		
		/** This function is called by the constructor and will parse an XML in Starling's 
		 *  default atlas file format. Override this method to create custom parsing logic
		 *  (e.g. to support a different file format). */
		protected function parseAtlasXml(atlasXml:XML):void
		{
			for each (var subTexture:XML in atlasXml.SubTexture)
			{
				var name:String        = subTexture.attribute("name");
				var x:Number           = parseFloat(subTexture.attribute("x"));
				var y:Number           = parseFloat(subTexture.attribute("y"));
				var width:Number       = parseFloat(subTexture.attribute("width"));
				var height:Number      = parseFloat(subTexture.attribute("height"));
				var frameX:Number      = parseFloat(subTexture.attribute("frameX"));
				var frameY:Number      = parseFloat(subTexture.attribute("frameY"));
				var frameWidth:Number  = parseFloat(subTexture.attribute("frameWidth"));
				var frameHeight:Number = parseFloat(subTexture.attribute("frameHeight"));
				
				var region:Rectangle = new Rectangle(x, y, width, height);
				var frame:Rectangle  = frameWidth > 0 && frameHeight > 0 ?
					new Rectangle(frameX, frameY, frameWidth, frameHeight) : null;
				
				addRegion(name, region, frame);
			}
		}
		
		
		/** Retrieves a subtexture by name. Returns <code>null</code> if it is not found. */
		public function getTexture(name:String):BitmapData
		{
			var region:Rectangle = mTextureRegions[name];
			if(name in regionDict)
			{
				return regionDict[name];
			}
			if (region == null)
			{
				return null;
			}
			else
			{
				var img:BitmapData = new BitmapData(region.width,region.height,true,0);
				img.copyPixels(mAtlasTexture,region,new Point());
				regionDict[name] = img;
				return img;
			}
		}
		
		/** Returns all textures that start with a certain string, sorted alphabetically
		 *  (especially useful for "MovieClip"). */
		public function getTextures(prefix:String="", result:Vector.<BitmapData>=null):Vector.<BitmapData>
		{
			if (result == null) result = new <BitmapData>[];
			
			for each (var name:String in getNames(prefix, sNames)) 
			result.push(getTexture(name)); 
			
			sNames.length = 0;
			return result;
		}
		
		/** Returns all texture names that start with a certain string, sorted alphabetically. */
		public function getNames(prefix:String="", result:Vector.<String>=null):Vector.<String>
		{
			if (result == null) result = new <String>[];
			
			for (var name:String in mTextureRegions)
				if (name.indexOf(prefix) == 0)
					result.push(name);
			
			result.sort(Array.CASEINSENSITIVE);
			return result;
		}
		
		/** Returns the region rectangle associated with a specific name. */
		public function getRegion(name:String):Rectangle
		{
			return mTextureRegions[name];
		}
		
		/** Returns the frame rectangle of a specific region, or <code>null</code> if that region 
		 *  has no frame. */
		public function getFrame(name:String):Rectangle
		{
			return mTextureFrames[name];
		}
		
		/** Adds a named region for a subtexture (described by rectangle with coordinates in 
		 *  pixels) with an optional frame. */
		public function addRegion(name:String, region:Rectangle, frame:Rectangle=null):void
		{
			mTextureRegions[name] = region;
			mTextureFrames[name]  = frame;
		}
		
		/** Removes a region with a certain name. */
		public function removeRegion(name:String):void
		{
			delete mTextureRegions[name];
			delete mTextureFrames[name];
		}
		
		/** The base texture that makes up the atlas. */
		public function get texture():BitmapData { return mAtlasTexture; }
	}
}