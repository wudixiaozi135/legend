package com.view.gameWindow.panel.panels.dungeonTower
{
	import com.model.configData.cfgdata.DgnEventCfgData;
	import com.model.consts.FontFamily;
	import com.model.consts.StringConst;
	import com.view.gameWindow.util.HtmlUtils;
	import com.view.gameWindow.util.TimeUtils;
	import com.view.gameWindow.util.css.GameStyleSheet;
	import com.view.gameWindow.util.propertyParse.CfgDataParse;
	
	import flash.text.TextField;
	import flash.text.TextFormat;

	internal class PanelDgnTowerInfoAssign
	{
		private var _panel:PanelDgnTowerInfo;
		private var _skin:McDgnTowerInfo;
		
		public function PanelDgnTowerInfoAssign(panel:PanelDgnTowerInfo)
		{
			_panel = panel;
			_skin = _panel.skin as McDgnTowerInfo;
		}
		/**标题文本赋值*/
		internal function assignTxtTitle():void
		{
			var txt:TextField = _skin.txtTitle;
			var defaultTextFormat:TextFormat = txt.defaultTextFormat;
			defaultTextFormat.bold = true;
			txt.defaultTextFormat = defaultTextFormat;
			txt.setTextFormat(defaultTextFormat);
			txt.text = StringConst.DGN_TOWER_0001;
		}
		/**描述文本赋值*/
		internal function assignTxtDesc():void
		{
			var txt:TextField = _skin.txtDesc;
			var cfgDt:DgnEventCfgData = DgnTowerDataManger.instance.dgnEventCfgDt();
			var str:String = cfgDt ? CfgDataParse.pareseDesToStr(cfgDt.step_desc,6) : "";
			txt.htmlText = str;
		}
		/**防御守卫文本赋值*/
		internal function assignTxtDefenses():void
		{
			var manager:DgnTowerDataManger = DgnTowerDataManger.instance;
			var summonCount:int = manager.summonCount;
			var summonTotal:int = manager.summonTotal;
			var str:String = StringConst.DGN_TOWER_0002.replace("&x",summonCount+"/"+summonTotal);
			var txt:TextField = _skin.txtDefenses;
			str = HtmlUtils.createHtmlStr(txt.textColor,str,12,false,6);
			txt.htmlText = str;
		}
		/**购买令牌文本赋值*/
		internal function assignTxtBuy():void
		{
			var txt:TextField = _skin.txtBuy;
			txt.htmlText = HtmlUtils.createHtmlStr(txt.textColor,StringConst.DGN_TOWER_0003,12,false,2,FontFamily.FONT_NAME,true);
		}
		/**波数剩余文本赋值*/
		internal function assignTxtMstInfo():void
		{
			var manager:DgnTowerDataManger = DgnTowerDataManger.instance;
			var step:int = manager.step;
			var stepTotal:int = manager.stepTotal;
			var nMonster:int = manager.nMonster;
			step = step > stepTotal ? stepTotal : step;
			var str:String = StringConst.DGN_TOWER_0004.replace("&x",step+"/"+stepTotal).replace("&y",nMonster);
			var txt:TextField = _skin.txtMstInfo;
			str = HtmlUtils.createHtmlStr(txt.textColor,str,12,false,6);
			txt.htmlText = str;
		}
		/**怪物来袭文本赋值*/
		internal function assignTxtMstComing():void
		{
			var txt:TextField = _skin.txtMstComing;
			txt.text = StringConst.DGN_TOWER_0005;
			/*txt.filters = [UtilColorMatrixFilters.RED_COLOR_FILTER];*/
			txt.alpha = 0;
		}
		/**未领取经验文本赋值*/
		internal function assignTxtExpUnget():void
		{
			var txt:TextField = _skin.txtExpUnget;
			txt.text = StringConst.DGN_TOWER_0006;
		}
		/**未领取经验值文本赋值*/
		internal function assignTxtExpUngetValue():void
		{
			var manager:DgnTowerDataManger = DgnTowerDataManger.instance;
			var expGain:int = manager.expGain;
			var expGainScale:Number = manager.expGainScale;
			//
			var txt:TextField = _skin.txtExpUngetValue;
			txt.text = expGain+"";
			//
			_skin.mcExpUnget.mcMask.scaleX = expGainScale;
		}
		/**遗漏经验文本赋值*/
		internal function assignTxtExpMissed():void
		{
			var txt:TextField = _skin.txtExpMissed;
			txt.text = StringConst.DGN_TOWER_0007;
		}
		/**遗漏经验值文本赋值*/
		internal function assignTxtExpMissedValue():void
		{
			var manager:DgnTowerDataManger = DgnTowerDataManger.instance;
			var expLost:int = manager.expLost;
			var expLostScale:Number = manager.expLostScale;
			//
			var txt:TextField = _skin.txtExpMissedValue;
			txt.text = expLost+"";
			//
			_skin.mcExpMissed.mcMask.scaleX = expLostScale;
		}
		/**按钮文本赋值*/
		internal function assignTxtInBtn():void
		{
			var txt:TextField = _skin.btn.txt;
			if(!txt)
			{
				return;
			}
			var isStart:Boolean = DgnTowerDataManger.instance.isStart;
			if(!isStart)
			{
				txt.text = StringConst.DGN_TOWER_0008;
			}
			else
			{
				txt.text = StringConst.DGN_TOWER_0009;
			}
		}
		/**倒计时文本赋值*/
		internal function assignTxtCountdownTime(remain:int):void
		{
			var time:String = TimeUtils.formatClock1(remain);
			var txt:TextField = _skin.txtCountdownTime;
			txt.text = StringConst.DGN_TOWER_0010 + time;
		}
		/**规则问呗赋值*/
		internal function assignTxtRule():void
		{
			var txt:TextField = _skin.txtRule;
			txt.htmlText = HtmlUtils.createHtmlStr(txt.textColor,StringConst.DGN_TOWER_0048,12,false,2,FontFamily.FONT_NAME,true);
			txt.styleSheet = GameStyleSheet.linkStyle;
		}
	}
}