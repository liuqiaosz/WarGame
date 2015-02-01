package extension.asset
{
	import flash.utils.ByteArray;

	/**
	 * 扩展资源
	 **/
	public class AtlasPackage
	{
		public var xml:ByteArray = null;
		public var tex:ByteArray = null;
		public function AtlasPackage(data:ByteArray)
		{
			if(!AtlasPackage.isAtlasPack(data))
			{
				throw new Error("Invalid AtlasPackage");
			}
			
			//跳过3位标识
			data.readUTFBytes(3);
			var xmlLength:int = data.readUnsignedInt();
			xml = new ByteArray();
			data.readBytes(xml,0,xmlLength);
			tex = new ByteArray();
			data.readBytes(tex,0);
		}
		
		public static function isAtlasPack(bytes:ByteArray):Boolean
		{
			if (bytes.length < 3) return false;
			else
			{
				var signature:String = String.fromCharCode(bytes[0], bytes[1], bytes[2]);
				return signature == "TAP";
			}
		}
		
		
	}
}