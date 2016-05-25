package com.view.gameWindow.panel.panels.onhook.states.common
{
	import com.model.configData.ConfigDataManager;
	import com.model.configData.cfgdata.NpcCfgData;
	import com.view.gameWindow.mainUi.MainUiMediator;
	import com.view.gameWindow.panel.PanelConst;
	import com.view.gameWindow.panel.PanelMediator;
	import com.view.gameWindow.panel.panelbase.IPanelBase;
	import com.view.gameWindow.panel.panels.task.npcfunc.NpcFuncItem;
	import com.view.gameWindow.panel.panels.task.npcfunc.NpcFuncs;
	import com.view.gameWindow.panel.panels.task.npctask.NpcTaskPanelData;
	import com.view.gameWindow.scene.entity.EntityLayerManager;
	import com.view.gameWindow.scene.entity.entityItem.interf.IFirstPlayer;
	import com.view.gameWindow.scene.entity.entityItem.interf.INpcStatic;
	
	/**
	 * ui
	 * @author wqhk
	 * 2014-10-8
	 */
	public class AuFuncs
	{
		/**
		 * 界面显示/隐藏战斗标志
		 */
		public static function showFightEffect(value:Boolean):void
		{
			if(!MainUiMediator.getInstance().autoSign)
			{
				return;
			}
			if(value)
			{
				MainUiMediator.getInstance().autoSign.showFightEffect();
			}
			else
			{
				MainUiMediator.getInstance().autoSign.hideFightEffect();
			}
		}
		
		/**
		 * 界面显示/隐藏移动标志
		 */
		public static function showMoveEffect(value:Boolean):void
		{
			if(!MainUiMediator.getInstance().autoSign)
			{
				return;
			}
			
			if(value)
			{
				MainUiMediator.getInstance().autoSign.showFindPathEffect();
			}
			else
			{
				MainUiMediator.getInstance().autoSign.hideFindPathEffect();
			}
		}
		
		public static function openNpcPanle(staticNpc:INpcStatic):void
		{
			var mediator:PanelMediator = PanelMediator.instance;
			var isShowTaskPanel:Boolean = true;
			var panel:IPanelBase = mediator.openedPanel(PanelConst.TYPE_TASK_ACCEPT_COMPLETE);
			var firstPlayer:IFirstPlayer = EntityLayerManager.getInstance().firstPlayer
			if(panel && NpcTaskPanelData.npcId == staticNpc.entityId)
			{
				isShowTaskPanel = false;
			}
			if (isShowTaskPanel)
			{
				var npcConfig:NpcCfgData = ConfigDataManager.instance.npcCfgData(staticNpc.entityId);
				var npcFuncs:NpcFuncs = new NpcFuncs();
				var allTasks:Vector.<NpcFuncItem> = npcFuncs.getAllTasks(staticNpc.entityId);
				if(allTasks.length)
				{
					npcFuncs.clickFunc(allTasks,staticNpc,firstPlayer);
				}
				else
				{
					var items:Vector.<NpcFuncItem> = npcFuncs.getFuncItems(npcConfig.func, npcConfig.func_extra, staticNpc.entityId);
					if(items.length > 0)
					{
						npcFuncs.clickFunc(items,staticNpc,firstPlayer);
					}
					else
					{
						npcFuncs.openStaticNpcPanel(staticNpc);
					}
				}
			}
		}
	}
}