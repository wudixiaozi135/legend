package com.model.business.fileService
{
	import flash.display.BitmapData;
	import flash.utils.Dictionary;
	import flash.utils.getTimer;

	/**
	 * 
	 * 这个类是用来管理客户端加载的位图数据的管理类，作用是缓存bitmapdata数据
	 * 目前只在物品掉落的图片测试使用
	 */
	public class GameBitmapDataManager
	{
		private var bitmapDic:Dictionary;
		private var gc:Vector.<String>;
		private var endTime:int;
		public function GameBitmapDataManager()
		{
			bitmapDic=new Dictionary();
			gc=new Vector.<String>();
		}
		
		private static var _instance:GameBitmapDataManager;
		private const gcMax:uint=20;
		
		public static function getInstance():GameBitmapDataManager
		{
			if(_instance==null)
			{
				_instance=new GameBitmapDataManager();
			}
			return _instance;
		}
		
		/**
		 * 获取缓存的位图
		 * @param type 该参数暂时无效
		 */
		public function getSignleBitMapData(url:String,type:int=0):BitmapData
		{
			if(bitmapDic[url]!=null)
			{
				var bitmap:BitmapData=bitmapDic[url] as BitmapData
				return bitmap.clone();
			}
			return null;
		}
		
		public function addSignleBitMapData(url:String, bitmapData:BitmapData,type:int=0):void
		{
			if(gc.indexOf(url)==-1)
			{
				gc.push(url);
			}
			if(bitmapDic[url]==null)
			{
				bitmapDic[url]=bitmapData.clone();
			}
			var nowTime:int = getTimer();
			if(nowTime-endTime>1000*60)
			{
				checkGC();
				endTime=nowTime;
			}
		}
		
		private function checkGC():void
		{
			while(gc.length>gcMax)
			{
				var gcStr:String = gc.shift();
				var gcMap:BitmapData= bitmapDic[gcStr] as BitmapData;
				if(gcMap!=null)
				{
					gcMap.dispose();
				}
				delete bitmapDic[gcStr];
			}	
		}
	}
}