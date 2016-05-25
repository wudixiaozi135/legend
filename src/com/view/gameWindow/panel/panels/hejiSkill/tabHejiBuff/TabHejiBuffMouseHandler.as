package com.view.gameWindow.panel.panels.hejiSkill.tabHejiBuff
{
	import com.model.configData.ConfigDataManager;
	import com.model.configData.cfgdata.ItemCfgData;
	import com.model.consts.StringConst;
	import com.view.gameWindow.mainUi.subuis.bottombar.actBar.ActionBarData;
	import com.view.gameWindow.mainUi.subuis.bottombar.actBar.ActionBarDataManager;
	import com.view.gameWindow.panel.PanelConst;
	import com.view.gameWindow.panel.PanelMediator;
	import com.view.gameWindow.panel.panels.bag.BagData;
	import com.view.gameWindow.panel.panels.bag.BagDataManager;
	import com.view.gameWindow.panel.panels.forge.ForgeDataManager;
	import com.view.gameWindow.panel.panels.hejiSkill.HejiSkillDataManager;
	import com.view.gameWindow.panel.panels.hejiSkill.McPanelHejiBuff;
	import com.view.gameWindow.panel.panels.skill.SkillData;
	import com.view.gameWindow.tips.rollTip.RollTipMediator;
	import com.view.gameWindow.tips.rollTip.RollTipType;
	import com.view.gameWindow.util.cell.IconCellEx;
	
	import flash.events.MouseEvent;
	
	import mx.utils.StringUtil;

	public class TabHejiBuffMouseHandler
	{
		private var _skin:McPanelHejiBuff;
		private var _heji:TabHejiBuff;
		
		public function TabHejiBuffMouseHandler(heji:TabHejiBuff)
		{
			_heji=heji;
			_skin=heji.skin as McPanelHejiBuff;	
			_skin.addEventListener(MouseEvent.CLICK,onClickFunc);
			_heji.bagCellPanel.addEventListener(MouseEvent.MOUSE_DOWN,onMouseDownFunc);
			_skin.addEventListener(MouseEvent.MOUSE_OVER,onMouseOverFunc);
			_skin.addEventListener(MouseEvent.MOUSE_OUT,onMouseOutFunc);
		}
		
		protected function onMouseOutFunc(event:MouseEvent):void
		{
			if(event.target==_skin.txtOSLink)
			{
				_skin.txtOSLink.textColor=0x53B436;
			}
		}
		
		protected function onMouseOverFunc(event:MouseEvent):void
		{
			if(event.target==_skin.txtOSLink)
			{
				_skin.txtOSLink.textColor=0xff0000;
			}
		}
		
		private function onClickFunc(e:MouseEvent):void
		{
			switch(e.target)
			{
				case _skin.mc0:
					_heji.setSelectBuff(0);
					break;
				case _skin.mc1:
					_heji.setSelectBuff(1);
					break;
				case _skin.mc2:
					_heji.setSelectBuff(2);
					break;
				case _skin.btnSub:
					dealRuneUpgrade();
					break;
				case _skin.txtOSLink:
					setBuffMain();
					break;
				case _skin.btn1:
					ForgeDataManager.instance.dealSwitchPanel(2);
					break;
				case _skin.btn2:
					PanelMediator.instance.switchPanel(PanelConst.TYPE_REPLACE);
					break;
			}
		}
		
		private function setBuffMain():void
		{
			var manager:HejiSkillDataManager = HejiSkillDataManager.instance;
			var jointData:JointHaloData=_heji.getCurrentJointHaloData();
			setJointHaloSkill(jointData.jointHaloCfgDt.halo_skill);
			//
			if(jointData.type == HejiSkillDataManager.MAIN_BUFF)
			{
				RollTipMediator.instance.showRollTip(RollTipType.SYSTEM,StringConst.JOINT_PANEL_0019);
				return;
			}
			var cd:int = manager.isInCD;
			if(cd)
			{
				RollTipMediator.instance.showRollTip(RollTipType.ERROR,StringUtil.substitute(StringConst.JOINT_PANEL_0018,cd));
				return;
			}
			manager.setMainRune(jointData.id);
		}
		
		private function setJointHaloSkill(groupId:int):void
		{
			var isInCD:int = HejiSkillDataManager.instance.isInCD;
			if(isInCD)
			{
				return;
			}
			var groupId2Key:int;
			var manager:ActionBarDataManager = ActionBarDataManager.instance;
			//
			groupId2Key = manager.groupId2Key(groupId);//取该技能可以放置的快捷键值
			var holeSkillGroupIds:Object = SkillData.HOLE_SKILL_GROUP_ID;
			var groupIdOther:int;
			for each (groupIdOther in holeSkillGroupIds)
			{
				if(groupIdOther == groupId)
				{
					continue;
				}
				var dt:ActionBarData = manager.actionBarData(groupIdOther);//快捷栏上是否有关联技能
				if(!dt || dt.isPreinstall)
				{
					continue;
				}
				groupId2Key = manager.groupId2Key(groupIdOther);//取关联技能可以放置的快捷键值
				break;
			}
			manager.sendSetSkillData(groupId2Key,groupId);
		}
		
		private function dealRuneUpgrade():void
		{
			if(_heji.isAdvance==false)
			{
				if(_heji.noAdvanceType==1)
				{
					RollTipMediator.instance.showRollTip(RollTipType.ERROR,StringConst.JOINT_PANEL_0012);
					return;
				} 
				if(_heji.noAdvanceType==2)
				{
					RollTipMediator.instance.showRollTip(RollTipType.ERROR,StringConst.JOINT_PANEL_0013);
					return;
				}
				if(_heji.noAdvanceType==3)
				{
					RollTipMediator.instance.showRollTip(RollTipType.ERROR,StringConst.JOINT_PANEL_0014);
					return
				}
			}else
			{
				RollTipMediator.instance.showRollTip(RollTipType.SYSTEM,StringConst.JOINT_PANEL_0015);
				var jointData:JointHaloData=_heji.getCurrentJointHaloData();
				HejiSkillDataManager.instance.runeUpgrade(jointData.id);
			}
		}
		
		private function onMouseDownFunc(e:MouseEvent):void
		{
			var cell:IconCellEx = e.target as IconCellEx;
			if(!cell || cell.isEmpty())
			{
				return;
			}
			
			inlayRune(cell);
		}
		
		private function inlayRune(cell:IconCellEx):void
		{
			var jointData:JointHaloData=_heji.getCurrentJointHaloData();
			if(jointData==null)return;  //理论上到这里不可能为空 避免服务器数据错误
			var itemCfg:ItemCfgData=ConfigDataManager.instance.itemCfgData(cell.id);
			var nullCellIndex:int= _heji.getNullCellIndexByType(itemCfg.type);
			if(nullCellIndex==0)
			{
				RollTipMediator.instance.showRollTip(RollTipType.ERROR,StringConst.JOINT_PANEL_0010);
				return;
			}
			if(itemCfg.item_level!=jointData.level)
			{
				RollTipMediator.instance.showRollTip(RollTipType.ERROR,StringConst.JOINT_PANEL_0011);
				return;
			}
			RollTipMediator.instance.showRollTip(RollTipType.SYSTEM,StringConst.JOINT_PANEL_0016);
			var bagData:BagData=BagDataManager.instance.getBagCellDataById(cell.id);
			HejiSkillDataManager.instance.runeJointHalo(jointData.id,nullCellIndex,bagData.storageType,bagData.slot);
		}
		
		public function destroy():void
		{
			_skin.removeEventListener(MouseEvent.MOUSE_OVER,onMouseOverFunc);
			_skin.removeEventListener(MouseEvent.MOUSE_OUT,onMouseOutFunc);
			_skin.removeEventListener(MouseEvent.CLICK,onClickFunc);
			_heji.bagCellPanel.removeEventListener(MouseEvent.MOUSE_DOWN,onMouseDownFunc);
		}
	}
}