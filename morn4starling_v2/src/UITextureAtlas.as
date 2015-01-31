package
{
	import flash.utils.Dictionary;
	
	import starling.textures.Texture;
	import starling.textures.TextureAtlas;
	
	/**
	 * 处理UI素材
	 **/
	public class UITextureAtlas
	{
		/**纹理Atlas ID*/
		public static var resAtlasNode:Array = [];
		
		private static var dict:Dictionary = new Dictionary();
		
		public function UITextureAtlas()
		{
		}
		
		public static function addNode(node:AtlasRes):void
		{
			if(!(node.id in dict))
			{
				dict[node.id] = node;
				resAtlasNode.push(node);
			}
		}
		
		public static function addTextureAtlas(id:String,atlas:TextureAtlas):void
		{
			dict[id].atlas = atlas;
		}
		
		private static var texId:String = null;
		private static var atlId:String = null;
		private static var atlas:TextureAtlas = null;
		/**
		 * 拆解URL，获取指定ID的纹理
		 **/
		public static function getTexture(url:String):Texture
		{
			var attrs:Array = url.split(".");
			var res:AtlasRes = null;
			if(attrs.length >= 2)
			{
				texId = attrs.pop();
				atlId = attrs.pop();
				
				if(atlId in dict)
				{
					res = dict[atlId];
					if(res.atlas)
					{
						return res.atlas.getTexture(texId);
					}
				}
			}
			return null;
		}
		
		public static function disposeTextureAtlas(id:String):void
		{
			if(id in dict)
			{
				var node:AtlasRes = dict[id];
				var idx:int = resAtlasNode.indexOf(node);
				if(idx >= 0)
				{
					resAtlasNode.splice(idx,1);
				}
				delete dict[id];
				
				if(node.atlas)
				{
					node.atlas.dispose();
					node.atlas = null;
				}
			}
		}
		
		public static function contains(id:String):Boolean
		{
			return (id in dict && dict[id].atlas);
		}
	}
}