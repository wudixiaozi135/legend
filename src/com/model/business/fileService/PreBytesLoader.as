package com.model.business.fileService
{
	import flash.utils.ByteArray;
	
	public class PreBytesLoader extends BytesLoader
	{
		public static function load(url:String):void
		{
			var load:PreBytesLoader = new PreBytesLoader();
			load.loadBytes(url);
		}
		
		public function PreBytesLoader()
		{
			super(null);
		}
		
		override public function byteArrayReceive(url:String, byteArray:ByteArray):void
		{
		}
		
		override public function byteArrayProgress(url:String, progress:Number):void
		{
		}
		
		override public function byteArrayError(url:String):void
		{
		}
	}
}