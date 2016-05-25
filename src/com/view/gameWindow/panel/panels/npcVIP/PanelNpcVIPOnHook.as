package com.view.gameWindow.panel.panels.npcVIP
{
	import com.model.configData.ConfigDataManager;
	import com.model.configData.cfgdata.MapVipCfgData;
	import com.model.configData.cfgdata.NpcCfgData;
	import com.model.consts.StringConst;
	import com.view.gameWindow.common.Alert;
	import com.view.gameWindow.panel.PanelConst;
	import com.view.gameWindow.panel.PanelMediator;
	import com.view.gameWindow.panel.panelbase.PanelBase;
	import com.view.gameWindow.panel.panels.npcfunc.PanelNpcFuncData;
	import com.view.gameWindow.panel.panels.roleProperty.RoleDataManager;
	import com.view.gameWindow.panel.panels.vip.VipDataManager;
	import com.view.gameWindow.scene.GameFlyManager;
	import com.view.gameWindow.util.HtmlUtils;
	import com.view.gameWindow.util.TimeUtils;
	import com.view.gameWindow.util.css.GameStyleSheet;
	import com.view.gameWindow.util.propertyParse.CfgDataParse;
	
	import flash.events.MouseEvent;
	import flash.events.TextEvent;
	
	import mx.utils.StringUtil;
	
	public class PanelNpcVIPOnHook extends PanelBase
	{
		public function PanelNpcVIPOnHook()
		{
			super();
		}
		
		override public function destroy():void
		{
			skin.removeEventListener(MouseEvent.CLICK,onClickFunc);
			skin.txt1.removeEventListener(TextEvent.LINK,onClickLink);
			super.destroy();
		}
		
		override protected function initSkin():void
		{
			var skin:MCVIPOnHook = new MCVIPOnHook();
			_skin = skin;
			addChild(_skin);
			setTitleBar(_skin.mcTitleBar);
			_skin.txtNpcName.htmlText=HtmlUtils.createHtmlStr(0xFFE1AA,StringConst.VIP_ON_HOOK_0001,14,true);
			initText();
			skin.addEventListener(MouseEvent.CLICK,onClickFunc);
			skin.txt1.addEventListener(TextEvent.LINK,onClickLink);
		}
		
		protected function onClickFunc(event:MouseEvent):void
		{
			if(event.target==_skin.btnClose)
			{
				PanelMediator.instance.switchPanel(PanelConst.TYPE_VIP_GUAJI);
			}
		}
		
		protected function onClickLink(event:TextEvent):void
		{
			var id:int = int(event.text);
			var mapVipCfgData:MapVipCfgData = ConfigDataManager.instance.mapVipCfgData(id);
			if(mapVipCfgData==null)
			{
				return;
			}
			
			var isNoTime:Boolean = TimeUtils.checkTime(mapVipCfgData.start_time,mapVipCfgData.duration);
			
			if (isNoTime)
			{
				Alert.warning(StringConst.VIP_ON_HOOK_0005);
				return;
			}
			
			if(VipDataManager.instance.lv<mapVipCfgData.vip)
			{
				Alert.warning(StringConst.VIP_ON_HOOK_0003);
				return;
			}
			if(RoleDataManager.instance.lv<mapVipCfgData.level)
			{
				Alert.warning(StringConst.VIP_ON_HOOK_0004);
				return;
			}
			GameFlyManager.getInstance().flyToVIPMapByMapId(mapVipCfgData.map_id);
		}
		
		private function initText():void
		{
			var npcId:int = PanelNpcFuncData.npcId;
			var npcCfgData:NpcCfgData = ConfigDataManager.instance.npcCfgData(npcId);
			_skin.txtDialog.htmlText=CfgDataParse.pareseDes(npcCfgData.default_dialog);
			_skin.txt1.styleSheet=GameStyleSheet.linkStyle;
			
			var mapVipCfgDataArray:Array = ConfigDataManager.instance.mapVipCfgDataArray();
			var len:uint = mapVipCfgDataArray.length;
			var textStr:String="";
			for(var i:int=0;i<len;i++)
			{
				var cfgData:MapVipCfgData= mapVipCfgDataArray[i] as MapVipCfgData;
				var linkText:String = HtmlUtils.createHtmlStr(0xd4a460,"<u>"+cfgData.name+"</u>",12,false,2,"SimSun",true,cfgData.id+"");
				linkText+=HtmlUtils.createHtmlStr(0x00ff00,StringUtil.substitute(StringConst.VIP_ON_HOOK_0002,cfgData.level,cfgData.vip))+"\n\n";
				
				textStr+=linkText;
			}
			
			_skin.txt1.htmlText=textStr;
		}
		
		override public function update(proc:int=0):void
		{
			super.update(proc);
		}
		
	}
}