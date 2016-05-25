package com.view.gameWindow.panel.panels.equipRecycle
{
	import com.model.configData.ConfigDataManager;
	import com.model.configData.cfgdata.NpcCfgData;
	import com.model.configData.cfgdata.VipCfgData;
	import com.model.consts.StringConst;
	import com.model.dataManager.TeleportDatamanager;
	import com.model.gameWindow.rsr.RsrLoader;
	import com.view.gameWindow.panel.PanelConst;
	import com.view.gameWindow.panel.PanelMediator;
	import com.view.gameWindow.panel.panelbase.PanelBase;
	import com.view.gameWindow.panel.panels.McEquipRecycleWarn;
	import com.view.gameWindow.panel.panels.roleProperty.RoleDataManager;
	import com.view.gameWindow.scene.entity.constants.EntityTypes;
	import com.view.gameWindow.scene.entity.entityItem.autoJob.AutoJobManager;
	import com.view.gameWindow.tips.rollTip.RollTipMediator;
	import com.view.gameWindow.tips.rollTip.RollTipType;
	
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.utils.Dictionary;
	
	import mx.utils.StringUtil;
	
	public class PanelEquipRecycleWarn extends PanelBase
	{
		//public var isCanOpen
		public function PanelEquipRecycleWarn()
		{
			super();
		}
		
		override protected function initSkin():void
		{
			var skin:McEquipRecycleWarn = new McEquipRecycleWarn;
			_skin = skin;
			addChild(skin);
			initTxt();
		}
		
		private function initTxt():void
		{
			var skin:McEquipRecycleWarn = _skin as McEquipRecycleWarn;
			skin.txt0.text = StringConst.EQUIPRECYCLE_PANEL_0021;
			skin.txt1.text = StringConst.EQUIPRECYCLE_PANEL_0022
			skin.txt2.text = StringConst.EQUIPRECYCLE_PANEL_0023;
			skin.linkTxt.htmlText = StringConst.EQUIPRECYCLE_PANEL_0024;
			skin.vipTxt.text = StringUtil.substitute(StringConst.EQUIPRECYCLE_PANEL_0025,getVip());
			skin.vipTxt.mouseEnabled = false;
			skin.cancelTxt.text = StringConst.EQUIPRECYCLE_PANEL_0026;
			skin.cancelTxt.mouseEnabled =false;
			skin.linkTxt.addEventListener(MouseEvent.CLICK,onCLick);  
			skin.feixieBtn.buttonMode =true;
			skin.feixieBtn.addEventListener(MouseEvent.CLICK,onCLick);  
		}
		
		private function getVip():int
		{
			var dic:Dictionary = ConfigDataManager.instance.getAllVipCfgData();
			var val:int;
			for each(var vipdata:VipCfgData in dic)
			{
				if(vipdata.recycle_btn)
				{
					val = vipdata.level;
					break;
				}
			}
			return val;
		}
		override protected function addCallBack(rsrLoader:RsrLoader):void
		{
			var skin:McEquipRecycleWarn = _skin as McEquipRecycleWarn;
			rsrLoader.addCallBack(skin.closeBtn,function (mc:MovieClip):void
			{
				mc.addEventListener(MouseEvent.CLICK,onCLick);
			}
			);
			rsrLoader.loadItemRes(skin.feixieBtn.mc);
		 
			rsrLoader.addCallBack(skin.vipBtn,function (mc:MovieClip):void
			{
				mc.addEventListener(MouseEvent.CLICK,onCLick);
				mc.buttonMode =true;
			}
			);
			rsrLoader.addCallBack(skin.cancleBtn,function (mc:MovieClip):void
			{
				mc.addEventListener(MouseEvent.CLICK,onCLick);
				mc.buttonMode =true;
			}
			);
		}
 		
		private function onCLick(e:MouseEvent):void
		{
			var skin:McEquipRecycleWarn = _skin as McEquipRecycleWarn;
			switch(e.target)
			{
				case skin.closeBtn:
				{
					PanelMediator.instance.closePanel(PanelConst.TYPE_EQUIP_RECYCLE_WARN);
					break;
				}
					
				case skin.feixieBtn:
				{
					 
					if(RoleDataManager.instance.isCanFly == 0)
					{
						RollTipMediator.instance.showRollTip(RollTipType.ERROR,StringConst.PROMPT_PANEL_0008);	
						return;
					} 
					 
					var npccfg:NpcCfgData = ConfigDataManager.instance.npcCfgData(10409);
					TeleportDatamanager.instance.requestTeleportPostioin(npccfg.mapid,npccfg.teleport_x,npccfg.teleport_y);
					PanelMediator.instance.closePanel(PanelConst.TYPE_EQUIP_RECYCLE_WARN);
					break;
				}
				case skin.vipBtn:
				{
					PanelMediator.instance.openPanel(PanelConst.TYPE_VIP);
					PanelMediator.instance.closePanel(PanelConst.TYPE_EQUIP_RECYCLE_WARN);
					break;
				}
				case skin.cancleBtn:
				{
					PanelMediator.instance.closePanel(PanelConst.TYPE_EQUIP_RECYCLE_WARN);
					break;
				}
				case skin.linkTxt:
				{
					AutoJobManager.getInstance().setAutoTargetData(10409,EntityTypes.ET_NPC);
					PanelMediator.instance.closePanel(PanelConst.TYPE_EQUIP_RECYCLE_WARN);
					break;
				}
				 
			}
		}
		
		override public function destroy():void
		{
			_skin.closeBtn.removeEventListener(MouseEvent.CLICK,onCLick);
			_skin.feixieBtn.removeEventListener(MouseEvent.CLICK,onCLick);		 
			_skin.vipBtn.removeEventListener(MouseEvent.CLICK,onCLick);	 
			_skin.cancleBtn.removeEventListener(MouseEvent.CLICK,onCLick);
			_skin.linkTxt.removeEventListener(MouseEvent.CLICK,onCLick);  
			super.destroy();
		}
		
	}
}