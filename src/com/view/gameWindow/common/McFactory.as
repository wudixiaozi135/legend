package com.view.gameWindow.common
{
	import com.core.ClassFactory;
	import com.model.gameWindow.rsr.RsrLoader;
	
	import flash.display.MovieClip;
	import flash.utils.Dictionary;
	
	/**
	 * load.addCallBack(mc[name],callbacks[name]); 只处理了一层，mc[name0][name1]就不行
	 * 
	 * @author wqhk
	 * 2014-9-18
	 */
	public class McFactory
	{
		public var factory:ClassFactory
		
		public var properties:Object = null;
		
		public var prefixUrl:String;
		
		/**
		 * {propertyName:callback,...}
		 */
		public var callbacks:Object = null;
		
		public function McFactory(generator:Class)
		{
			factory = new ClassFactory(generator);
		}
		
		public function create():MovieClip
		{
			factory.properties = properties;
			
			var mc:MovieClip = factory.newInstance() as MovieClip;
			
			var load:RsrLoader = new RsrLoader();
			
			if(callbacks)
			{
				for(var name:String in callbacks)
				{
					load.addCallBack(mc[name],callbacks[name]);
				}
			}
			
			load.load(mc,prefixUrl);
			
			return mc;
		}
		
	}
}