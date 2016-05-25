package com.view.gameWindow.panel.panels.roleProperty.newLife
{
	import com.model.configData.ConfigDataManager;
	import com.model.configData.cfgdata.LevelCfgData;
	import com.model.configData.cfgdata.ReinCarnCfgData;
	import com.model.consts.JobConst;
	import com.model.consts.StringConst;
	import com.model.consts.ToolTipConst;
	import com.view.gameWindow.panel.panels.bag.BagDataManager;
	import com.view.gameWindow.panel.panels.dungeon.TextFormatManager;
	import com.view.gameWindow.panel.panels.roleProperty.RoleDataManager;
	import com.view.gameWindow.tips.toolTip.TipVO;
	import com.view.gameWindow.tips.toolTip.ToolTipManager;
	import com.view.gameWindow.util.HtmlUtils;
	import com.view.gameWindow.util.UtilColorMatrixFilters;
	import com.view.gameWindow.util.propertyParse.CfgDataParse;
	import com.view.gameWindow.util.propertyParse.ReincarnData;
	import com.view.gameWindow.util.tabsSwitch.TabBase;
	
	public class NewLifePanel extends TabBase
	{
		private var _mcNewLife:McNewLife;
		private var _reincarn:int;
		private const LEVELMAX:int = 68;
		private var roleDataManager:RoleDataManager;
		private var _newLifeMouseHandle:NewLifeMouseHandle;
		
		public function NewLifePanel()
		{
			super();
		}
		
		override protected function initSkin():void
		{
			_skin = new McNewLife();
			addChild(_skin);
			_mcNewLife = _skin as McNewLife;
			roleDataManager = RoleDataManager.instance;
			_newLifeMouseHandle = new NewLifeMouseHandle(_mcNewLife);
		}
		
		override protected function initData():void
		{
			initText();
		}
		
		override public function update(proc:int=0):void
		{
			refreshProgress();
			refreshColorFilter();
			if(_reincarn == roleDataManager.reincarn)
			{
				return;
			}
			_reincarn = roleDataManager.reincarn;
			setValueText();	
		}
		
		private function refreshProgress():void
		{
			var scaleX:Number;
			var reincarnCfg:ReinCarnCfgData = ConfigDataManager.instance.reincarnCfgData(RoleDataManager.instance.reincarn);
			if(isMaxReincarn())
			{
				_mcNewLife.progressTxt.text = StringConst.ROLE_PROPERTY_PANEL_0080;
				_mcNewLife.progress.mcMask.scaleX = 1;
				return;
			}
			if(NewLifeDataManager.instance.dungeon == reincarnCfg.dungeon && NewLifeDataManager.instance.time)
			{
				_mcNewLife.progressTxt.text = StringConst.ROLE_PROPERTY_PANEL_0068 + "100%";
				_mcNewLife.progress.mcMask.scaleX = 1;
				return;
			}
			if(LEVELMAX + roleDataManager.reincarn > roleDataManager.lv)
			{
				_mcNewLife.progressTxt.text = StringConst.ROLE_PROPERTY_PANEL_0068 + "0%";
				scaleX = 0;
			}
			else
			{
				_mcNewLife.progressTxt.text = StringConst.ROLE_PROPERTY_PANEL_0068 + (roleDataManager.exp/ConfigDataManager.instance.levelCfgData(LEVELMAX + roleDataManager.reincarn).player_exp*100).toFixed(1)+"%"
				scaleX = roleDataManager.exp/ConfigDataManager.instance.levelCfgData(LEVELMAX + roleDataManager.reincarn).player_exp;			
			}
			_mcNewLife.progress.mcMask.scaleX = scaleX < 0 ? 0 : (scaleX > 1 ? 1 : scaleX);
		}
		
		private function refreshColorFilter():void
		{
			var reincarnCfg:ReinCarnCfgData = ConfigDataManager.instance.reincarnCfgData(RoleDataManager.instance.reincarn);
			if(isMaxReincarn())
			{
				TextFormatManager.instance.setTextFormat(_mcNewLife.txt_00,0x00ff00,true,false);
				_mcNewLife.txt_00.filters = null;
				_mcNewLife.levelValueTxt.textColor = 0x00ff00;
				_mcNewLife.coinTxt.textColor = 0x00ff00; 
				return;
			}
			if(LEVELMAX + RoleDataManager.instance.reincarn <= RoleDataManager.instance.lv)
			{
				TextFormatManager.instance.setTextFormat(_mcNewLife.txt_00,0x00ff00,true,false);
				_mcNewLife.txt_00.filters = [UtilColorMatrixFilters.YELLOW_COLOR_FILTER];
			}
			else
			{
				TextFormatManager.instance.setTextFormat(_mcNewLife.txt_00,0x00ff00,true,false);
				_mcNewLife.txt_00.filters = null;
			}
			if(LEVELMAX + roleDataManager.reincarn > roleDataManager.lv)
			{
				_mcNewLife.levelValueTxt.textColor = 0xff0000;
			}
			else
			{
				_mcNewLife.levelValueTxt.textColor = 0x00ff00;
			}
			if(reincarnCfg.coin > (BagDataManager.instance.coinBind + BagDataManager.instance.coinUnBind))
			{
				_mcNewLife.coinTxt.textColor = 0xff0000; 
			}
			else
			{
				_mcNewLife.coinTxt.textColor = 0x00ff00; 
			}
		}
		
		private function isMaxReincarn():Boolean
		{
			var nextReincarnCfg:ReinCarnCfgData = ConfigDataManager.instance.reincarnCfgData(roleDataManager.reincarn + 1);
			if(!nextReincarnCfg)
			{
				return true;
			}
			else
			{
				return false;
			}
		}
		
		private function initText():void
		{
			_mcNewLife.propertyTxt.text = StringConst.ROLE_PROPERTY_PANEL_0061;
			_mcNewLife.nextPropertyTxt.text = StringConst.ROLE_PROPERTY_PANEL_0062;
			_mcNewLife.levelTxt.text = _mcNewLife.nextLevelTxt.text = StringConst.ROLE_PROPERTY_PANEL_0063;
			_mcNewLife.hpTxt.text = _mcNewLife.nextHpTxt.text = StringConst.ROLE_PROPERTY_PANEL_0064; 
			_mcNewLife.mpTxt.text = _mcNewLife.nextMpTxt.text =  StringConst.ROLE_PROPERTY_PANEL_0065;
			_mcNewLife.wulimianshangTxt.text = _mcNewLife.nextWulimianshangTxt.text =  StringConst.ROLE_PROPERTY_PANEL_0040;
			_mcNewLife.mofamianshangTxt.text = _mcNewLife.nextMofamianshangTxt.text = StringConst.ROLE_PROPERTY_PANEL_0041;
			_mcNewLife.wulifangyuTxt.text = _mcNewLife.nextWulifangyuTxt.text = StringConst.ROLE_PROPERTY_PANEL_0008;
			_mcNewLife.mofafangyuTxt.text = _mcNewLife.nextMofafangyuTxt.text = StringConst.ROLE_PROPERTY_PANEL_0009;
			_mcNewLife.roleLexelTxt.text = StringConst.ROLE_PROPERTY_PANEL_0066;
			_mcNewLife.costCoinTxt.text = StringConst.ROLE_PROPERTY_PANEL_0067;
			_mcNewLife.txt_00.text = StringConst.ROLE_PROPERTY_PANEL_0069;
			_mcNewLife.txt_01.text = StringConst.ROLE_PROPERTY_PANEL_0070;
			setValueText();
		}
		
		private function addExpTipListener():void
		{
			var tipVO:TipVO = new TipVO();
			tipVO.tipType = ToolTipConst.TEXT_TIP;
			tipVO.tipData = refreshToolTipStr;
			ToolTipManager.getInstance().hashTipInfo(_mcNewLife.progressTxt,tipVO);
			ToolTipManager.getInstance().attach(_mcNewLife.progressTxt);
		}
		
		override public function initView():void
		{
			super.initView();
			addExpTipListener();
		}
		
		
		private function refreshToolTipStr():String
		{
			var str:String;
			var reincarnCfg:ReinCarnCfgData = ConfigDataManager.instance.reincarnCfgData(RoleDataManager.instance.reincarn);
			var levelCfg:LevelCfgData = ConfigDataManager.instance.levelCfgData(LEVELMAX + roleDataManager.reincarn);
			if(!ConfigDataManager.instance.reincarnCfgData(RoleDataManager.instance.reincarn + 1))
			{
				str =HtmlUtils.createHtmlStr(0xffffff,StringConst.ROLE_PROPERTY_PANEL_0080);
				return str;
			}
			if(LEVELMAX + RoleDataManager.instance.reincarn <= RoleDataManager.instance.lv)
			{
				str = HtmlUtils.createHtmlStr(0xffffff,StringConst.ROLE_PROPERTY_PANEL_0073 + StringConst.ROLE_PROPERTY_PANEL_0074 + String(roleDataManager.exp) + "/" + String(levelCfg.player_exp));
			}
			else
			{
				str =  HtmlUtils.createHtmlStr(0xffffff,StringConst.ROLE_PROPERTY_PANEL_0073);
			}
			return str;
		}
		
		/**
		 *根据职业返回转生属性 
		 * @param reincarnCfg
		 * @return 
		 * 
		 */		
		private function getReincarnCfgAttr(reincarnCfg:ReinCarnCfgData):String
		{
			if(roleDataManager.job == JobConst.TYPE_ZS)
			{
				return reincarnCfg.soldier_attr;
			}
			else if(roleDataManager.job == JobConst.TYPE_FS)
			{
				return reincarnCfg.mage_attr;
			}
			else if(roleDataManager.job == JobConst.TYPE_DS)
			{
				return reincarnCfg.taolist_attr;
			}
			return "";
		}
		
		/**
		 * 设置转生属性值
		 * 
		 */		
		private function setValueText():void
		{
			var reincarnCfg:ReinCarnCfgData = ConfigDataManager.instance.reincarnCfgData(roleDataManager.reincarn);
			var nextReincarnCfg:ReinCarnCfgData = ConfigDataManager.instance.reincarnCfgData(roleDataManager.reincarn + 1);
			var vectorReincarn:Vector.<ReincarnData> = CfgDataParse.propertyDatas(getReincarnCfgAttr(reincarnCfg));
			_mcNewLife.newLifeTxt.text = String(roleDataManager.reincarn) + StringConst.ROLE_PROPERTY_PANEL_0071;
			_mcNewLife.valueTxt_00.text = (LEVELMAX + roleDataManager.reincarn).toString() + StringConst.ROLE_PROPERTY_PANEL_0072;
			_mcNewLife.valueTxt_01.text = vectorReincarn[0].value.toString();
			_mcNewLife.valueTxt_02.text = vectorReincarn[1].value.toString();
			_mcNewLife.valueTxt_03.text = vectorReincarn[6].value.toString();
			_mcNewLife.valueTxt_04.text = vectorReincarn[7].value.toString();
			_mcNewLife.valueTxt_05.text = vectorReincarn[2].value.toString() + "-" + vectorReincarn[3].value.toString();
			_mcNewLife.valueTxt_06.text = vectorReincarn[4].value.toString() + "-" + vectorReincarn[5].value.toString();
			
			if(isMaxReincarn())
			{
				_mcNewLife.nextNewLifeTxt.text = "--";
				_mcNewLife.levelValueTxt.text = "--";
				_mcNewLife.coinTxt.text = "--"; 
				_mcNewLife.nextValueTxt_00.text = "--";
				_mcNewLife.nextValueTxt_01.text = "--";
				_mcNewLife.nextValueTxt_02.text = "--";
				_mcNewLife.nextValueTxt_03.text = "--";
				_mcNewLife.nextValueTxt_04.text = "--";
				_mcNewLife.nextValueTxt_05.text = "--";
				_mcNewLife.nextValueTxt_06.text = "--";
				
				_mcNewLife.addValueTxt_00.text = "--";
				_mcNewLife.addValueTxt_01.text = "--";
				_mcNewLife.addValueTxt_02.text = "--";
				_mcNewLife.addValueTxt_03.text = "--";
				_mcNewLife.addValueTxt_04.text = "--";
				_mcNewLife.addValueTxt_05.text = "--";
				_mcNewLife.addValueTxt_06.text = "--";
				return;
			}
			_mcNewLife.nextNewLifeTxt.text = String(roleDataManager.reincarn + 1) + StringConst.ROLE_PROPERTY_PANEL_0071;
			_mcNewLife.levelValueTxt.text = _mcNewLife.valueTxt_00.text;
			_mcNewLife.coinTxt.text = reincarnCfg.coin.toString();
			var vectorNextReincarn:Vector.<ReincarnData> = CfgDataParse.propertyDatas(getReincarnCfgAttr(nextReincarnCfg));
			_mcNewLife.nextValueTxt_00.text = String(LEVELMAX + roleDataManager.reincarn + 1) + StringConst.ROLE_PROPERTY_PANEL_0072;
			_mcNewLife.nextValueTxt_01.text = vectorNextReincarn[0].value.toString();
			_mcNewLife.nextValueTxt_02.text = vectorNextReincarn[1].value.toString();
			_mcNewLife.nextValueTxt_03.text = vectorNextReincarn[6].value.toString();
			_mcNewLife.nextValueTxt_04.text = vectorNextReincarn[7].value.toString();
			_mcNewLife.nextValueTxt_05.text = vectorNextReincarn[2].value.toString() + "-" + vectorNextReincarn[3].value.toString();
			_mcNewLife.nextValueTxt_06.text = vectorNextReincarn[4].value.toString() + "-" + vectorNextReincarn[5].value.toString();
			
			_mcNewLife.addValueTxt_00.text = String(1);
			_mcNewLife.addValueTxt_01.text = (vectorNextReincarn[0].value - vectorReincarn[0].value).toString();
			_mcNewLife.addValueTxt_02.text = (vectorNextReincarn[1].value - vectorReincarn[1].value).toString();
			_mcNewLife.addValueTxt_03.text = (vectorNextReincarn[6].value - vectorReincarn[6].value).toString();
			_mcNewLife.addValueTxt_04.text = (vectorNextReincarn[7].value - vectorReincarn[7].value).toString();
			_mcNewLife.addValueTxt_05.text = (vectorNextReincarn[2].value - vectorReincarn[2].value).toString();
			_mcNewLife.addValueTxt_06.text = (vectorNextReincarn[4].value - vectorReincarn[4].value).toString();		
		}
		
		override public function destroy():void
		{
			ToolTipManager.getInstance().detach(_mcNewLife.progressTxt);
			if(_newLifeMouseHandle)
			{
				_newLifeMouseHandle.destory();
				_newLifeMouseHandle = null;
			}
			roleDataManager = null;
			_mcNewLife = null;
			super.destroy();
		}
		
		override protected function attach():void
		{
			// TODO Auto Generated method stub
			RoleDataManager.instance.attach(this);
			BagDataManager.instance.attach(this);
			NewLifeDataManager.instance.attach(this);
			super.attach();
		}
		
		override protected function detach():void
		{
			// TODO Auto Generated method stub
			RoleDataManager.instance.detach(this);
			BagDataManager.instance.detach(this);
			NewLifeDataManager.instance.detach(this);
			super.detach();
		}
		
	}
}