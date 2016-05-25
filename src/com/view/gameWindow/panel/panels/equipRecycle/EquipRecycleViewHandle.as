package com.view.gameWindow.panel.panels.equipRecycle
{
	import com.model.business.fileService.constants.ResourcePathConstants;
	import com.model.configData.ConfigDataManager;
	import com.model.configData.cfgdata.EquipCfgData;
	import com.model.configData.cfgdata.EquipRecycleCfgData;
	import com.model.configData.cfgdata.EquipRecycleRwdCfgData;
	import com.model.configData.cfgdata.ItemCfgData;
	import com.model.consts.ItemType;
	import com.model.consts.StringConst;
	import com.model.consts.ToolTipConst;
	import com.model.gameWindow.mem.MemEquipData;
	import com.model.gameWindow.mem.MemEquipDataManager;
	import com.model.gameWindow.rsr.RsrLoader;
	import com.view.gameWindow.common.HighlightEffectManager;
	import com.view.gameWindow.flyEffect.FlyEffectMediator;
	import com.view.gameWindow.panel.panels.McEquipRecycle;
	import com.view.gameWindow.panel.panels.bag.BagData;
	import com.view.gameWindow.panel.panels.guideSystem.GuideSystem;
	import com.view.gameWindow.panel.panels.guideSystem.action.GuideAction;
	import com.view.gameWindow.panel.panels.guideSystem.constants.GuidesID;
	import com.view.gameWindow.panel.panels.roleProperty.RoleDataManager;
	import com.view.gameWindow.tips.toolTip.TipVO;
	import com.view.gameWindow.tips.toolTip.ToolTipManager;
	import com.view.gameWindow.util.HtmlUtils;
	import com.view.gameWindow.util.UrlPic;
	import com.view.gameWindow.util.UtilItemParse;
	import com.view.gameWindow.util.cell.IconCellEx;
	import com.view.gameWindow.util.cell.ThingsData;
	
	import flash.display.MovieClip;
	import flash.utils.clearInterval;
	import flash.utils.setInterval;
	
	import mx.utils.StringUtil;

	public class EquipRecycleViewHandle
	{
		private var _panel:PanelEquipRecycle;
		private var _skin:McEquipRecycle;
		internal var _equipIcon:UrlPic;
		private var _rewardtipVO:TipVO;
		internal var _equipRecycleCellHandle:EquipRecycleCellHandle;
		private var _isLoadScrollbar:Boolean;
		private var dts:Vector.<ThingsData>;
		private var _nums:Array = [40, 50, 60, 70, 80, 90];
		private var filterUi:HighlightEffectManager = new HighlightEffectManager;
		private var _scaleX:Number;
		private var _mcRewardLoaded:Boolean = false;
		private var _guide:GuideAction;
		
		public function EquipRecycleViewHandle(panel:PanelEquipRecycle)
		{
			_panel = panel;
			_skin = panel.skin as McEquipRecycle;
		}
		
		public function init(rsrLoader:RsrLoader):void
		{

			_equipIcon = new UrlPic(_skin.mcIcon);
			_skin.soldierTxt.mouseEnabled = _skin.taoistTxt.mouseEnabled =_skin.wizardTxt.mouseEnabled = false;
			
			_equipRecycleCellHandle = new EquipRecycleCellHandle(_panel);
			rsrLoader.addCallBack(_skin.selectCellEfc,function (mc:MovieClip):void
			{
				mc.visible = false;
			}
			);
			rsrLoader.addCallBack(_skin.mcScrollBar,function (mc:MovieClip):void
			{
				/*EquipRecycleDataManager.instance.getEecyaleEquipDatas();
				EquipRecycleDataManager.instance.filterEecyaleEquipDatas();*/
				_isLoadScrollbar = true;
			   _equipRecycleCellHandle.addScrollBar(mc);
			}
			);
			
			rsrLoader.addCallBack(_skin.mcReward.mc,function (mc:MovieClip):void
			{
				if(_scaleX == 1)
				{
					filterUi.show(_skin.mcReward,mc);
				}
				else
				{
					filterUi.hide(mc);
				}
				_mcRewardLoaded = true;
			}
			);

			for(var i:int = 0;i < 9;i++)
			{
				_skin['txt'+i].text = StringConst['EQUIPRECYCLE_PANEL_000'+i];
			}
			
			_rewardtipVO = new TipVO();
			_rewardtipVO.tipType = ToolTipConst.TEXT_TIP;
			_rewardtipVO.tipData = getRwdString;			
			ToolTipManager.getInstance().attach(_skin.mcReward);
			
			var tip:TipVO = new TipVO;
			tip.tipType = ToolTipConst.TEXT_TIP;
			tip.tipData = StringConst.EQUIPRECYCLE_PANEL_0020;			
			ToolTipManager.getInstance().hashTipInfo(_skin.decRuleMc,tip);
			ToolTipManager.getInstance().attach(_skin.decRuleMc);
			
			_skin.mcReward.buttonMode = true;
			
			handleMcReward();
			
			if(!_guide)
			{
				_guide = GuideSystem.instance.createAction(GuidesID.EQUIP_RECYCLE);
				_guide.init();
				_guide.act();
				_guide.check();
			}
		}
		private function handleMcReward():void
		{
			var rewardCount:int = EquipRecycleDataManager.instance.getRewardCount;
			var reincarn:int = RoleDataManager.instance.reincarn;
			var max:int = ConfigDataManager.instance.equipRecycleRwdCfgDataLength(reincarn);
			if(max == rewardCount)
			{
				_skin.mcReward.visible = false;
			}
		}
		public function refresh():void
		{
			EquipRecycleDataManager.instance.getEecyaleEquipDatas();
			EquipRecycleDataManager.instance.filterEecyaleEquipDatas();
			refreshScrollbar();
			refreshCell();
			refreshEquip();
			refreshAward();
			refreshRecycleGuide();
		}
		
		public function initRecycleGuide():void
		{
			if(!_guide)
			{
				_guide = GuideSystem.instance.createAction(GuidesID.EQUIP_RECYCLE);
				_guide.init();
				_guide.act();
				_guide.check();
			}
		}
		
		public function refreshRecycleGuide():void
		{
			if(_guide)
			{
				_guide.check();
			}
		}
		
		public function destroyRecycleGuide():void
		{
			if(_guide)
			{
				_guide.destroy();
				_guide = null;
			}
		}
		
		public function refreshScrollbar():void
		{
			if(_isLoadScrollbar)
				_equipRecycleCellHandle.addScrollBar(_skin.mcScrollBar); 
		}
		
		public function refreshCell():void
		{
			/*EquipRecycleDataManager.instance.getEecyaleEquipDatas();
			EquipRecycleDataManager.instance.filterEecyaleEquipDatas();*/
			_equipRecycleCellHandle.refresh();
		}
		public function clearCells():void
		{
			_equipRecycleCellHandle.clearCells();
			_equipIcon.destroyBmp();
			_skin.expTxt.text = "";
			_skin.awardTxt.text = "";
		}
		
		public function refreshEquip():void
		{
			var selectData:BagData = EquipRecycleDataManager.instance.selectData;
			if(!selectData)
			{
				/*EquipRecycleDataManager.instance.getEecyaleEquipDatas();
				EquipRecycleDataManager.instance.filterEecyaleEquipDatas();*/
				_equipIcon.destroyBmp();
				_skin.expTxt.text = "";
				_skin.awardTxt.text = "";	
				return;
			}
			var reincarn:int = RoleDataManager.instance.reincarn;
			//= ConfigDataManager.instance.equipRecycleRwdCfgDataMax(reincarn).reward_point;
			var equipRecycleRwdCfgDataMax:EquipRecycleRwdCfgData;
			equipRecycleRwdCfgDataMax = ConfigDataManager.instance.equipRecycleRwdCfgDataMax(reincarn);
			var max:uint;
			if(!equipRecycleRwdCfgDataMax)
			{
				return;
			}
			max = equipRecycleRwdCfgDataMax.reward_point;
			var num:int = EquipRecycleDataManager.instance.progress;
			var memEquipData:MemEquipData = MemEquipDataManager.instance.memEquipData(selectData.bornSid,selectData.id);
			var equipCfgData:EquipCfgData = ConfigDataManager.instance.equipCfgData(memEquipData.baseId);	
			var equipRecycleCfgData:EquipRecycleCfgData = ConfigDataManager.instance.equipRecycleCfgData(equipCfgData.type,equipCfgData.quality,equipCfgData.level);
			var exp:int;
			if(equipRecycleCfgData)
			{
				exp = equipRecycleCfgData.exp;
				if((equipRecycleCfgData.exp+num)>=max)
				{
					exp = max - num; 
				}
				_skin.expTxt.text = StringUtil.substitute(StringConst.EQUIPRECYCLE_PANEL_0013, String(exp));
				_skin.awardTxt.text = StringConst.EQUIPRECYCLE_PANEL_0014;
			}
			else
			{
				trace("RecycleEquipHandle.init 配置信息错误");
			}
			if(!EquipRecycleDataManager.instance.isAllRecycle)
			{
				_equipIcon.load(ResourcePathConstants.IMAGE_ICON_EQUIP_FOLDER_LOAD+equipCfgData.icon+ResourcePathConstants.POSTFIX_PNG);
			}
			else
			{
			}

			var totalExp:int = EquipRecycleDataManager.instance.getTotalExp();
			if (totalExp)
			{
				EquipRecycleDataManager.totalExpShow = true;
			} 
			else
			{
				EquipRecycleDataManager.totalExpShow = false;
			}

		}
		
		public function refreshAward():void
		{
			var index:int = EquipRecycleDataManager.instance.currentIndex;
			_rewardtipVO.tipDataValue = index;
			ToolTipManager.getInstance().hashTipInfo(_skin.mcReward,_rewardtipVO);
			var data:Array = EquipRecycleDataManager.instance.awardInfo;
			var num:int = EquipRecycleDataManager.instance.progress;
			var len:int = data.length;
			for(var i:int = 0;i < len-3;i++)
			{
				var str:String = _nums[i].toString();
				_skin['awardTxt'+i].text = StringUtil.substitute(StringConst.EQUIPRECYCLE_PANEL_0011,str,String(data[i]));
			}
			var reincarn:int = RoleDataManager.instance.reincarn;
			var equipRecycleRwdCfgDataMax:EquipRecycleRwdCfgData;
			equipRecycleRwdCfgDataMax = ConfigDataManager.instance.equipRecycleRwdCfgDataMax(reincarn);
			var max:uint;
			if(!equipRecycleRwdCfgDataMax)
			{
				return;
			}
			
			max = equipRecycleRwdCfgDataMax.reward_point;
			var recycle:EquipRecycleRwdCfgData = ConfigDataManager.instance.equipRecycleRwdCfgData(reincarn,index);
			var currentMax:int = recycle ? recycle.reward_point : 0;
			_skin.todayExpTxt.text = StringUtil.substitute(StringConst.EQUIPRECYCLE_PANEL_0012,max);
			_skin.progressTxt.text = String(num)+"/"+String(currentMax);
			_scaleX = (num/currentMax)>1 ? 1:(num/currentMax);
			(_skin.mcProgressBar.mcMask as MovieClip).scaleX = _scaleX;
			if(_scaleX == 1 && _mcRewardLoaded)
			{
				filterUi.show(_skin.mcReward,_skin.mcReward.mc);
			}
			else
			{
				filterUi.hide(_skin.mcReward.mc);
			}
			handleMcReward();
		}
		
		private function getRwdString(index:int):String
		{
			var reincarn:int = RoleDataManager.instance.reincarn;
			var equipRecycleRwdCfgData:EquipRecycleRwdCfgData = ConfigDataManager.instance.equipRecycleRwdCfgData(reincarn,index);
			var str:String = "",createHtmlStr:String;
			createHtmlStr = HtmlUtils.createHtmlStr(0xffcc00,StringConst.RECYCLE_EQUIP_PANEL_0022+equipRecycleRwdCfgData.reward_point);
			str += createHtmlStr+"\n";
			createHtmlStr = HtmlUtils.createHtmlStr(0xd4a460,StringConst.RECYCLE_EQUIP_PANEL_0023);
			str += createHtmlStr;
			var progress:int = EquipRecycleDataManager.instance.progress;
			var need:int = equipRecycleRwdCfgData.reward_point-progress;
			createHtmlStr = HtmlUtils.createHtmlStr(0xffe1aa,(need < 0 ? 0 : need)+"");
			str += createHtmlStr+"\n";
			createHtmlStr = HtmlUtils.createHtmlStr(0xd4a460,StringConst.RECYCLE_EQUIP_PANEL_0024);
			str += createHtmlStr;
			var reward:String = equipRecycleRwdCfgData.reward;
			dts = UtilItemParse.getThingsDatas(reward);
			var i:int,l:int = dts.length;
			for (i=0;i<l;i++) 
			{
				var cfgDt:ItemCfgData = dts[i].itemCfgData;
				var name:String = cfgDt.name;
				var count:int = dts[i].count;
				var color:int = ItemType.getColorByQuality(cfgDt.quality);
				createHtmlStr = HtmlUtils.createHtmlStr(color,name+"*"+count+" ");
				str += createHtmlStr;
			}
			return str;
		}
		
		internal function destroy():void
		{
			_equipIcon.destroy();
			ToolTipManager.getInstance().detach(_skin.mcReward);
			ToolTipManager.getInstance().detach(_skin.decRuleMc);
			_equipRecycleCellHandle.destroy();
			filterUi.hide(_skin.mcReward.mc);
			filterUi = null;
			_equipRecycleCellHandle = null;
			_rewardtipVO = null;
			_skin = null;
			_equipIcon = null;
			if(dts)
			{
				dts.length = 0;
				dts = null;
			}
			if (_nums)
			{
				_nums.length = 0;
				_nums = null;
			}
			
			destroyRecycleGuide();
		}
		
		public function flyAward():void
		{
			var iconcell:IconCellEx;
			var iconData:Array = [];
			for each(var td:ThingsData in dts)
			{
				iconcell = new IconCellEx(_skin.mcReward.parent,_skin.mcReward.x,_skin.mcReward.y,_skin.mcReward.width,_skin.mcReward.height);
				iconcell.url = ResourcePathConstants.IMAGE_ICON_ITEM_FOLDER_LOAD+td.cfgData.icon+ResourcePathConstants.POSTFIX_PNG;
				iconData.push(iconcell);
			}
			var id:uint = setInterval(function():void
			{
				FlyEffectMediator.instance.doFlyReceiveThings2(iconData);
				clearInterval(id);
			},500);
		}
	}
}