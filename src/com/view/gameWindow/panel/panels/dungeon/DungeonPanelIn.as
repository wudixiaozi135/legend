package com.view.gameWindow.panel.panels.dungeon
{
	import com.model.configData.ConfigDataManager;
	import com.model.configData.cfgdata.DungeonCfgData;
	import com.model.consts.SlotType;
	import com.model.consts.StringConst;
	import com.model.consts.ToolTipConst;
	import com.view.gameWindow.panel.PanelConst;
	import com.view.gameWindow.panel.PanelMediator;
	import com.view.gameWindow.panel.panelbase.PanelBase;
	import com.view.gameWindow.panel.panels.bag.BagDataManager;
	import com.view.gameWindow.panel.panels.hero.HeroDataManager;
	import com.view.gameWindow.panel.panels.npcfunc.PanelNpcFuncData;
	import com.view.gameWindow.panel.panels.roleProperty.RoleDataManager;
	import com.view.gameWindow.tips.toolTip.TipVO;
	import com.view.gameWindow.tips.toolTip.ToolTipManager;
	import com.view.gameWindow.util.HtmlUtils;
	import com.view.gameWindow.util.UtilNumChange;
	
	import flash.display.MovieClip;
	import flash.text.TextField;
	
	public class DungeonPanelIn extends PanelBase implements IDungeonPanelIn
	{
		private var _dungeonCfgData:DungeonCfgData; 
		private var mcDungeon:McDungeonPanel
		
		private var _mouseEvent:DungeonPanelInMouseEvent;
		private var vectorCell:Vector.<MovieClip>;
		public function DungeonPanelIn()
		{
			super();
		}
		
		override protected function initSkin():void
		{
			_mouseEvent = new DungeonPanelInMouseEvent();
			_skin = new McDungeonPanel();
			addChild(_skin);
			mcDungeon = _skin as McDungeonPanel;
			initText();
			setTitleBar(mcDungeon.dragBox);
			_mouseEvent.addEvent(mcDungeon);
		}
		
		private function initText():void
		{
			var npc:int = PanelNpcFuncData.npcId;
			var dungeonPanel:DungeonPanel = PanelMediator.instance.openedPanel(PanelConst.TYPE_DUNGEON) as DungeonPanel;
			var id:int = DungeonGlobals.dungeonId ? DungeonGlobals.dungeonId : dungeonPanel.id;
			var count:int;
			_dungeonCfgData = ConfigDataManager.instance.dungeonCfgDataId(id)//dic[id];
			TextFormatManager.instance.setTextFormat(mcDungeon.title,mcDungeon.title.textColor,false,true);
			if(DgnDataManager.instance.getDgnDt(id))
			{
				count = DgnDataManager.instance.getDgnDt(id).daily_enter_count;
			}
			else
			{
				count = 0;
			}
			mcDungeon.title.text = StringConst.DUNGEON_PANEL_0011;
			mcDungeon.txt_01.text = _dungeonCfgData.name;
			mcDungeon.txt_02.text = StringConst.DUNGEON_PANEL_0002;
			mcDungeon.txt_03.text = StringConst.DUNGEON_PANEL_0030;
			mcDungeon.txt_04.text = StringConst.DUNGEON_PANEL_0001;
			mcDungeon.txt_07.htmlText = "<u>" + StringConst.DUNGEON_PANEL_0009 + _dungeonCfgData.name + "</u>";
			mcDungeon.txt_08.htmlText = "<u>" + StringConst.DUNGEON_PANEL_0010 + "</u>";
			if(getCoin(_dungeonCfgData as DungeonCfgData) != "")
			{
				mcDungeon.txt_09.text = "(" + StringConst.DUNGEON_PANEL_0017 + getCoin(_dungeonCfgData as DungeonCfgData) + ")";
			}
			mcDungeon.txt_10.text = String(_dungeonCfgData.duration/60) + StringConst.DUNGEON_PANEL_0003;
			
			var countTotal:int = _dungeonCfgData.free_count+_dungeonCfgData.toll_count;
			mcDungeon.txt_12.text = "(" + String(count > countTotal ?  countTotal : count) + "/" + countTotal + ")";
			mcDungeon.txt_13.text = "[" + _dungeonCfgData.reincarn + StringConst.DUNGEON_PANEL_0031 + "]" + _dungeonCfgData.level + StringConst.DUNGEON_PANEL_0028;
			mcDungeon.txt_14.text = StringConst.DUNGEON_PANEL_0022;
			//
			if(_dungeonCfgData && _dungeonCfgData.itemCfgData)
			{
				var string:String = StringConst.GOD_DEVIL_0002 + _dungeonCfgData.itemCfgData.name + StringConst.COLON;
				string += HtmlUtils.createHtmlStr(0x00ff00,_dungeonCfgData.item_count+StringConst.GOD_DEVIL_0003);
				count = BagDataManager.instance.getItemNumById(_dungeonCfgData.item);
				count += HeroDataManager.instance.getItemNumById(_dungeonCfgData.item);
				string += StringConst.GOD_DEVIL_0004.replace("&x",HtmlUtils.createHtmlStr(0x00ff00,count+""));
				skin.txtCost.htmlText = string;
			}
		}
		
		override public function update(proc:int=0):void
		{
			var rewardStr:String;
			var rewardStrArr:Array;
			var str:String;
			var rewardCell:Array = [];
			var dungeonData:DungeonData;
			var dungeonRewardCell:DungeonRewardCell;
			var strArr:Array = [];
			var tipVO:TipVO ;
			var numChange:UtilNumChange = new UtilNumChange();
			var vectorCount:Vector.<TextField> = Vector.<TextField>([mcDungeon.count_00,mcDungeon.count_01,mcDungeon.count_02,mcDungeon.count_03,mcDungeon.count_04,mcDungeon.count_05,mcDungeon.count_06,mcDungeon.count_07,mcDungeon.count_08,mcDungeon.count_09,mcDungeon.count_10,mcDungeon.count_11]);
			vectorCell = Vector.<MovieClip>([mcDungeon.icon_00,mcDungeon.icon_01,mcDungeon.icon_02,mcDungeon.icon_03,mcDungeon.icon_04,mcDungeon.icon_05,mcDungeon.icon_06,mcDungeon.icon_07,mcDungeon.icon_08,mcDungeon.icon_09,mcDungeon.icon_10,mcDungeon.icon_11]);
			
			rewardStr = _dungeonCfgData.finally_reward;
			rewardStrArr = rewardStr.split("|");
			for each(str in rewardStrArr)
			{
				strArr= str.split(":");
				dungeonData = new DungeonData();
				dungeonData.type = strArr[1];
				dungeonData.id = strArr[0];
				dungeonData.count = strArr[2];
				if(dungeonData.type == SlotType.IT_EQUIP)
				{
					if(ConfigDataManager.instance.equipCfgData(dungeonData.id).sex == 0 || RoleDataManager.instance.sex == ConfigDataManager.instance.equipCfgData(dungeonData.id).sex)
					{
						if(ConfigDataManager.instance.equipCfgData(dungeonData.id).job == 0 || RoleDataManager.instance.job == ConfigDataManager.instance.equipCfgData(dungeonData.id).job)
						{
							rewardCell.push(dungeonData);	
						}
					}
				}
				else
				{
					rewardCell.push(dungeonData);
				}
			}
			for(var i:int = 0;i<(rewardCell.length>12?12:rewardCell.length);i++)
			{
				tipVO = new TipVO();
				dungeonRewardCell = new DungeonRewardCell();
				dungeonRewardCell.loadIcon(vectorCell[i],rewardCell[i].id,rewardCell[i].type);
				dungeonRewardCell.loadEffect(vectorCell[i],rewardCell[i].id,rewardCell[i].type);
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
				if(rewardCell[i].count != 1)
				{
					vectorCount[i].text = String(rewardCell[i].count);
				}
				vectorCount[i].mouseEnabled = false;
			}
			
			if(rewardCell.length < vectorCell.length)
			{
				for(var k:int = rewardCell.length;k<vectorCell.length;k++)
				{
					if(k < 10)
					{
						mcDungeon.getChildByName("cell_0" + String(k)).visible = false;
					}
					else
					{
						mcDungeon.getChildByName("cell_" + String(k)).visible = false;
					}
					
				}
			}
			/*vectorCount = Vector.<TextField>([mcDungeon.count_00,mcDungeon.count_01,mcDungeon.count_02,mcDungeon.count_03,mcDungeon.count_04]);
			vectorCell = Vector.<MovieClip>([mcDungeon.icon_00,mcDungeon.icon_01,mcDungeon.icon_02,mcDungeon.icon_03,mcDungeon.icon_04]);*/
			
			if(!ConfigDataManager.instance.dungeonRewardEvaluateDict(_dungeonCfgData.id))
			{
				return;
			}
			rewardStr = ConfigDataManager.instance.dungeonRewardEvaluateCfgData(_dungeonCfgData.id,5).item;
			rewardStrArr = rewardStr.split("|");
			rewardCell = [];
			strArr = [];
			if(ConfigDataManager.instance.dungeonRewardEvaluateCfgData(_dungeonCfgData.id,5).exp)
			{
				dungeonData = new DungeonData();
				dungeonData.type = 1;
				dungeonData.id = 1;
				dungeonData.count = ConfigDataManager.instance.dungeonRewardEvaluateCfgData(_dungeonCfgData.id,5).exp;
				rewardCell.push(dungeonData);
			}
			if(ConfigDataManager.instance.dungeonRewardEvaluateCfgData(_dungeonCfgData.id,5).bind_coin)
			{
				dungeonData = new DungeonData();
				dungeonData.type = 1;
				dungeonData.id = 3;
				dungeonData.count = ConfigDataManager.instance.dungeonRewardEvaluateCfgData(_dungeonCfgData.id,5).bind_coin;
				rewardCell.push(dungeonData);
			}
			for each(str in rewardStrArr)
			{
				strArr= str.split(":");
				dungeonData = new DungeonData();
				dungeonData.type = strArr[1];
				dungeonData.id = strArr[0];
				dungeonData.count = strArr[2];
				rewardCell.push(dungeonData);
			}
			/*for(var j:int = 0;j<(rewardCell.length>5?5:rewardCell.length);j++)
			{
				tipVO = new TipVO();
				dungeonRewardCell = new DungeonRewardCell();
				dungeonRewardCell.loadIcon(vectorCell[j],rewardCell[j].id,rewardCell[j].type);
				dungeonRewardCell.loadEffect(vectorCell[j],rewardCell[j].id,rewardCell[j].type);
				if(rewardCell[j].type == ToolTipConst.EQUIP_BASE_TIP)
				{
					tipVO.tipType = ToolTipConst.EQUIP_BASE_TIP;
					tipVO.tipData = ConfigDataManager.instance.equipCfgData(rewardCell[j].id);
				}
				else if(rewardCell[j].type == ToolTipConst.ITEM_BASE_TIP)
				{
					tipVO.tipType = ToolTipConst.ITEM_BASE_TIP;
					tipVO.tipData = ConfigDataManager.instance.itemCfgData(rewardCell[j].id);
					tipVO.tipCount = rewardCell[j].count;
				}
				ToolTipManager.getInstance().hashTipInfo(vectorCell[j],tipVO);
				ToolTipManager.getInstance().attach(vectorCell[j]);
				vectorCount[j].text = numChange.changeNum(rewardCell[j].count);
				vectorCount[j].mouseEnabled = false;
			}
			if(rewardCell.length < vectorCell.length)
			{
				for(var l:int = rewardCell.length;l<vectorCell.length;l++)
				{
					mcDungeon.getChildByName("cell_0" + String(l)).visible = false;
				}
			}*/
		}
		
		private function getCoin(dungeonCfgData:DungeonCfgData):String
		{
			if(dungeonCfgData.coin != 0)
			{
				return dungeonCfgData.coin + StringConst.DUNGEON_PANEL_0018;
			}
			if(dungeonCfgData.unbind_coin != 0)
			{
				return dungeonCfgData.unbind_coin + StringConst.DUNGEON_PANEL_0019;
			}
			if(dungeonCfgData.bind_gold != 0)
			{
				return dungeonCfgData.bind_gold + StringConst.DUNGEON_PANEL_0020;
			}
			if(dungeonCfgData.unbind_gold != 0)
			{
				return dungeonCfgData.unbind_gold + StringConst.DUNGEON_PANEL_0021;
			}
			return "";
		}
		
		override public function destroy():void
		{
			_dungeonCfgData = null;
			mcDungeon = null;
			if(_mouseEvent)
			{
				_mouseEvent.destoryEvent();
				_mouseEvent = null;
			}
			for each(var mc:MovieClip in vectorCell)
			{
				ToolTipManager.getInstance().detach(mc);
			}
			vectorCell = null;
			super.destroy();
		}
	}
}