package com.view.gameWindow.panel.panels.dungeonTower
{
	import com.model.business.gameService.constants.GameServiceConstants;
	import com.model.configData.cfgdata.DungeonCfgData;
	import com.model.consts.FontFamily;
	import com.model.consts.StringConst;
	import com.model.gameWindow.rsr.RsrLoader;
	import com.view.gameWindow.common.Alert;
	import com.view.gameWindow.panel.PanelConst;
	import com.view.gameWindow.panel.PanelMediator;
	import com.view.gameWindow.panel.panelbase.PanelBase;
	import com.view.gameWindow.panel.panels.bag.BagDataManager;
	import com.view.gameWindow.panel.panels.dungeon.DgnDataManager;
	import com.view.gameWindow.panel.panels.dungeon.DungeonData;
	import com.view.gameWindow.panel.panels.roleProperty.RoleDataManager;
	import com.view.gameWindow.tips.rollTip.RollTipMediator;
	import com.view.gameWindow.tips.rollTip.RollTipType;
	import com.view.gameWindow.util.HtmlUtils;
	import com.view.gameWindow.util.propertyParse.CfgDataParse;
	
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	/**
	 * 塔防副本进入领取面板类
	 * @author Administrator
	 */	
	public class PanelDgnTowerEnter extends PanelBase
	{
		public function PanelDgnTowerEnter()
		{
			super();
			DgnDataManager.instance.attach(this);
			DgnTowerDataManger.instance.attach(this);
		}
		
		override protected function initSkin():void
		{
			var skin:McDgnTowerEnter = new McDgnTowerEnter();
			_skin = skin;
			addChild(_skin);
			setTitleBar(skin.mcDrag);
		}
		
		override protected function addCallBack(rsrLoader:RsrLoader):void
		{
			var skin:McDgnTowerEnter = _skin as McDgnTowerEnter;
			rsrLoader.addCallBack(skin.btn,function(mc:MovieClip):void
			{
				var txt:TextField = mc.txt as TextField;
				txt.text = StringConst.DGN_TOWER_0016;
			});
		}
		
		override protected function initData():void
		{
			initText();
			_skin.addEventListener(MouseEvent.CLICK,onClick);
		}
		
		protected function onClick(event:MouseEvent):void
		{
			var skin:McDgnTowerEnter = _skin as McDgnTowerEnter;
			switch(event.target)
			{
				default:
					break;
				case skin.btn:
					dealBtn();
					break;
				case skin.btnClose:
					dealBtnClose();
					break;
				case skin.txtGet:
					dealTxtGet();
					break;
			}
		}
		
		private function dealBtn():void
		{
			var remainCellNum:int = BagDataManager.instance.remainCellNum;
			if(remainCellNum < 4)
			{
				Alert.warning(StringConst.DGN_TOWER_0044);
				return;
			}
			var manager:DgnTowerDataManger = DgnTowerDataManger.instance;
			var cfgDt:DungeonCfgData = manager.dgnCfgDt();
			var limitLv:int = cfgDt ? cfgDt.level : int.MAX_VALUE;
			var limitReincarn:int = cfgDt ? cfgDt.reincarn : int.MAX_VALUE;
			var checkReincarnLevel:Boolean = RoleDataManager.instance.checkReincarnLevel(limitReincarn,limitLv);
			if(!checkReincarnLevel)
			{
				RollTipMediator.instance.showRollTip(RollTipType.ERROR,StringConst.DGN_TOWER_0034);
				return;
			}
			var dgnDt:DungeonData = DgnDataManager.instance.getDgnDt(manager.dungeonId);
			var complete:int = dgnDt ? dgnDt.daily_enter_count : 0;
			var total:int = cfgDt ? cfgDt.free_count + cfgDt.toll_count : 0;
			if(complete >= total)
			{
				RollTipMediator.instance.showRollTip(RollTipType.ERROR,StringConst.DGN_TOWER_0033);
				return;
			}
			var expGain:int = DgnTowerDataManger.instance.expGain;
			if(expGain)
			{
				RollTipMediator.instance.showRollTip(RollTipType.ERROR,StringConst.DGN_TOWER_0026);
				return;
			}
			DgnTowerDataManger.instance.cmEnterDungeon();
		}
		
		private function dealBtnClose():void
		{
			PanelMediator.instance.closePanel(PanelConst.TYPE_DUNGEON_TOWER_ENTER);
		}
		
		private function dealTxtGet():void
		{
			var expGain:int = DgnTowerDataManger.instance.expGain;
			if(expGain)
			{
				PanelMediator.instance.openPanel(PanelConst.TYPE_DUNGEON_TOWER_REWARD);
			}
			else
			{
				RollTipMediator.instance.showRollTip(RollTipType.ERROR,StringConst.DGN_TOWER_0025);
			}
		}
		
		private function initText():void
		{
			var manager:DgnTowerDataManger = DgnTowerDataManger.instance;
			var skin:McDgnTowerEnter = _skin as McDgnTowerEnter;
			var str:String;
			//标题
			var defaultTextFormat:TextFormat = skin.txtTitle.defaultTextFormat;
			defaultTextFormat.bold = true;
			skin.txtTitle.defaultTextFormat = defaultTextFormat;
			skin.txtTitle.setTextFormat(defaultTextFormat);
			skin.txtTitle.text = StringConst.DGN_TOWER_0001;
			//副本描述
			var cfgDt:DungeonCfgData = manager.dgnCfgDt();
			str = cfgDt && cfgDt.npcCfgData ? CfgDataParse.pareseDesToStr(cfgDt.npcCfgData.default_dialog,0xffe1aa,10) : "";
			skin.txtDesc.htmlText = str;
			//经验
			str = StringConst.DGN_TOWER_0011 + HtmlUtils.createHtmlStr(0xffcc00,manager.expGain+'');
			skin.txtExp.htmlText = str;
			skin.txtExp.width = skin.txtExp.textWidth + 5;
			//领取
			skin.txtGet.x = skin.txtExp.x + skin.txtExp.width;
			skin.txtGet.htmlText = HtmlUtils.createHtmlStr(skin.txtGet.textColor,StringConst.DGN_TOWER_0012,12,false,2,FontFamily.FONT_NAME,true);
			//次数
			var dgnDt:DungeonData = DgnDataManager.instance.getDgnDt(manager.dungeonId);
			var complete:int = dgnDt ? dgnDt.daily_enter_count : 0;
			var total:int = cfgDt ? cfgDt.free_count + cfgDt.toll_count : 0;
			str = StringConst.DGN_TOWER_0013 + HtmlUtils.createHtmlStr(0xff0000,complete+"/"+total);
			skin.txtTimes.htmlText = str;
			//提示
			skin.txtTip.text = StringConst.DGN_TOWER_0014;
			//奖励
			skin.txtReward.htmlText = StringConst.DGN_TOWER_0015;
		}
		
		override public function update(proc:int=0):void
		{
			var sm_tower_dungeon_exp:int = GameServiceConstants.SM_TOWER_DUNGEON_EXP;
			var cm_get_tower_dungeon_exp:int = GameServiceConstants.CM_GET_TOWER_DUNGEON_EXP;
			var sm_chr_dungeon_info:int = GameServiceConstants.SM_CHR_DUNGEON_INFO;
			if(proc == sm_tower_dungeon_exp || proc == cm_get_tower_dungeon_exp || proc == sm_chr_dungeon_info)
			{
				//经验
				var skin:McDgnTowerEnter = _skin as McDgnTowerEnter;
				var manager:DgnTowerDataManger = DgnTowerDataManger.instance;
				var str:String = StringConst.DGN_TOWER_0011 + HtmlUtils.createHtmlStr(0xffcc00,manager.expGain+'');
				skin.txtExp.htmlText = str;
				skin.txtExp.width = skin.txtExp.textWidth + 5;
				//领取
				skin.txtGet.x = skin.txtExp.x + skin.txtExp.width;
				//次数
				var cfgDt:DungeonCfgData = manager.dgnCfgDt();
				var dgnDt:DungeonData = DgnDataManager.instance.getDgnDt(manager.dungeonId);
				var complete:int = dgnDt ? dgnDt.daily_enter_count : 0;
				var total:int = cfgDt ? cfgDt.free_count + cfgDt.toll_count : 0;
				str = StringConst.DGN_TOWER_0013 + HtmlUtils.createHtmlStr(0xff0000,complete+"/"+total);
				skin.txtTimes.htmlText = str;
			}
		}
		
		override public function destroy():void
		{
			_skin.removeEventListener(MouseEvent.CLICK,onClick);
			DgnDataManager.instance.detach(this);
			DgnTowerDataManger.instance.detach(this);
			super.destroy();
		}
	}
}