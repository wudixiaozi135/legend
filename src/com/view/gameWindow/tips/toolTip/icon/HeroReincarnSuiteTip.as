package com.view.gameWindow.tips.toolTip.icon
{
	import com.model.configData.cfgdata.HeroReincarnAttrCfgData;
	import com.model.consts.StringConst;
	import com.view.gameWindow.panel.panels.hero.HeroDataManager;
	import com.view.gameWindow.tips.toolTip.BaseTip;
	import com.view.gameWindow.util.HtmlUtils;
	import com.view.gameWindow.util.propertyParse.CfgDataParse;
	
	import flash.text.TextField;

	public class HeroReincarnSuiteTip extends BaseTip
	{
		public function HeroReincarnSuiteTip()
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
			var curCfg:HeroReincarnAttrCfgData = obj.cur as HeroReincarnAttrCfgData;
			var nextCfg:HeroReincarnAttrCfgData = obj.next as HeroReincarnAttrCfgData;
			var type:int = obj.type as int;

			var title:String=HtmlUtils.createHtmlStr(0xebe85f,StringConst.TIP_REINCARN_001,16);
			addProperty(title,19,10);
			maxHeight=40;
			
			initCurProp(curCfg,type);
			initNextProp(nextCfg,type);
			maxHeight+=8;
			height=maxHeight;
		}
		
		private function initNextProp(nextCfg:HeroReincarnAttrCfgData,type:int):void
		{
			if(nextCfg!=null)
			{
				var levelStr:String = HtmlUtils.createHtmlStr(0xb98448,StringConst.TIP_UPGRADE_004)+HtmlUtils.createHtmlStr(0xa5a5a5,nextCfg.level+"");
				addProperty(levelStr,19,maxHeight);
				maxHeight+=22;
				
				var isComple:Boolean = initDetails(nextCfg,type);
				initAttrs(nextCfg,type,isComple);
			}
		}
		
		private function initCurProp(curCfg:HeroReincarnAttrCfgData,type:int):void
		{
			if(curCfg!=null)
			{
				var levelStr:String = HtmlUtils.createHtmlStr(0xb98448,StringConst.TIP_UPGRADE_002)+HtmlUtils.createHtmlStr(0xecb75e,curCfg.level+"");
				addProperty(levelStr,19,maxHeight);
				maxHeight+=22;
				
				var isComple:Boolean = initDetails(curCfg,type);
				initAttrs(curCfg,type,isComple);
			}
		}
		
		private function initDetails(cfg:HeroReincarnAttrCfgData,type:int):Boolean
		{
			var stateStr:String ="";
			var countText:TextField = addProperty(stateStr,19,maxHeight);
			maxHeight+=22;
			var count:int=getHeroReinCarnState();
			var isComple:Boolean = count>=cfg.level;
			if(isComple)
			{
				countText.htmlText= HtmlUtils.createHtmlStr(0xb7dde8,cfg.name+"  ("+count+"/"+cfg.level+")  ")+HtmlUtils.createHtmlStr(0x46bb39,StringConst.TIP_UPGRADE_003);
			}else
			{
				countText.htmlText= HtmlUtils.createHtmlStr(0xb7dde8,cfg.name+"  ("+count+"/"+cfg.level+")  ")+HtmlUtils.createHtmlStr(0xbfbfbf,StringConst.TIP_UPGRADE_005);
			}
			return isComple;
		}
		
		private function initAttrs(cfg:HeroReincarnAttrCfgData,type:int,isComple:Boolean):void
		{
			var typeName:String;
			var attrs:String;
//			if(cfg.type==1)
//			{
//				if(type==EntityTypes.ET_PLAYER)
//				{
//					typeName=StringConst.ENTITY_TYPE_PLAYER;
//					attrs = cfg.chr_attr;
//				}else
//				{
//					typeName=StringConst.ENTITY_TYPE_HERO;
//					attrs = cfg.hero_attr;
//				}
//			}else
//			{
//				if(type==EntityTypes.ET_PLAYER)
//				{
//					typeName=StringConst.ENTITY_TYPE_HERO;
//					attrs = cfg.hero_attr;
//				}else
//				{
					typeName=StringConst.ENTITY_TYPE_PLAYER;
					attrs = cfg.chr_attr;
//				}
//			}
			var attrsVec:Vector.<String> = CfgDataParse.getAttStringArray(attrs);
			var props:String="";
			
			var color:Number;
			if(isComple)
			{
				color=0xecb75e;
			}else
			{
				color=0xbfbfbf;
			}
			
			for each(var att:String in attrsVec)
			{
				var attHtml:String = HtmlUtils.createHtmlStr(color,typeName+att,12,false,4);
				addProperty(attHtml,19,maxHeight);
				maxHeight+=19;
			}
			maxHeight+=10;
		}
		
		private function getHeroReinCarnState():int
		{
			return HeroDataManager.instance.heroUpgradeData.grade;
		}
		
	}
}