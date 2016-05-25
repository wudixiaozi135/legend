package com.view.gameWindow.panel.panels.hejiSkill.replace
{
	import com.model.configData.ConfigDataManager;
	import com.model.configData.cfgdata.RuneTransformCfgData;
	import com.model.consts.ConstStorage;
	import com.model.consts.SlotType;
	import com.model.consts.StringConst;
	import com.view.gameWindow.panel.PanelConst;
	import com.view.gameWindow.panel.PanelMediator;
	import com.view.gameWindow.panel.panels.bag.BagDataManager;
	import com.view.gameWindow.panel.panels.hejiSkill.HejiSkillDataManager;
	import com.view.gameWindow.panel.panels.hejiSkill.McPanelRunes;
	import com.view.gameWindow.tips.rollTip.RollTipMediator;
	import com.view.gameWindow.tips.rollTip.RollTipType;
	import com.view.gameWindow.tips.toolTip.ToolTipManager;
	import com.view.gameWindow.util.cell.IconCellEx;
	import com.view.gameWindow.util.cell.ThingsData;
	
	import flash.events.MouseEvent;

	public class RePlaceMouseHandler
	{
		private var _panel:McPanelRunes;
		private var _replace:ReplacePanel;
		private var _icon1:IconCellEx;
		private var _icon2:IconCellEx;
		public function RePlaceMouseHandler(replace:ReplacePanel)
		{
			_replace=replace;
			_panel=replace.skin as McPanelRunes;
			initIcon();
			_panel.addEventListener(MouseEvent.CLICK,onClickFunc);
		}
		
		private function initIcon():void
		{
			_icon1=new IconCellEx(_panel,45,67,64,64);
			ToolTipManager.getInstance().attach(_icon1);
			_icon2=new IconCellEx(_panel,226,67,64,64);
			ToolTipManager.getInstance().attach(_icon2);
		}
		
		protected function onClickFunc(event:MouseEvent):void
		{
			// TODO Auto-generated method stub
			var cell:ReplaceBagCell=event.target.parent as ReplaceBagCell;
			if(cell!=null)
			{
				var itemId:int= cell.iconCell.id;
				var dt:ThingsData=new ThingsData();
				if(_icon1.isEmpty())
				{
					dt.id=itemId;
					dt.count=0;
					dt.type=SlotType.IT_ITEM;
					IconCellEx.setItemByThingsData(_icon1,dt);
					HejiSkillDataManager.instance.cellID1=itemId;
					_replace.updateBag();
					HejiSkillDataManager.instance.replaceID=0;
					_replace.runeTransform();
				}else if(_icon2.isEmpty())
				{
					if(itemId!=_icon1.id)
					{
						RollTipMediator.instance.showRollTip(RollTipType.ERROR,StringConst.REPLACE_PANEL_0008);
						return;
					}
					dt.id=itemId;
					dt.count=0;
					dt.type=SlotType.IT_ITEM;
					IconCellEx.setItemByThingsData(_icon2,dt);
					var rune:RuneTransformCfgData= ConfigDataManager.instance.getRuneTransformCfgData(itemId);
					_panel.txt4.text=rune.coin+"";
					HejiSkillDataManager.instance.cellID2=itemId;
					_replace.updateBag();
				}else
				{
					RollTipMediator.instance.showRollTip(RollTipType.ERROR,StringConst.REPLACE_PANEL_0007);
					return;
				}
				return;
			}
			
			switch(event.target)
			{
				case _panel.btnSub:
					replaceRune();
					break;
				case _icon1:
					HejiSkillDataManager.instance.cellID1=0;
					_icon1.setNull();
					_replace.updateBag();
					break;
				case _icon2:
					HejiSkillDataManager.instance.cellID2=0;
					_icon2.setNull();
					_replace.updateBag();
					break;
				case _panel.closeBtn:
					PanelMediator.instance.switchPanel(PanelConst.TYPE_REPLACE);
					break;
			}
		}
		
		private function replaceRune():void
		{
			if(_icon2.isEmpty())
			{
				RollTipMediator.instance.showRollTip(RollTipType.ERROR,StringConst.REPLACE_PANEL_0009);
				return;
			}
			var coin:int=int(_panel.txt4.text);
			if(coin>BagDataManager.instance.coinBind+BagDataManager.instance.coinUnBind)
			{
				RollTipMediator.instance.showRollTip(RollTipType.ERROR,StringConst.ROLE_PROPERTY_PANEL_0077);
				return;
			}
			_panel.txt4.text=0+"";
			HejiSkillDataManager.instance.cellID1=0;
			HejiSkillDataManager.instance.cellID2=0;
			RollTipMediator.instance.showRollTip(RollTipType.SYSTEM,StringConst.REPLACE_PANEL_0010);
			var idv:Vector.<int>=BagDataManager.instance.getItemVectorIntById(_icon2.id);
			HejiSkillDataManager.instance.runeTransform(ConstStorage.ST_CHR_BAG,idv[0],ConstStorage.ST_CHR_BAG,idv[1]);
			_icon1.setNull();
			_icon2.setNull();
		}
		
		public function destroy():void
		{
			if(_icon1)
			{
				ToolTipManager.getInstance().detach(_icon1);
				_icon1.parent&&_icon1.parent.removeChild(_icon1);
				_icon1.destroy();
				_icon1=null;
			}
			if(_icon2)
			{
				ToolTipManager.getInstance().detach(_icon2);
				_icon2.parent&&_icon2.parent.removeChild(_icon2);
				_icon2.destroy();
				_icon2=null;
			}
			_panel.removeEventListener(MouseEvent.CLICK,onClickFunc);
		}
	}
}