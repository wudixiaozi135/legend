package com.view.gameWindow.panel.panels.hejiSkill.tabHejiBuff
{
	import com.model.configData.ConfigDataManager;
	import com.model.configData.cfgdata.ItemCfgData;
	import com.model.configData.cfgdata.JointHaloCfgData;
	import com.model.configData.cfgdata.SkillCfgData;
	import com.model.consts.SlotType;
	import com.model.consts.StringConst;
	import com.model.consts.ToolTipConst;
	import com.view.gameWindow.panel.panels.bag.BagDataManager;
	import com.view.gameWindow.panel.panels.hejiSkill.McPanelHejiBuff;
	import com.view.gameWindow.panel.panels.roleProperty.RoleDataManager;
	import com.view.gameWindow.tips.toolTip.ToolTipManager;
	import com.view.gameWindow.util.NumUtil;
	import com.view.gameWindow.util.UtilColorMatrixFilters;
	import com.view.gameWindow.util.cell.IconCellEx;
	import com.view.gameWindow.util.cell.ThingsData;
	import com.view.gameWindow.util.propertyParse.CfgDataParse;
	
	import mx.utils.StringUtil;

	public class TabHejiBuffHandler
	{
		private var _tabHeji:TabHejiBuff;
		private var _mcPanel:McPanelHejiBuff;
		public function TabHejiBuffHandler(tabHeji:TabHejiBuff)
		{
			_tabHeji=tabHeji;
			_mcPanel=tabHeji.skin as McPanelHejiBuff;
		}

		public function updateBag(bagCells:Vector.<IconCellEx>):void
		{
			var starId:int=0;
			var jointData:JointHaloData=_tabHeji.getCurrentJointHaloData();
			if(jointData==null)return;
			for (var i:int=0;i<bagCells.length;i++)
			{
				bagCells[i].setNull();
				for(var id:int=161+starId;id<=200;id++)//道具的id 161 到200为符文的类型
				{
					starId++;
					var bagCfg:ItemCfgData=ConfigDataManager.instance.itemCfgData(id);
					if(bagCfg.item_level!=jointData.level)continue;
					var num:int=BagDataManager.instance.getItemNumById(id);
					if(num<=0)continue;
					if(num>99)
					{
						var count:int=Math.ceil(num/99);
						while(count>0)
						{
							var newN:int=count==1?num%99:99;
							IconCellEx.setItem(bagCells[i],SlotType.IT_ITEM,id,newN);
							ToolTipManager.getInstance().attach(bagCells[i]);
							i++;
							count--;
						}
						i--;
					}else
					{
						IconCellEx.setItem(bagCells[i],SlotType.IT_ITEM,id,num);
						ToolTipManager.getInstance().attach(bagCells[i]);
					}
					break;
				}
			}
		}
		
		
		
		public function updatePanel(jointCfgData:JointHaloCfgData,jointData:JointHaloData,buffCells:Vector.<IconCellEx>,skillCell:IconCellEx):void
		{
			initAttr(jointCfgData,jointData,buffCells);
			initSkill(jointCfgData,jointData,skillCell);
		}
		
		private function initAttr(jointCfgData:JointHaloCfgData,jointData:JointHaloData,buffCells:Vector.<IconCellEx>):void
		{
			var attr:String=jointCfgData.attr;
			var l:int=jointData.buffs.length;
			var buffCount:int=0;
			var subAttrs:Vector.<String>=new Vector.<String>();
			for(var i:int=0;i<l;i++)
			{
				var id:int=jointData.buffs[i];
				if(id==0)
				{
					buffCells[i].setNull();
					continue;
				}
				buffCount++;
				var itemCfg:ItemCfgData = ConfigDataManager.instance.itemCfgData(id);
				subAttrs.push(itemCfg.effect);
				var dt:ThingsData=new ThingsData();
				dt.id=id;
				dt.type=SlotType.IT_ITEM;
				dt.count=0;
				IconCellEx.setItemByThingsData(buffCells[i],dt);
			}
			//**************************************//
			if(buffCount==l)
			{
				_tabHeji.isAdvance=true;
				_mcPanel.btnSub.filters=null;
				_mcPanel.txtNum.htmlText="<font color='#00ff00'>"+buffCount+"/"+l+"</font>";
			}else
			{
				_tabHeji.isAdvance=false;
				_tabHeji.noAdvanceType=1;
				_mcPanel.btnSub.filters=UtilColorMatrixFilters.GREY_FILTERS;
				_mcPanel.txtNum.htmlText="<font color='#ff0000'>"+buffCount+"/"+l+"</font>";
			}
			var nextJointCfg:JointHaloCfgData=ConfigDataManager.instance.jointHaloCfgData(jointData.id,jointData.level+1);
			_mcPanel.btnSub.visible=nextJointCfg!=null;
			if(nextJointCfg!=null)
			{
				if(nextJointCfg.gold>BagDataManager.instance.goldUnBind)   //元宝不足
				{
					_tabHeji.isAdvance=false;
					_tabHeji.noAdvanceType=2;
					_mcPanel.btnSub.filters=UtilColorMatrixFilters.GREY_FILTERS;
				}
				else if(nextJointCfg.reincarn>RoleDataManager.instance.reincarn||(RoleDataManager.instance.reincarn<=nextJointCfg.reincarn&&nextJointCfg.start_level>RoleDataManager.instance.lv))
				{
					_tabHeji.isAdvance=false;
					_tabHeji.noAdvanceType=3;
					_mcPanel.btnSub.filters=UtilColorMatrixFilters.GREY_FILTERS;
				}
			}
			ToolTipManager.getInstance().attachByTipVO(_mcPanel.btnSub,ToolTipConst.JOINT_TIP,jointData);
			//******************************************//
			var atts:Vector.<String>=CfgDataParse.getAttSubJoinHtml(attr,subAttrs);
			var attsStr:String="";
			for (var j:int=0;j<atts.length;j++)
			{
				attsStr+=atts[j]+"\n";
			}	
			_mcPanel.txtAttr.htmlText="<TEXTFORMAT LEADING='-2'>"+attsStr+"</TEXTFORMAT>";
		}
		
		private function initSkill(jointCfgData:JointHaloCfgData,jointData:JointHaloData,skillCell:IconCellEx):void
		{
			if(jointCfgData.halo_skill>0)
			{
				var skillCfg:SkillCfgData=ConfigDataManager.instance.skillCfgData1(jointCfgData.halo_skill);
				IconCellEx.setItemBySkill(skillCell,skillCfg);
				skillCell.filters=null;
				_mcPanel.txtSkil.text=StringUtil.substitute(StringConst.JOINT_PANEL_0017,NumUtil.getNUM(jointData.level));
			}else
			{
				for (var t:int=jointData.level+1;t<11;t++)
				{
					var jointCfg:JointHaloCfgData=ConfigDataManager.instance.jointHaloCfgData(jointData.id,t);
					if(jointCfg.halo_skill>0)
					{
						var skillCfg1:SkillCfgData=ConfigDataManager.instance.skillCfgData1(jointCfg.halo_skill);
						IconCellEx.setItemBySkill(skillCell,skillCfg1);
						skillCell.filters=UtilColorMatrixFilters.GREY_FILTERS;
						_mcPanel.txtSkil.text=StringUtil.substitute(StringConst.JOINT_PANEL_0009,NumUtil.getNUM(t));
						break;
					}
				}
			}
		}
		
		public function destroy():void
		{
			ToolTipManager.getInstance().detach(_mcPanel.btnSub);
		}
	}
}