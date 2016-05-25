package com.view.gameWindow.panel.panels.specialRing.dungeon
{
	import com.greensock.TweenLite;
	import com.greensock.easing.Cubic;
	import com.greensock.plugins.ShortRotationPlugin;
	import com.greensock.plugins.TransformAroundCenterPlugin;
	import com.greensock.plugins.TransformAroundPointPlugin;
	import com.greensock.plugins.TweenPlugin;
	import com.model.configData.cfgdata.DungeonCfgData;
	import com.model.consts.EffectConst;
	import com.model.consts.FontFamily;
	import com.model.consts.StringConst;
	import com.model.consts.ToolTipConst;
	import com.view.gameWindow.common.HighlightEffectManager;
	import com.view.gameWindow.panel.panels.daily.DailyDataManager;
	import com.view.gameWindow.panel.panels.specialRing.SpecialRingDataManager;
	import com.view.gameWindow.tips.toolTip.TipVO;
	import com.view.gameWindow.tips.toolTip.ToolTipManager;
	import com.view.gameWindow.util.HtmlUtils;
	import com.view.gameWindow.util.UIEffectLoader;
	import com.view.gameWindow.util.UtilItemParse;
	import com.view.gameWindow.util.css.GameStyleSheet;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.text.TextFormat;

	/**
	 * 特戒副本页显示处理类
	 * @author Administrator
	 */	
	public class TabSpecialRingDgnViewHandle
	{
		private var _tab:TabSpecialRingDungeon;
		private var _skin:McSpecialRingDungeon;
		private var _cell:RoleCell;
		public var beginRota:Boolean;
		public var btnOk:Boolean;
		private const rate:Array=[330,270,210,90,30,150];
		private const pointArr:Array=[[50,20],[50,117],[50,236],[50,372],[165,370],[307,371],[435,364],[574,371],[707,364],[710,238],[707,115]];
		private var _btnEffectContainer:Sprite;
		private var _btnEffect:UIEffectLoader;
		private var _highlightEffect:HighlightEffectManager;
		
		
		public function TabSpecialRingDgnViewHandle(tab:TabSpecialRingDungeon)
		{
			_tab = tab;
			_skin = _tab.skin as McSpecialRingDungeon;
			init();
			addDungeonTip();
			addVitTip();
			addRuleTip();
		}
		
		private function init():void
		{
			var textColor:uint = _skin.txtWantVit.textColor;
			_skin.txtWantVit.htmlText = HtmlUtils.createHtmlStr(textColor,StringConst.SPECIAL_RING_PANEL_0017,12,false,2,FontFamily.FONT_NAME,true);
			_skin.txtWantVit.styleSheet = GameStyleSheet.linkStyle;
			_skin.txtRule.text = StringConst.SPECIAL_RING_PANEL_0018;
			var defaultTextFormat:TextFormat = _skin.txtRule.defaultTextFormat;
			defaultTextFormat.underline = true;
			_skin.txtRule.defaultTextFormat = defaultTextFormat;
			_skin.txtRule.setTextFormat(defaultTextFormat);
			_skin.txtRollCost.text = StringConst.SPECIAL_RING_PANEL_0019;
			_skin.txtRollCostValue.text = StringConst.SPECIAL_RING_PANEL_0022;
			_cell = new RoleCell(_skin.mcIconLayer);
			_highlightEffect = new HighlightEffectManager();
			addEffect();
		}
		
		private function addEffect():void
		{
			_skin.addChild(_btnEffectContainer = new Sprite());
			_btnEffectContainer.mouseEnabled = false;
			_btnEffectContainer.mouseChildren = false;
			_btnEffect = new UIEffectLoader(_btnEffectContainer, 0, 0, 1, 1, EffectConst.RES_WELFARE_EFFECT);
			_btnEffectContainer.x = _skin.btn.x - ((160 - _skin.btn.width) >> 1);
			_btnEffectContainer.y = _skin.btn.y - ((80 - _skin.btn.height) >> 1) - 2;
			_btnEffectContainer.visible = false;
		}
		
		private function addDungeonTip():void
		{
			var manager:SpecialRingDataManager = SpecialRingDataManager.instance;
			var i:int,l:int = 5;
			for(i=0;i<l;i++)
			{
				var cell:int = 2*i+1;
				var cfgData:DungeonCfgData = manager.getDungeonCfgData(cell);
				if(cfgData)
				{
					var tipVO:TipVO = new TipVO();
					tipVO.tipType = ToolTipConst.TEXT_TIP;
					var str:String = StringConst.SPECIAL_RING_PANEL_0027 + "\n" + cfgData.desc + "\n\n";
					var itemStr:Array = UtilItemParse.getItemString(cfgData.finally_reward);
					str += StringConst.SPECIAL_RING_PANEL_0028 + "\n" + itemStr[1]+"*"+itemStr[2] + "\n\n";
					str += StringConst.SPECIAL_RING_PANEL_0029 + "\n" + cfgData.player_daily_vit + StringConst.SPECIAL_RING_PANEL_0030;
					str = HtmlUtils.createHtmlStr(0x5b436,str);
					tipVO.tipData = str;
					var mcEnter:MovieClip = _skin["mcEnter"+i] as MovieClip;
					ToolTipManager.getInstance().hashTipInfo(mcEnter,tipVO);
					ToolTipManager.getInstance().attach(mcEnter);
				}
				else
				{
					trace("ViewHandle.addDungeonTip 副本配置信息不存在");
				}
			}
		}
		
		private function addVitTip():void
		{
			var tipVO:TipVO = new TipVO();
			tipVO.tipType = ToolTipConst.TEXT_TIP;
			tipVO.tipData = getVitTipData;
			ToolTipManager.getInstance().hashTipInfo(_skin.txtVitValue,tipVO);
			ToolTipManager.getInstance().attach(_skin.txtVitValue);
		}
		
		private function getVitTipData():String
		{
			var str:String = "";
			var manager:DailyDataManager = DailyDataManager.instance;
			str += StringConst.SPECIAL_RING_PANEL_0016 + manager.player_daily_vit+"/"+manager.daily_vit_max+"\n";
			str += StringConst.SPECIAL_RING_PANEL_0021;
			str = HtmlUtils.createHtmlStr(0x53b436,str);
			return str;
		}
		
		private function addRuleTip():void
		{
			var tipVO:TipVO = new TipVO();
			tipVO.tipType = ToolTipConst.TEXT_TIP;
			var str:String = HtmlUtils.createHtmlStr(0x5b436,StringConst.SPECIAL_RING_PANEL_0023);
			tipVO.tipData = str;
			ToolTipManager.getInstance().hashTipInfo(_skin.txtRule,tipVO);
			ToolTipManager.getInstance().attach(_skin.txtRule);
		}
		
		internal function refreshIcon():void
		{
			_cell.refreshData();
			setRota();
		}
		
		internal function setRota():void
		{
			var manager:SpecialRingDataManager = SpecialRingDataManager.instance;
			var dungeon_index:int = manager.dungeon_index;
			var rotation:int=1080;
			if(dungeon_index>0&&beginRota)
			{
				_skin.btn.mouseEnabled=_skin.btn.mouseChildren=false;
				rotation+=rate[dungeon_index-1]+Math.random()*60;
				TweenPlugin.activate([TransformAroundCenterPlugin, ShortRotationPlugin, TransformAroundPointPlugin]);
				manager.dungeon_index=0;
				TweenLite.to(_skin.mcRate, 3, {transformAroundCenter:{rotation:rotation}, ease:Cubic.easeInOut,onComplete:setIcon});
			}else
			{
				setIcon();
			}
		}
		
		private function setIcon():void
		{
			_skin.btn.mouseEnabled=_skin.btn.mouseChildren=true;
			var manager:SpecialRingDataManager = SpecialRingDataManager.instance;
			var dungeon_point:int = manager.dungeon_point;
			_skin.mcIconLayer.x=pointArr[dungeon_point][0];
			_skin.mcIconLayer.y=pointArr[dungeon_point][1];
			
			showBtnHighlightEffect(dungeon_point);
			
			var cfgData:DungeonCfgData = manager.getDungeonCfgData();
			if(cfgData)
			{
				_skin.txtEnterCost.text = StringConst.SPECIAL_RING_PANEL_0020.replace("&x",cfgData.name);
				_skin.txtEnterCostValue.text = cfgData.player_daily_vit+StringConst.SPECIAL_RING_PANEL_0024;
			}
			else
			{
				_skin.txtEnterCost.text = "";
				_skin.txtEnterCostValue.text = "";
			}
			refershBtn();
		}
		
		private function showBtnHighlightEffect(dungeon_point:int):void
		{
			if(_skin.mcNote1.hasOwnProperty("load")==false||
				_skin.mcNote2.hasOwnProperty("load")==false||
				_skin.mcNote3.hasOwnProperty("load")==false||
				_skin.mcNote4.hasOwnProperty("load")==false||
				_skin.mcNote5.hasOwnProperty("load")==false)
				return;
			_highlightEffect.hide(_skin.mcNote1);
			_highlightEffect.hide(_skin.mcNote2);
			_highlightEffect.hide(_skin.mcNote3);
			_highlightEffect.hide(_skin.mcNote4);
			_highlightEffect.hide(_skin.mcNote5);
			if(dungeon_point==2)
			{
				_highlightEffect.show(_skin,_skin.mcNote1);
			}
			else if(dungeon_point==4)
			{
				_highlightEffect.show(_skin,_skin.mcNote2);
			}
			else if(dungeon_point==6)
			{
				_highlightEffect.show(_skin,_skin.mcNote3);
			}
			else if(dungeon_point==8)
			{
				_highlightEffect.show(_skin,_skin.mcNote4);	
			}
			else if(dungeon_point==10)
			{
				_highlightEffect.show(_skin,_skin.mcNote5);
			}
			
			if(DailyDataManager.instance.getDailyDataIsGet())
			{
				_highlightEffect.show(_skin,_skin.txtWantVit,2,2);
			}else
			{
				_highlightEffect.hide(_skin.txtWantVit);
			}
		}
		
		internal function refreshVit():void
		{
			var manager:DailyDataManager = DailyDataManager.instance;
			var vit:int = manager.player_daily_vit;
			var VIT_TOTAL:int = manager.daily_vit_max;
			_skin.txtVitValue.text = vit+"/"+VIT_TOTAL;
			_skin.mcGroMask.scaleX = vit > 0 ? (vit < VIT_TOTAL ? vit/VIT_TOTAL : 1) : 0;
		}
		
		public function refershBtn():void
		{
			var manager:SpecialRingDataManager = SpecialRingDataManager.instance;
			var isCanEnter:Boolean = manager.isCanEnter();
			isCanEnter ? _skin.btn.gotoAndStop(2) : _skin.btn.gotoAndStop(1);
			_btnEffectContainer.visible=isVitEnough();
		}
		
		internal function isVitEnough():Boolean
		{
			var vit:int = DailyDataManager.instance.player_daily_vit;
			var manager:SpecialRingDataManager = SpecialRingDataManager.instance;
			var isCanEnter:Boolean = manager.isCanEnter();
			if(isCanEnter)
			{
				if(vit < manager.getDungeonCfgData().player_daily_vit)
				{
					return false;
				}
				else
				{
					return true;
				}
			}
			else
			{
				if(vit < SpecialRingDataManager.VIT_COST_VALUE)
				{
					return false;
				}
				else
				{
					return true;
				}
			}
		}
		
		internal function destroy():void
		{
			TweenLite.killTweensOf(_skin.mcRate);
			_highlightEffect.hide(_skin.mcNote1);
			_highlightEffect.hide(_skin.mcNote2);
			_highlightEffect.hide(_skin.mcNote3);
			_highlightEffect.hide(_skin.mcNote4);
			_highlightEffect.hide(_skin.mcNote5);
			_highlightEffect.hide(_skin.txtWantVit);
			
			removeEffect();
			var i:int,l:int = 5;
			for(i=0;i<l;i++)
			{
				var mcEnter:MovieClip = _skin["mcEnter"+i] as MovieClip;
				ToolTipManager.getInstance().detach(mcEnter);
			}
			ToolTipManager.getInstance().detach(_skin.txtRule);
			ToolTipManager.getInstance().detach(_skin.txtVitValue);
			if(_cell)
			{
				_cell.destroy();
				_cell = null;
			}
			_skin = null;
			_tab = null;
		}
		
		private function removeEffect():void
		{
			if (_btnEffect)
			{
				_btnEffect.destroy();
				_btnEffect = null;
			}
			if (_btnEffectContainer && _btnEffectContainer.parent)
			{
				_skin.removeChild(_btnEffectContainer);
				_btnEffectContainer = null;
			}			
		}
	}
}