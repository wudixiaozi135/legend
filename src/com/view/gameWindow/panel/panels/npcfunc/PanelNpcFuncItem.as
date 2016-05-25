package com.view.gameWindow.panel.panels.npcfunc
{
	import com.model.configData.ConfigDataManager;
	import com.view.gameWindow.panel.PanelConst;
	import com.view.gameWindow.panel.PanelMediator;
	import com.view.gameWindow.panel.panels.task.TaskDataManager;
	import com.view.gameWindow.panel.panels.task.npcfunc.NpcFuncs;
	import com.view.gameWindow.panel.panels.taskStar.data.PanelTaskStarDataManager;
	
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.utils.Dictionary;

	public class PanelNpcFuncItem extends Sprite
	{
		private var _mc:McNpcFuncPanel;
		private var _txt:TextField;
		private var _func:int;
		
		public function PanelNpcFuncItem(mc:McNpcFuncPanel)
		{
			_mc = mc;
			_txt = cloneTxt();
			addChild(_txt);
			buttonMode = true;
		}
		
		private function cloneTxt():TextField
		{
			var textField:TextField = new TextField();
			var defaultTextFormat:TextFormat = _mc.txtFunc.defaultTextFormat;
			textField.defaultTextFormat = defaultTextFormat;
			textField.setTextFormat(defaultTextFormat);
			textField.width = _mc.txtFunc.width;
			textField.height = _mc.txtFunc.height;
			textField.multiline = false;
			textField.selectable = false;
			textField.x = _mc.txtFunc.x;
			return textField;
		}
		
		public function destory():void
		{
			_mc = null;
			_txt = null;
		}
		
		public function get txt():TextField
		{
			return _txt;
		}

		public function set func(value:int):void
		{
			_func = value;
		}
		
		public function onClick():void
		{
			switch(_func)
			{
				case NpcFuncs.NF_SHOP:
					var npcShopCfgDatas:Dictionary = ConfigDataManager.instance.npcShopCfgDatas(PanelNpcFuncData.npcId);
					if(!npcShopCfgDatas)
					{
						trace("PanelNpcFuncItem.onClick 该NPC对应的商店配置不存在");
						return;
					}
					PanelMediator.instance.openPanel(PanelConst.TYPE_NPC_SHOP);
					PanelMediator.instance.openPanel(PanelConst.TYPE_BAG);
					break;
				case NpcFuncs.NF_AIRPORT:
					var npcTeleportCfgData:Dictionary = ConfigDataManager.instance.npcTeleportCfgDatas(PanelNpcFuncData.npcId);
					if(!npcTeleportCfgData)
					{
						trace("PanelNpcFuncItem.onClick 该NPC对应的传送配置不存在");
						return;
					}
					PanelMediator.instance.switchPanel(PanelConst.TYPE_TRANS);
					break;
				case NpcFuncs.NF_DUNGEON:
					var dungeonCfgData:Dictionary = ConfigDataManager.instance.dungeonCfgData(PanelNpcFuncData.npcId);
					if(!dungeonCfgData)
					{
						trace("PanelNpcFuncItem.onClick 该NPC对应的副本配置不存在");
						return;
					}
					PanelMediator.instance.switchPanel(PanelConst.TYPE_DUNGEON);
					break;
				case NpcFuncs.NF_RECYCLE:
					break;
				case NpcFuncs.NF_FORGING:
					break;
				case NpcFuncs.NF_STAR_TASK:
					var taskCfgDatas:Dictionary = ConfigDataManager.instance.taskCfgDatas(PanelNpcFuncData.npcId);
					if(!taskCfgDatas)
					{
						trace("PanelNpcFuncItem.onClick 该NPC对应的星级任务配置不存在");
						return;
					}
					PanelTaskStarDataManager.instance.request();
					PanelTaskStarDataManager.instance.callBack = function ():void
					{
						PanelMediator.instance.switchPanel(PanelConst.TYPE_TASK_STAR);
//						var isComplete:Boolean = PanelTaskStarDataManager.instance.isComplete;
//						if(isComplete)
//						{
//							PanelMediator.instance.switchPanel(PanelConst.TYPE_TASK_STAR_OVER);
//						}
//						else
//						{
//							PanelMediator.instance.switchPanel(PanelConst.TYPE_TASK_STAR);
//						}
					};
					break;
				case NpcFuncs.NF_YABIAO:
					TaskDataManager.instance.submitTask(PanelNpcFuncData.items[0].taskId);
					break;
				case NpcFuncs.NF_ESCORTS:
					break;
				case NpcFuncs.NF_STORAGE:		
					
					break;
			}
		}
	}
}