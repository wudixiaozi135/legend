package com.view.gameWindow.panel.panels.task.npcfunc
{
	import com.model.business.fileService.UrlBitmapDataLoader;
	
	import flash.display.Bitmap;
	import flash.text.TextField;
	
	public class NpcFuncItem
	{
		private var _func:int;
		private var _funcExtra:int;
		private var _subFunc:int;
		private var _npcId:int;
		private var _taskType:int;
		private var _taskId:int;
		private var _stepParam:int;
		private var _iCycle:int;
		private var _iTime:int;
		private var _cycleTaskType:int;
		public var parm:String;
		
		private var _bitmapDataLoader:UrlBitmapDataLoader;
		private var _textField:TextField;
		private var _icon:Bitmap;
		

		public function init(func:int, npcId:int, taskType:int = 0, taskId:int = 0, step:int = 0, stepParam:int = 0, iCycle:int = 0, iTime:int = 0, cycleTaskType:int = 0):void
		{
			_func = func;
			_npcId = npcId;
			_taskType = taskType;
			_taskId = taskId;
			_stepParam = stepParam;
			_iCycle = iCycle;
			_iTime = iTime;
			_cycleTaskType = cycleTaskType;
		}
		
		public function get taskId():int
		{
			return _taskId;
		}
		
		public function get stepParam():int
		{
			return _stepParam;
		}
		
		public function set subFunc(value:int):void
		{
			_subFunc = value;
		}		
		public function destroy():void
		{
			
		}
		
		public function get func():int
		{
			return _func;
		}
		
		public function get npcId():int
		{
			return _npcId;
		}
		
		public function get taskType():int
		{
			return _taskType;
		}
	}
}