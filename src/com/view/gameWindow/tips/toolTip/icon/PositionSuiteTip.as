package com.view.gameWindow.tips.toolTip.icon
{
	import com.model.configData.ConfigDataManager;
	import com.model.configData.cfgdata.EquipCfgData;
	import com.model.configData.cfgdata.PositionCfgData;
	import com.model.configData.cfgdata.PositionChopCfgData;
	import com.model.consts.StringConst;
	import com.view.gameWindow.panel.panels.hero.HeroDataManager;
	import com.view.gameWindow.panel.panels.position.PositionDataManager;
	import com.view.gameWindow.scene.entity.constants.EntityTypes;
	import com.view.gameWindow.tips.toolTip.BaseTip;
	import com.view.gameWindow.util.HtmlUtils;
	import com.view.gameWindow.util.propertyParse.CfgDataParse;
	
	import flash.text.TextField;

	public class PositionSuiteTip extends BaseTip
	{

		private var chopid:int;
		public function PositionSuiteTip()
		{
			//TODO: implement function
			super();
			_skin = new BigTextTipSkin();
			addChild(_skin);
			initView(_skin);
		}
		
		override public function setData(obj:Object):void
		{
			this._data=obj;
			width=260;
			chopid = obj.chopid as int
			var curLevel:int = obj.curLevel as int;
			var nextLevel:int = obj.nextLevel as int;
			var type:int = obj.type as int

			var title:String=HtmlUtils.createHtmlStr(0xebe85f,StringConst.TIP_POSITION_TIP_001,16);
			addProperty(title,19,10);
			maxHeight=40;
			initPositionProp(chopid);
			
			var position:int = PositionDataManager.instance.position+1;
			var positionCfgData:PositionCfgData = ConfigDataManager.instance.positionCfgData(position);
			if(positionCfgData!=null)
			{
				initNextPositionProp(positionCfgData.chopid);
			}
			
			initCurProp(curLevel,type);
			initNextProp(nextLevel,type);
			maxHeight+=8;
			height=maxHeight;
		}
		
		private function initNextPositionProp(chopid:int):void
		{
			var equipCfgData:EquipCfgData = ConfigDataManager.instance.equipCfgData(chopid);
			if(equipCfgData==null)return;
			
			var name:String = HtmlUtils.createHtmlStr(0xb98448,StringConst.TIP_POSITION_TIP_006)+HtmlUtils.createHtmlStr(0xbfbfbf,equipCfgData.name)
			addProperty(name,19,maxHeight);
			maxHeight+=22;
			
			initQueipAttrs(equipCfgData,false);
		}
		
		private function initPositionProp(chopid:int):void
		{
			var equipCfgData:EquipCfgData = ConfigDataManager.instance.equipCfgData(chopid);
			if(equipCfgData==null)return;
			
			var name:String = HtmlUtils.createHtmlStr(0xb98448,StringConst.TIP_POSITION_TIP_005)+HtmlUtils.createHtmlStr(0xecb75e,equipCfgData.name)
			addProperty(name,19,maxHeight);
			maxHeight+=22;
			
			initQueipAttrs(equipCfgData);
		}
		
		private function initQueipAttrs(equipCfgData:EquipCfgData,isComple:Boolean=true,attrRate:int=100):void
		{
			var attrsVec:Vector.<String> = CfgDataParse.getAttStringArray(equipCfgData.attr,false,attrRate);
			var props:String="";
			
			var color:Number=0;
			if(isComple)
			{
				color=0xecb75e;
			}else
			{
				color=0xbfbfbf;
			}
			for each(var att:String in attrsVec)
			{
				var attHtml:String = HtmlUtils.createHtmlStr(color,att,12,false,4);
				addProperty(attHtml,19,maxHeight);
				maxHeight+=19;
			}
			maxHeight+=10;
		}
		
		private function initNextProp(nextLevel:int,type:int):void
		{
			var positionChopCfgData:PositionChopCfgData = ConfigDataManager.instance.positionChopCfgData(nextLevel);
			if(positionChopCfgData!=null)
			{
				var levelStr:String = HtmlUtils.createHtmlStr(0xb98448,StringConst.TIP_POSITION_TIP_004)+HtmlUtils.createHtmlStr(0xbfbfbf,positionChopCfgData.level+"");
				addProperty(levelStr,19,maxHeight);
				maxHeight+=22;
				
				var attrRate:int = initDetails(positionChopCfgData,false,type);
				initAttrs(attrRate,false);
			}
		}
		
		private function initCurProp(curLevel:int,type:int):void
		{
			var positionChopCfgData:PositionChopCfgData = ConfigDataManager.instance.positionChopCfgData(curLevel);
			if(positionChopCfgData!=null)
			{
				var title2:String=HtmlUtils.createHtmlStr(0xebe85f,StringConst.TIP_POSITION_TIP_007,16);
				addProperty(title2,19,maxHeight);
				maxHeight+=28;
				
				var levelStr:String = HtmlUtils.createHtmlStr(0xb98448,StringConst.TIP_POSITION_TIP_003)+HtmlUtils.createHtmlStr(0xecb75e,positionChopCfgData.level+"");
				addProperty(levelStr,19,maxHeight);
				maxHeight+=22;
				
				 var attrRate:int = initDetails(positionChopCfgData,true,type);
				initAttrs(attrRate,true);
			}
		}
		
		private function initDetails(cfg:PositionChopCfgData,isComple:Boolean,type:int):int
		{
			var stateStr:String ="";
			var countText:TextField = addProperty(stateStr,19,maxHeight);
			maxHeight+=22;
			var attrRate:int=0;
			if(type==EntityTypes.ET_PLAYER)
			{
				attrRate=cfg.chr_attr_rate;
			}else
			{
				attrRate=cfg.hero_attr_rate;
			}
			if(isComple)
			{
				countText.htmlText= HtmlUtils.createHtmlStr(0xb7dde8,StringConst.TIP_POSITION_TIP_002+"  (+"+attrRate+"%)  ")+HtmlUtils.createHtmlStr(0x46bb39,StringConst.TIP_UPGRADE_003);
			}else
			{
				countText.htmlText= HtmlUtils.createHtmlStr(0xb7dde8,StringConst.TIP_POSITION_TIP_002+"  (+"+attrRate+"%)  ")+HtmlUtils.createHtmlStr(0xbfbfbf,StringConst.TIP_UPGRADE_005);
			}
			return attrRate;
		}
		
		private function initAttrs(attrRate:int,isComple:Boolean):void
		{
			var equipCfgData:EquipCfgData = ConfigDataManager.instance.equipCfgData(chopid);
			if(equipCfgData==null)return;
				initQueipAttrs(equipCfgData,isComple,attrRate);
		}
		
		private function getHeroReinCarnState():int
		{
			return HeroDataManager.instance.heroUpgradeData.grade;
		}
		
	}
}