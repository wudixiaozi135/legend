package com.view.gameWindow.panel.panels.task
{
	import com.model.configData.ConfigDataManager;
	import com.model.configData.cfgdata.TaskCfgData;
	import com.view.gameWindow.mainUi.subuis.tasktrace.EquipWearItem;
	import com.view.gameWindow.panel.panels.task.linkText.LinkText;

	public class TaskAutoHandoverData
	{
		private static var _link:LinkText;
		private static var _taskId:int;
		
		public function TaskAutoHandoverData()
		{
		}
		
		public static var equipWareLink:EquipWearItem;

		public static function get link():LinkText
		{
			var _link2:LinkText = _link;
			_link = null;
			return _link2;
		}

		public static function set link(value:LinkText):void
		{
			_link = value.clone();
		}

		public static function get taskId():int
		{
			trace("get taskId:"+_taskId);
			var _taskId2:int = _taskId;
			_taskId = 0;
			return _taskId2;
		}

		public static function set taskId(value:int):void
		{
			_taskId = value;
			/*trace("TaskAutoHandoverData.taskId:"+_taskId);*/
		}
		
		public static function hasTask():Boolean
		{
			return (_link || equipWareLink) && _taskId;
		}
		
		public static function taskType():int
		{
			var taskCfgData:TaskCfgData = _taskId ? ConfigDataManager.instance.taskCfgData(_taskId) : null;
			return taskCfgData ? taskCfgData.type : 0;
		}
		
		public static function clear():void
		{
			_taskId = 0;
			_link = null;
		}
	}
}