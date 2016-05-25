package com.view.gameWindow.panel.panels.activitys.loongWar.tabInfo
{
	import com.model.consts.FontFamily;
	import com.model.consts.StringConst;
	import com.model.consts.ToolTipConst;
	import com.view.gameWindow.mainUi.subuis.activityTrace.ActivityDataManager;
	import com.view.gameWindow.panel.panels.activitys.loongWar.LoongWarDataManager;
	import com.view.gameWindow.tips.toolTip.ToolTipManager;
	import com.view.gameWindow.util.HtmlUtils;
	import com.view.gameWindow.util.ServerTime;
	
	import flash.display.MovieClip;
	import flash.text.TextField;

	public class TabLoongWarInfoViewHandle
	{
		private var _tab:TabLoongWarInfo;
		private var _skin:McLoongWarInfo;
		
		private var _modeHandles:Vector.<TabLoongWarInfoModeHandle>;
		
		public function TabLoongWarInfoViewHandle(tab:TabLoongWarInfo)
		{
			_tab = tab;
			_skin = tab.skin as McLoongWarInfo;
			initialize();
		}
		
		private function initialize():void
		{
			var manager:LoongWarDataManager = ActivityDataManager.instance.loongWarDataManager;
			//
			_skin.mcRule.visible = false;
			_skin.mcRule.txtTitle0.text = StringConst.LOONG_WAR_0002;
			_skin.mcRule.txtTitle1.text = StringConst.LOONG_WAR_0004;
			_skin.mcRule.txtTitle2.text = StringConst.LOONG_WAR_0006;
			_skin.mcRule.txtTitle3.text = StringConst.LOONG_WAR_0008;
			_skin.mcRule.txtTitle4.text = StringConst.LOONG_WAR_0010;
			_skin.mcRule.txtTitle5.text = StringConst.LOONG_WAR_0012;
			_skin.mcRule.txtTitle6.text = StringConst.LOONG_WAR_0014;
			_skin.mcRule.txtTitle7.text = StringConst.LOONG_WAR_0016;
			_skin.mcRule.txt0.htmlText = StringConst.LOONG_WAR_0003.replace("&x",manager.nextFullTime);
			_skin.mcRule.txt1.htmlText = StringConst.LOONG_WAR_0005;
			_skin.mcRule.txt2.htmlText = StringConst.LOONG_WAR_0007;
			_skin.mcRule.txt3.htmlText = StringConst.LOONG_WAR_0009;
			_skin.mcRule.txt4.htmlText = StringConst.LOONG_WAR_0011;
			_skin.mcRule.txt5.htmlText = StringConst.LOONG_WAR_0013;
			_skin.mcRule.txt6.htmlText = StringConst.LOONG_WAR_0015;
			_skin.mcRule.txt7.htmlText = StringConst.LOONG_WAR_0017;
			//
			_skin.txtFamilyName.text = StringConst.LOONG_WAR_0018;
			_skin.txtCityName.text = StringConst.LOONG_WAR_0019;
			_skin.txtDays.text = StringConst.LOONG_WAR_0020;
			_skin.txtDays0.text = StringConst.LOONG_WAR_0021;
			_skin.txtTime.text = StringConst.LOONG_WAR_0024;
			_skin.txtBtnRule.text = StringConst.LOONG_WAR_0025;
			_skin.txtBtnRule.mouseEnabled = false;
			_skin.txtBtnGoto.text = StringConst.LOONG_WAR_0026;
			_skin.txtBtnGoto.mouseEnabled = false;
			_skin.txtBtnChange.text = StringConst.LOONG_WAR_0027;
			_skin.txtBtnChange.mouseEnabled = false;
			//
			_modeHandles = new Vector.<TabLoongWarInfoModeHandle>(manager.countPosition,true);
		}
		
		public function update():void
		{
			var manager:LoongWarDataManager = ActivityDataManager.instance.loongWarDataManager;
			_skin.txtFamilyNameValue.text = manager.familyNameDefense;
			_skin.txtCityNameValue.text = manager.nameCity ? manager.nameCity : StringConst.POSITION_PANEL_0026;
			_skin.txtDaysValue.text = manager.time ? int((ServerTime.time - manager.time) / 86400) + "" : "0";
			//
			var i:int,l:int = manager.countPosition;
			for (i=0;i<l;i++) 
			{
				var dt:DataLoongWarInfo = manager.dtsPositionInfo[i+1] as DataLoongWarInfo;
				var txt:TextField = _skin["txtTitle"+i] as TextField;
				var str:String = HtmlUtils.createHtmlStr(txt.textColor,StringConst.LOONG_WAR_0023,12,false,2,FontFamily.FONT_NAME,true);
				var text:String = manager.isLoongWarChatelain ? str : StringConst.LOONG_WAR_0022;
				txt.htmlText = dt ? dt.namePlayer : text;
				txt.mouseEnabled = manager.isLoongWarChatelain && !dt;
				//
				var layer:MovieClip = _skin["mcLayer"+i];
				if(!_modeHandles[i])
				{
					_modeHandles[i] = new TabLoongWarInfoModeHandle(layer,i+1);
				}
				_modeHandles[i].changeModel();
				if(dt)
				{
					layer = _skin["mcMouse"+i];
					layer.dt = dt;
					ToolTipManager.getInstance().attachByTipVO(layer,ToolTipConst.TEXT_TIP,funcTipData(dt));
				}
				else
				{
					ToolTipManager.getInstance().detach(layer);
				}
			}
			//
			_skin.txtTimeValue.text = manager.nextFullTime;
			//
			_skin.btnChange.btnEnabled = manager.isLoongWarChatelain;
		}
		
		private function funcTipData(dt:DataLoongWarInfo):Function
		{
			var func:Function = function():String
			{
				var str:String = "";
				str += HtmlUtils.createHtmlStr(0xffe1aa,"         " + dt.namePlayer + "         \n",14,true,6);
				str += HtmlUtils.createHtmlStr(0xd5b300,StringConst.LOONG_WAR_0028,12,false,6);
				var familyNameDefense:String = ActivityDataManager.instance.loongWarDataManager.familyNameDefense;
				str += HtmlUtils.createHtmlStr(0xb4b4b4,familyNameDefense + "\n",12,false,6);
				str += HtmlUtils.createHtmlStr(0xd5b300,StringConst.LOONG_WAR_0066,12,false,6);
				str += HtmlUtils.createHtmlStr(0xb4b4b4,dt.level + "\n",12,false,6);
				str += HtmlUtils.createHtmlStr(0xd5b300,StringConst.LOONG_WAR_0067,12,false,6);
				str += HtmlUtils.createHtmlStr(0xb4b4b4,dt.fightPower + "\n",12,false,6);
				return str;
			}
			return func;
		}
		
		public function destroy():void
		{
			var manager:LoongWarDataManager = ActivityDataManager.instance.loongWarDataManager;
			var i:int,l:int = manager.countPosition;
			for (i=0;i<l;i++) 
			{
				var modeHandle:TabLoongWarInfoModeHandle = _modeHandles[i];
				if(modeHandle)
				{
					var layer:MovieClip = _skin["mcMouse"+i];
					ToolTipManager.getInstance().detach(layer);
					modeHandle.destroy();
				}
			}
			_modeHandles = null;
			_skin = null;
			_tab = null;
		}
	}
}