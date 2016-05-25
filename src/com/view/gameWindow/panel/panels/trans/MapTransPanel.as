package com.view.gameWindow.panel.panels.trans
{
	import com.model.business.gameService.constants.GameServiceConstants;
	import com.model.configData.ConfigDataManager;
	import com.model.configData.cfgdata.MapCfgData;
	import com.model.configData.cfgdata.MapRegionCfgData;
	import com.model.configData.cfgdata.NpcTeleportCfgData;
	import com.model.consts.SlotType;
	import com.model.consts.StringConst;
	import com.model.consts.ToolTipConst;
	import com.model.dataManager.TeleportDatamanager;
	import com.view.gameWindow.panel.panelbase.PanelBase;
	import com.view.gameWindow.panel.panels.dungeon.DungeonRewardCell;
	import com.view.gameWindow.panel.panels.guideSystem.InterObjCollector;
	import com.view.gameWindow.panel.panels.roleProperty.RoleDataManager;
	import com.view.gameWindow.tips.toolTip.TipVO;
	import com.view.gameWindow.tips.toolTip.ToolTipManager;
	import com.view.gameWindow.util.propertyParse.CfgDataParse;
	
	import flash.display.MovieClip;
	import flash.geom.Point;
	import flash.text.TextField;
	
	import mx.utils.StringUtil;
	
	public class MapTransPanel extends PanelBase
	{
		private var _mouseEvent:MapTransPanelMouseEvent;
		private var mapTranPanel:McMapTransPanel;
		private var rewardStrArr:Array = [];
		private var cellNum:int;

		private var rewardCell:Array;

		private var vectorCell:Vector.<MovieClip>;
		private var rewardCellVec:Vector.<DungeonRewardCell>;
		
		public function MapTransPanel()
		{
			super();
			TeleportDatamanager.instance.attach(this);
		}
		
		override protected function initSkin():void
		{
			_skin = new McMapTransPanel();
			addChild(_skin);
			mapTranPanel = _skin as McMapTransPanel;
			_mouseEvent = new MapTransPanelMouseEvent();
			_mouseEvent.addEvent(mapTranPanel);
			setTitleBar(mapTranPanel.dragBox);
			cellNum = 12;
		}
		
		override protected function initData():void
		{
			var npcTeleportCfg:NpcTeleportCfgData = ConfigDataManager.instance.npcTeleportCfgData(PanelTransData.npcTeleportId);
			var mapRegionCfg:MapRegionCfgData = ConfigDataManager.instance.mapRegionCfgData(npcTeleportCfg.region_to);
			var mapCfg:MapCfgData =  ConfigDataManager.instance.mapCfgData(mapRegionCfg.map_id);
			mapTranPanel.txt_00.htmlText =  CfgDataParse.pareseDesToStr(PanelTransData.desc);
			mapTranPanel.txt_05.text = StringConst.TRANS_PANEL_0015;
			mapTranPanel.txt_06.htmlText = StringUtil.substitute(StringConst.TRANS_PANEL_0027,mapCfg.name);
			//
			InterObjCollector.instance.add(mapTranPanel.txt_06,"",new Point(2,2));
			InterObjCollector.autoCollector.add(mapTranPanel.txt_06,"",new Point(2,2));
			
			mapTranPanel.txt_6.text = PanelTransData.coin?PanelTransData.coin:"";
			mapTranPanel.txt_6.appendText(ConfigDataManager.instance.itemCfgData(npcTeleportCfg.item)? "(" + StringConst.TRANS_PANEL_0033 + 
				ConfigDataManager.instance.itemCfgData(npcTeleportCfg.item).name + "*" + npcTeleportCfg.item_count +")":"");
			mapTranPanel.txt_0.text = StringConst.TRANS_PANEL_0023;
			mapTranPanel.txt_1.text = StringConst.TRANS_PANEL_0028.replace("X",mapCfg.reincarn).replace("XX",mapCfg.level);
			mapTranPanel.txt_5.text = StringConst.TRANS_PANEL_0026;
			
			var rewardStr:String;
			var str:String;
			rewardCell = [];
			rewardCellVec = new Vector.<DungeonRewardCell>();
			var RewardCell:DungeonRewardCell;
			var rewardData:ReawardData;
			var tipVO:TipVO;
			vectorCell = Vector.<MovieClip>([mapTranPanel.icon_00,mapTranPanel.icon_01,mapTranPanel.icon_02,mapTranPanel.icon_03,mapTranPanel.icon_04,mapTranPanel.icon_05,
				mapTranPanel.icon_06,mapTranPanel.icon_07,mapTranPanel.icon_08,mapTranPanel.icon_09,mapTranPanel.icon_10,mapTranPanel.icon_11]);
			var vectorCount:Vector.<TextField> = Vector.<TextField>([mapTranPanel.count_00,mapTranPanel.count_01,mapTranPanel.count_02,mapTranPanel.count_03,mapTranPanel.count_04,mapTranPanel.count_05,
				mapTranPanel.count_06,mapTranPanel.count_07,mapTranPanel.count_08,mapTranPanel.count_09,mapTranPanel.count_10,mapTranPanel.count_11]);
			rewardStr = PanelTransData.boss_drop;
			rewardStrArr = rewardStr.split("|");
			for each(str in rewardStrArr)
			{
				var strArr:Array = str.split(":");
				rewardData = new ReawardData();
				rewardData.type = strArr[1];
				rewardData.id = strArr[0];
				rewardData.count = strArr[2];
				if(rewardData.type == SlotType.IT_EQUIP)
				{
					if(ConfigDataManager.instance.equipCfgData(rewardData.id).sex == 0 || RoleDataManager.instance.sex == ConfigDataManager.instance.equipCfgData(rewardData.id).sex)
					{
						if(ConfigDataManager.instance.equipCfgData(rewardData.id).job == 0 || RoleDataManager.instance.job == ConfigDataManager.instance.equipCfgData(rewardData.id).job)
						{
							rewardCell.push(rewardData);	
						}
					}
				}
				else
				{
					rewardCell.push(rewardData);
				}
			}
			for(var i:int = 0;i<(rewardCell.length>cellNum?cellNum:rewardCell.length);i++)
			{
				tipVO = new TipVO();
				RewardCell = new DungeonRewardCell();
				RewardCell.loadIcon(vectorCell[i],rewardCell[i].id,rewardCell[i].type);	
				RewardCell.loadEffect(vectorCell[i],rewardCell[i].id,rewardCell[i].type);
				rewardCellVec.push(RewardCell);
				if(rewardCell[i].type == ToolTipConst.EQUIP_BASE_TIP)
				{
					tipVO.tipType = ToolTipConst.EQUIP_BASE_TIP;
					tipVO.tipData = ConfigDataManager.instance.equipCfgData(rewardCell[i].id);
				}
				else if(rewardCell[i].type == ToolTipConst.ITEM_BASE_TIP)
				{
					tipVO.tipType = ToolTipConst.ITEM_BASE_TIP;
					tipVO.tipData = ConfigDataManager.instance.itemCfgData(rewardCell[i].id);
					tipVO.tipCount = rewardCell[i].count;
				}
				ToolTipManager.getInstance().hashTipInfo(vectorCell[i],tipVO);
				ToolTipManager.getInstance().attach(vectorCell[i]);
				if(rewardCell[i].count > 1)
				{
					vectorCount[i].text = String(rewardCell[i].count);
				}
			}
			if(rewardCell.length < vectorCell.length)
			{
				for(var l:int = rewardCell.length;l<vectorCell.length;l++)
				{
					mapTranPanel.getChildByName("cell_" + String(l)).visible = false;
				}
			}
		}
		
		override public function update(proc:int=0):void
		{	
			if(proc == GameServiceConstants.CM_NPC_TELEPORT)
			{
			}
		}
		
		override public function destroy():void
		{
			InterObjCollector.instance.remove(mapTranPanel.txt_06);
			InterObjCollector.autoCollector.remove(mapTranPanel.txt_06);
			
			TeleportDatamanager.instance.detach(this);
			for(var i:int = 0;i<(rewardCell.length>cellNum?cellNum:rewardCell.length);i++)
			{
				rewardCellVec[i].destroyEffect();
				ToolTipManager.getInstance().attach(vectorCell[i]);
			}
			if(_mouseEvent)
			{
				_mouseEvent.destoryEvent();
				_mouseEvent = null;
			}
			rewardCell = null;
			vectorCell = null;
			rewardCellVec = null;
			mapTranPanel = null;
			rewardStrArr = null;
			super.destroy();
		}
		
	}
}