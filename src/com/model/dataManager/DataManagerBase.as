package com.model.dataManager
{
	import com.model.business.gameService.serverMessageManager.dataManager.IDataManager;
	import com.pattern.Observer.Observe;
	
	import flash.utils.ByteArray;
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;

	/**
	 * 基础数据管理者类<br>继承自观察者类<br>继承该类时构造函数需要盗用super()，需要重写resolveData，并具有clearInstance静态方法<br>会在clearDataManager方法中将调用clearInstance静态方法把单例对象置空
	 * @author Administrator
	 */	
	public class DataManagerBase extends Observe implements IDataManager
	{
		private static var _dataManagers:Vector.<DataManagerBase>;
		
		public function DataManagerBase()
		{
			DataManagerManager.getInstance().attach(this);
		}
		
		public function resolveData(proc:int, data:ByteArray):void
		{
			notify(proc);
			data&&data.clear();
		}
		
		public function clearDataManager():void
		{
			getDefinitionByName(getQualifiedClassName(this)).clearInstance();
		}
	}
}