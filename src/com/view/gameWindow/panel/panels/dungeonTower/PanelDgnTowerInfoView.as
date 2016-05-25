package com.view.gameWindow.panel.panels.dungeonTower
{
	import com.model.configData.cfgdata.DungeonCfgData;
	import com.model.consts.StringConst;
	import com.model.consts.ToolTipConst;
	import com.view.gameWindow.tips.rollTip.RollTipMediator;
	import com.view.gameWindow.tips.rollTip.RollTipType;
	import com.view.gameWindow.tips.toolTip.ToolTipManager;
	import com.view.gameWindow.util.propertyParse.CfgDataParse;
	
	import flash.utils.clearInterval;
	import flash.utils.getTimer;
	import flash.utils.setInterval;

	/**
	 * 塔防副本信息面板显示处理类
	 * @author Administrator
	 */	
	internal class PanelDgnTowerInfoView
	{
		private var _panel:PanelDgnTowerInfo;
		private var _skin:McDgnTowerInfo;
		
		internal var assign:PanelDgnTowerInfoAssign;
		private var _timeLast:int,_timeDgnStart:int;
		private var _timerId:uint;

		private var _add:Number;
		
		public function PanelDgnTowerInfoView(panel:PanelDgnTowerInfo)
		{
			_panel = panel;
			_skin = _panel.skin as McDgnTowerInfo;
			initialize();
		}
		
		private function initialize():void
		{
			assign = new PanelDgnTowerInfoAssign(_panel);
			assign.assignTxtTitle();
			assign.assignTxtDesc();
			assign.assignTxtBuy();
			assign.assignTxtMstComing();
			assign.assignTxtExpUnget();
			assign.assignTxtExpMissed();
			assign.assignTxtRule();
			//
			var dgnCfgDt:DungeonCfgData = DgnTowerDataManger.instance.dgnCfgDt();
			if(dgnCfgDt)
			{
				var str:String = CfgDataParse.pareseDesToStr(dgnCfgDt.desc);
				ToolTipManager.getInstance().attachByTipVO(_skin.txtRule,ToolTipConst.TEXT_TIP,str);
			}
			refresh();
			//
			setTime();
			//
			_skin.mcExpUnget.mouseChildren = false;
			_skin.mcExpUnget.mouseEnabled = false;
			_skin.mcExpMissed.mouseChildren = false;
			_skin.mcExpMissed.mouseEnabled = false;
		}
		
		private function setTime():void
		{
			var cfgDt:DungeonCfgData = DgnTowerDataManger.instance.dgnCfgDt();
			if(!cfgDt)
			{
				return;
			}
			_timeLast = getTimer();
			_timeDgnStart = _timeLast;
			_timerId = setInterval(function ():void
			{
				var timeNow:int = getTimer();
				if(timeNow - _timeLast > 1000)
				{
					_timeLast = timeNow;
					var timeDuration:int = (timeNow - _timeDgnStart)*.001;
					var remain:int = cfgDt.duration - timeDuration;
					//
					dealAutoStart(timeDuration);
					dealPrompt(timeNow);
					assign.assignTxtCountdownTime(remain);
					//
					if(remain <= 0)
					{
						clearInterval(_timerId);
					}
				}
				dealFlickerTxt(timeNow);
			},100);
		}
		/**处理自动开始刷怪*/
		private function dealAutoStart(duration:int):void
		{
			if(duration >= 300)//若进入后超过5MIN
			{
				var manager:DgnTowerDataManger = DgnTowerDataManger.instance;
				if(!manager.isStart)
				{
					manager.cmSendDungeonEvnet()//自动开始刷怪
				}
			}
		}
		/**处理提示*/
		private function dealPrompt(timeNow:int):void
		{
			var manager:DgnTowerDataManger = DgnTowerDataManger.instance;
			var timeEventStart:int = manager.timeEventStart;
			if(timeEventStart)
			{
				var delay:int = manager.dgnEventCfgDt().delay;
				var timeDuration:int = timeNow - timeEventStart;
				var timeRemain:int = (delay - timeDuration)*.001;
				if(timeRemain <= 0)
				{
					manager.timeEventStart = 0;
				}
				else
				{
					var str:String = StringConst.DGN_TOWER_0040.replace("&x",timeRemain);
					RollTipMediator.instance.showRollTip(RollTipType.PLACARD,str);
				}
			}
		}
		/**处理闪烁文本*/
		private function dealFlickerTxt(timeNow:int):void
		{
			var manager:DgnTowerDataManger = DgnTowerDataManger.instance;
			var timeStepStart:int = manager.timeStepStart;
			if(timeStepStart)
			{
				var timeDuration:int = timeNow - timeStepStart;
				var timeRemain:int = 10000 - timeDuration;
				if(timeRemain <= 0)
				{
					manager.timeStepStart = 0;
					_skin.txtMstComing.alpha = 0;
				}
				else
				{
					var alpha:Number = _skin.txtMstComing.alpha;
					_add = alpha >= 1 ? -.2 : (alpha <= 0 ? .2 : _add)
					_skin.txtMstComing.alpha += _add;
					/*trace("PanelDgnTowerInfoView.dealFlickerTxt(timeNow) alpha:"+_skin.txtMstComing.alpha);*/
				}
			}
		}
		
		internal function refresh():void
		{
			assign.assignTxtDefenses();
			assign.assignTxtMstInfo();
			assign.assignTxtExpUngetValue();
			assign.assignTxtExpMissedValue();
			assign.assignTxtInBtn();
		}
		
		internal function destroy():void
		{
			ToolTipManager.getInstance().detach(_skin.txtRule);
			clearInterval(_timerId);
			assign = null;
			_skin = null;
			_panel = null;
		}
	}
}