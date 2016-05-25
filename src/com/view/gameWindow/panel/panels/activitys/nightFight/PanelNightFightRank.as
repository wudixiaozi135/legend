package com.view.gameWindow.panel.panels.activitys.nightFight
{
	import com.model.business.gameService.constants.GameServiceConstants;
	import com.model.consts.FontFamily;
	import com.model.consts.StringConst;
	import com.view.gameWindow.mainUi.subuis.activityTrace.ActivityDataManager;
	import com.view.gameWindow.panel.PanelConst;
	import com.view.gameWindow.panel.PanelMediator;
	import com.view.gameWindow.panel.panelbase.PanelBase;
	import com.view.gameWindow.util.HtmlUtils;
	
	import flash.events.MouseEvent;
	import flash.utils.clearInterval;
	import flash.utils.getTimer;
	import flash.utils.setInterval;
	
	/**
	 * 夜战比奇排行面板类
	 * @author Administrator
	 */	
	public class PanelNightFightRank extends PanelBase
	{
		private var _timerId:uint;
		private var _timeOver:int;
		private const DURATION:int = 30000;
		
		public function PanelNightFightRank()
		{
			super();
			canEscExit = false;
		}
		
		override protected function initSkin():void
		{
			var skin:McNightFightRank = new McNightFightRank();
			_skin = skin;
			addChild(skin);
		}
		
		override protected function initData():void
		{
			ActivityDataManager.instance.nightFightDataManager.attach(this);
			//
			var skin:McNightFightRank = _skin as McNightFightRank;
			skin.txt0.text = StringConst.NIGHT_FIGHT_RANK_0001;
			skin.txt1.text = StringConst.NIGHT_FIGHT_RANK_0002;
			skin.txt2.text = StringConst.NIGHT_FIGHT_RANK_0003;
			skin.txt3.text = StringConst.NIGHT_FIGHT_RANK_0004;
			skin.txt4.text = StringConst.NIGHT_FIGHT_RANK_0005;
			skin.txtRank.text = StringConst.NIGHT_FIGHT_RANK_0006;
			skin.txtScores.text = StringConst.NIGHT_FIGHT_RANK_0007;
			skin.txtReturn.htmlText = HtmlUtils.createHtmlStr(skin.txtReturn.textColor,StringConst.NIGHT_FIGHT_RANK_0008,12,false,2,FontFamily.FONT_NAME,true);
			//
			skin.addEventListener(MouseEvent.CLICK,onClick);
			//
			startCountDown();
		}
		
		protected function onClick(event:MouseEvent):void
		{
			var skin:McNightFightRank = _skin as McNightFightRank;
			if(event.target == skin.txtReturn)
			{
				dealCountOver();
				ActivityDataManager.instance.cmLeaveActivityMap();
			}
		}
		
		private function startCountDown():void
		{
			if(_timerId)
			{
				return;
			}
			_timeOver = getTimer() + DURATION;
			skin.txtCountdown.text = DURATION + "";
			_timerId = setInterval(function():void
			{
				var timeRemain:int = int((_timeOver - getTimer())*.001);
				if(!timeRemain)
				{
					dealCountOver();
					return;
				}
				var skin:McNightFightRank = _skin as McNightFightRank;
				skin.txtCountdown.text = timeRemain+"";
			},1000);
		}
		
		private function dealCountOver():void
		{
			clearInterval(_timerId);
			PanelMediator.instance.closePanel(PanelConst.TYPE_NIGHT_FIGHT_RANK);
		}
		
		override public function update(proc:int=0):void
		{
			if (proc != GameServiceConstants.SM_ACTIVITY_BIQI_NIGHT_RESULT)
			{
				return;
			}
			var manager:NightFightDataManager = ActivityDataManager.instance.nightFightDataManager;
			var skin:McNightFightRank = _skin as McNightFightRank;
			var i:int,l:int = manager.TOTAL_DTS;
			for (i=0;i<l;i++) 
			{
				var mc:McNightFightRankLine = skin["mc"+i];
				var dt:DataNightFightRank = manager.dtsRank[i];
				mc.txt0.text = dt.rank+"";
				mc.txt1.text = dt.strName;
				mc.txt2.text = dt.strLv;
				mc.txt3.text = dt.strJob;
				mc.txt4.text = dt.strScore;
				mc.txt0.textColor = mc.txt1.textColor = mc.txt2.textColor = mc.txt3.textColor = mc.txt4.textColor = dt.textColor;
			}
			//
			skin.txtRankValue.text = manager.strRankMine;
			skin.txtScoresValue.text = manager.scoreMine+"";
		}
		
		override public function destroy():void
		{
			_skin.removeEventListener(MouseEvent.CLICK,onClick);
			clearInterval(_timerId);
			ActivityDataManager.instance.nightFightDataManager.detach(this);
			super.destroy();
		}
	}
}