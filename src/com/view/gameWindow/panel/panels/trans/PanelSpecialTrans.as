package com.view.gameWindow.panel.panels.trans
{
	import com.model.configData.ConfigDataManager;
	import com.model.configData.cfgdata.MapCfgData;
	import com.model.configData.cfgdata.MapRegionCfgData;
	import com.model.configData.cfgdata.NpcCfgData;
	import com.model.configData.cfgdata.NpcTeleportCfgData;
	import com.model.consts.FontFamily;
	import com.model.consts.StringConst;
	import com.model.dataManager.TeleportDatamanager;
	import com.view.gameWindow.panel.PanelConst;
	import com.view.gameWindow.panel.PanelMediator;
	import com.view.gameWindow.panel.panelbase.PanelBase;
	import com.view.gameWindow.panel.panels.activitys.godDevil.McGodDevil;
	import com.view.gameWindow.panel.panels.bag.BagDataManager;
	import com.view.gameWindow.panel.panels.guideSystem.InterObjCollector;
	import com.view.gameWindow.panel.panels.hero.HeroDataManager;
	import com.view.gameWindow.panel.panels.task.linkText.LinkTextClickHandle;
	import com.view.gameWindow.util.HtmlUtils;
	import com.view.gameWindow.util.propertyParse.CfgDataParse;
	
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.text.TextFormat;
	import flash.utils.Dictionary;
	
	/**
	 * 特殊传送面板类
	 * @author Administrator
	 */	
	public class PanelSpecialTrans extends PanelBase
	{

		private var _linkTextClickHandle:LinkTextClickHandle;
		public function PanelSpecialTrans()
		{
			super();
		}
		
		override protected function initSkin():void
		{
			var skin:McGodDevil = new McGodDevil();
			_skin = skin;
			addChild(_skin);
			
			InterObjCollector.instance.add(_skin.txtBtn,"",new Point(2,2));
		}
		
		override protected function initData():void
		{
			var skin:McGodDevil = _skin as McGodDevil;
			setTitleBar(skin.mcDrag);
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
				if(!_linkTextClickHandle)
				{
					_linkTextClickHandle = new LinkTextClickHandle(skin.txtNext);
				}
				var pareseDesToStr:String = CfgDataParse.pareseDesToStr(mapCfgData.desc,textColor,leading);
				_linkTextClickHandle.linkText.init(pareseDesToStr);
				skin.txtNext.htmlText = _linkTextClickHandle.linkText.htmlText;
			}
			//
			skin.txtTitle.text = npcTeleportCfgData.name;
			var defaultTextFormat:TextFormat = skin.txtTitle.defaultTextFormat;
			defaultTextFormat.bold = true;
			skin.txtTitle.defaultTextFormat = defaultTextFormat;
			skin.txtTitle.setTextFormat(defaultTextFormat);
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
			var skin:McGodDevil = _skin as McGodDevil;
			if(event.target == skin.txtBtn)
			{
				var npcId:int = args[0] as int;
				TeleportDatamanager.instance.requestTeleportNpcNeedCheck(npcId);
			}
			else if(event.target == skin.btnClose)
			{
				PanelMediator.instance.closePanel(PanelConst.TYPE_SPECIAL_TRANS);
			}
		}
		
		override public function destroy():void
		{
			_linkTextClickHandle.destory();
			skin.removeEventListener(MouseEvent.CLICK,onClick);
			InterObjCollector.instance.remove(_skin.txtBtn);
			super.destroy();
		}
	}
}