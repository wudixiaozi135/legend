package com.view.gameWindow.panel.panels.activitys
{
	import com.model.configData.ConfigDataManager;
	import com.model.configData.cfgdata.ActivityCfgData;
	import com.model.configData.cfgdata.ActivityMapRegionCfgData;
	import com.model.configData.cfgdata.MapCfgData;
	import com.model.configData.cfgdata.NpcCfgData;
	import com.model.consts.StringConst;
	import com.model.gameWindow.rsr.RsrLoader;
	import com.view.gameWindow.mainUi.subuis.activityTrace.ActivityDataManager;
	import com.view.gameWindow.mainUi.subuis.activityTrace.constants.ActivityFuncTypes;
	import com.view.gameWindow.panel.PanelConst;
	import com.view.gameWindow.panel.PanelMediator;
	import com.view.gameWindow.panel.panelbase.PanelBase;
	import com.view.gameWindow.util.propertyParse.CfgDataParse;
	
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	/**
	 * 活动进入面板类
	 * @author Administrator
	 */	
	public class PanelActivityEnter extends PanelBase
	{
		public function PanelActivityEnter()
		{
			super();
		}
		
		override protected function initSkin():void
		{
			var skin:McActivityEnter = new McActivityEnter();
			_skin = skin;
			addChild(_skin);
		}
		
		override protected function addCallBack(rsrLoader:RsrLoader):void
		{
			var skin:McActivityEnter = _skin as McActivityEnter;
			rsrLoader.addCallBack(skin.btn,function(mc:MovieClip):void
			{
				var str:String = "";
				switch(activityCfgData.func_type)
				{
					case ActivityFuncTypes.AFT_SEA_SIDE:
						str = StringConst.ACTV_ENTER_0101;
						break;
					/*case ActivityFuncTypes.AFT_NIGHT_FIGHT:
						str = StringConst.ACTV_ENTER_0101;
						break;*/
					default:
						str = StringConst.ACTV_ENTER_0100;
						break;
				}
				var txt:TextField = mc.txt as TextField;
				txt.text = str;
			});
		}
		
		private function get activityCfgData():ActivityCfgData
		{
			var npcId:int = args.length ? args[0] : 0;
			var activityCfgData:ActivityCfgData = ConfigDataManager.instance.activityCfgData1(npcId);
			return activityCfgData;
		}
		
		override protected function initData():void
		{
			setTitleBar(skin.mcDrag);
			initText();
			_skin.addEventListener(MouseEvent.CLICK,onClick);
		}
		
		private function initText():void
		{
			var skin:McActivityEnter = _skin as McActivityEnter;
			var cfgDt:ActivityCfgData = activityCfgData;
			//标题
			var defaultTextFormat:TextFormat = skin.txtTitle.defaultTextFormat;
			defaultTextFormat.bold = true;
			skin.txtTitle.defaultTextFormat = defaultTextFormat;
			skin.txtTitle.setTextFormat(defaultTextFormat);
			skin.txtTitle.text = cfgDt.name;
			//npc描述
			var npcCfgDt:NpcCfgData = cfgDt ? ConfigDataManager.instance.npcCfgData(cfgDt.npc) : null;
			var textColor:uint = skin.txtNpcDesc.textColor;
			var leading:int = skin.txtNpcDesc.defaultTextFormat.leading as int;
			var str:String = npcCfgDt ? CfgDataParse.pareseDesToStr(npcCfgDt.default_dialog,textColor,leading) : "";
			skin.txtNpcDesc.htmlText = str;
			//地图描述
			var activityMapRegionCfgData:ActivityMapRegionCfgData;
			for each(activityMapRegionCfgData in activityCfgData.actvMapRegionCfgDts)
			{
				if(!activityMapRegionCfgData)
				{
					continue;
				}
				var mapCfgData:MapCfgData = activityMapRegionCfgData.mapCfgData;
				if(!mapCfgData)
				{
					continue;
				}
				if(!mapCfgData.desc)
				{
					continue;
				}
				textColor = skin.txtMapDesc.textColor;
				leading = skin.txtMapDesc.defaultTextFormat.leading as int;
				str = CfgDataParse.pareseDesToStr(mapCfgData.desc,textColor,leading);
				skin.txtMapDesc.htmlText = str;
			}
		}
		
		protected function onClick(event:MouseEvent):void
		{
			var skin:McActivityEnter = _skin as McActivityEnter;
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
			}
		}
		
		private function dealBtn():void
		{
			var cfgDt:ActivityCfgData = activityCfgData;
			if(!cfgDt)
			{
				trace("PanelActivityEnter.dealBtn() 配置数据错误");
				return;
			}
			ActivityDataManager.instance.enterActivity(cfgDt.func_type);
		}
		
		private function dealBtnClose():void
		{
			PanelMediator.instance.closePanel(PanelConst.TYPE_ACTIVITY_ENTER);
		}
		
		override public function update(proc:int=0):void
		{
			
		}
		
		override public function destroy():void
		{
			_skin.removeEventListener(MouseEvent.CLICK,onClick);
			super.destroy();
		}
	}
}