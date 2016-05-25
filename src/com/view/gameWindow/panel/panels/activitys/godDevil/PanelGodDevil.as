package com.view.gameWindow.panel.panels.activitys.godDevil
{
	import com.model.configData.ConfigDataManager;
	import com.model.configData.cfgdata.ActivityCfgData;
	import com.model.configData.cfgdata.MapCfgData;
	import com.model.configData.cfgdata.MapRegionCfgData;
	import com.model.configData.cfgdata.NpcCfgData;
	import com.model.configData.cfgdata.NpcTeleportCfgData;
	import com.model.consts.FontFamily;
	import com.model.consts.StringConst;
	import com.model.dataManager.TeleportDatamanager;
	import com.view.gameWindow.mainUi.subuis.activityTrace.ActivityDataManager;
	import com.view.gameWindow.mainUi.subuis.activityTrace.constants.ActivityFuncTypes;
	import com.view.gameWindow.panel.PanelConst;
	import com.view.gameWindow.panel.PanelMediator;
	import com.view.gameWindow.panel.panelbase.PanelBase;
	import com.view.gameWindow.panel.panels.bag.BagDataManager;
	import com.view.gameWindow.panel.panels.hero.HeroDataManager;
	import com.view.gameWindow.util.HtmlUtils;
	import com.view.gameWindow.util.propertyParse.CfgDataParse;
	
	import flash.events.MouseEvent;
	import flash.text.TextFormat;
	import flash.utils.Dictionary;
	
	/**
	 * 省委魔域面板类
	 * @author Administrator
	 */	
	public class PanelGodDevil extends PanelBase
	{
		public function PanelGodDevil()
		{
			super();
		}
		
		override protected function initSkin():void
		{
			var skin:McGodDevil = new McGodDevil();
			_skin = skin;
			addChild(_skin);
		}
		
		override protected function initData():void
		{
			var skin:McGodDevil = _skin as McGodDevil;
			setTitleBar(skin.mcDrag);
			//
			var activityCfgData:ActivityCfgData = ConfigDataManager.instance.activityCfgData2(ActivityFuncTypes.AFT_GOD_DEVIL);
			skin.txtTitle.text = activityCfgData.name;
			var defaultTextFormat:TextFormat = skin.txtTitle.defaultTextFormat;
			defaultTextFormat.bold = true;
			skin.txtTitle.defaultTextFormat = defaultTextFormat;
			skin.txtTitle.setTextFormat(defaultTextFormat);
			//
			var npcId:int = args[0] as int;
			var npcCfgData:NpcCfgData = ConfigDataManager.instance.npcCfgData(npcId);
			var textColor:uint = skin.txtDesc.textColor;
			var leading:int = skin.txtDesc.defaultTextFormat.leading as int;
			skin.txtDesc.htmlText = CfgDataParse.pareseDesToStr(npcCfgData.default_dialog,textColor,leading);
			//
			var npcTeleportCfgDatas:Dictionary = ConfigDataManager.instance.npcTeleportCfgDatas(npcId);
			var npcTeleportCfgData:NpcTeleportCfgData;
			for each(npcTeleportCfgData in npcTeleportCfgDatas)
			{
				if(!npcTeleportCfgData)
				{
					continue;
				}
				var mapRegionCfgData:MapRegionCfgData = npcTeleportCfgData.mapRegionCfgData;
				if(!mapRegionCfgData)
				{
					continue;
				}
				var mapCfgData:MapCfgData = mapRegionCfgData.mapCfgData;
				if(!mapCfgData)
				{
					continue;
				}
				textColor = skin.txtNext.textColor;
				leading = skin.txtNext.defaultTextFormat.leading as int;
				skin.txtNext.htmlText = CfgDataParse.pareseDesToStr(mapCfgData.desc,textColor,leading);
			}
			//
			if(mapCfgData)
			{
				var string:String = StringConst.GOD_DEVIL_0001 + mapCfgData.name;
				skin.txtBtn.htmlText = HtmlUtils.createHtmlStr(skin.txtBtn.textColor,string,12,false,2,FontFamily.FONT_NAME,true);
			}
			//
			if(npcTeleportCfgData && npcTeleportCfgData.itemCfgData)
			{
				string = StringConst.GOD_DEVIL_0002 + npcTeleportCfgData.itemCfgData.name + StringConst.COLON;
				string += HtmlUtils.createHtmlStr(0x00ff00,npcTeleportCfgData.item_count+StringConst.GOD_DEVIL_0003);
				var count:int = BagDataManager.instance.getItemNumById(npcTeleportCfgData.item);
				count += HeroDataManager.instance.getItemNumById(npcTeleportCfgData.item);
				string += StringConst.GOD_DEVIL_0004.replace("&x",HtmlUtils.createHtmlStr(0x00ff00,count+""));
				skin.txtCost.htmlText = string;
			}
			//
			skin.addEventListener(MouseEvent.CLICK,onClick);
		}
		
		protected function onClick(event:MouseEvent):void
		{
			var activityCfgData:ActivityCfgData = ConfigDataManager.instance.activityCfgData2(ActivityFuncTypes.AFT_GOD_DEVIL);
			if(!activityCfgData)
			{
				trace("PanelGodDevil.onClick(event) 配置数据错误");
				return;
			}
			var npcId:int = args[0] as int;
			var skin:McGodDevil = _skin as McGodDevil;
			if(event.target == skin.txtBtn)
			{
				if(activityCfgData.npc == npcId)
				{
					enterActv();
				}
				else
				{
					mapTeleport();
				}
			}
			else if(event.target == skin.btnClose)
			{
				PanelMediator.instance.closePanel(PanelConst.TYPE_GOD_DEVIL);
			}
		}
		
		private function enterActv():void
		{
			ActivityDataManager.instance.enterActivity(ActivityFuncTypes.AFT_GOD_DEVIL);
		}
		
		private function mapTeleport():void
		{
			var npcId:int = args[0] as int;
			TeleportDatamanager.instance.requestTeleportNpcNeedCheck(npcId);
		}
		
		override public function destroy():void
		{
			skin.removeEventListener(MouseEvent.CLICK,onClick);
			super.destroy();
		}
	}
}