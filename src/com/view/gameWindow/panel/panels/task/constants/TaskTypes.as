package com.view.gameWindow.panel.panels.task.constants
{
	import com.model.consts.StringConst;

	public class TaskTypes
	{
		public static const TT_MAIN:int = 1;//主线任务
		public static const TT_ROOTLE:int = 2;//挖掘任务
		public static const TT_MINING:int = 3;//采矿任务
		public static const TT_EXORCISM:int = 4;//除魔任务
		public static const TT_REWARD:int = 5;//悬赏任务
		public static const TT_INSTRUCTION:int = 6;//押镖任务
		
		public static const TT_TOWNER:int = 7;//塔防 只是显示用
		public static const TT_DGN:int = 8;//副本 只是显示用
		
		public static function isTypeStar(type:int):Boolean
		{
			return type == TT_ROOTLE || type == TT_MINING || type == TT_EXORCISM;
		}
		
		public static function isTypeMain(type:int):Boolean
		{
			return type == TT_MAIN;
		}
		
		public static function isTypeReward(type:int):Boolean
		{
			return type == TT_REWARD;
		}
		
		public static function taskTitleName(type:int):String
		{
			var name:String;
			switch(type)
			{
				case TT_MAIN:
					name = StringConst.TASK_0001+StringConst.TASK_0015;
					break;
				case TT_ROOTLE:
					name = StringConst.TASK_0002+StringConst.TASK_0015;
					break;
				case TT_MINING:
					name = StringConst.TASK_0003+StringConst.TASK_0015;
					break;
				case TT_EXORCISM:
					name = StringConst.TASK_0004+StringConst.TASK_0015;
					break;
				case TT_REWARD:
					name = StringConst.TASK_0005+StringConst.TASK_0015;
					break;
				default:
					break;
			}
			return name;
		}
	}
}