package com.model.business.gameService.serverMessageManager.dataManager
{
	import flash.utils.ByteArray;

	/**
	 * 数据管理者接口<br>用于接收数据
	 * @author Administrator
	 */	
	public interface IDataManager
	{
		/**重写实现时需要调用父类方法*/
		function resolveData(proc:int, data:ByteArray):void;
	}
}