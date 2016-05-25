package com.view.gameWindow.panel.panels.daily.taskdungeon
{
	import com.greensock.TweenLite;
	import com.model.business.fileService.constants.ResourcePathConstants;
	import com.model.configData.cfgdata.DailyCfgData;
	import com.model.consts.EffectConst;
	import com.view.gameWindow.panel.PanelConst;
	import com.view.gameWindow.panel.PanelMediator;
	import com.view.gameWindow.panel.panels.daily.DailyData;
	import com.view.gameWindow.panel.panels.daily.DailyDataManager;
	import com.view.gameWindow.util.UIEffectLoader;
	import com.view.gameWindow.util.UrlPic;
	import com.view.gameWindow.util.propertyParse.CfgDataParse;
	
	import flash.display.MovieClip;

	/**
	 * 任务副本页任务副本项类
	 * @author Administrator
	 */
	internal class TabDailyTaskDgnItem
	{
		private var _tab:TabDailyTaskDgn;
		private var _skin:McDailyTaskDungeonItem1;
		public function get skin():McDailyTaskDungeonItem1
		{
			return _skin;
		}

		private const ACCEPT:String = "daily/accept.png";
		private const CHALLENGE:String = "daily/challenge.png";
		private var _urlPicTimes:UrlPic;
		private var _urlPicBg:UrlPic;
		private var _dt:DailyData;
		
		private var duration:Number = .5;
		private var _tweenMcTimes:TweenLite;
		private var _tweenMcBtnTxt:TweenLite;
		private var _effectLoader:UIEffectLoader;
		
		public function TabDailyTaskDgnItem(tab:TabDailyTaskDgn,index:int)
		{
			_tab = tab;
			_skin = (tab.skin as McDailyTaskDungeon1)["mcItem"+index];
			init();
		}
		
		private function init():void
		{
			_skin.dgnItem = this;
			//
			initByTab();
			//
			_urlPicBg = new UrlPic(_skin.mcBgLayer);
		}
		
		internal function initByTab():void
		{
			var manager:DailyDataManager = DailyDataManager.instance;
			var selectTab:int = manager.selectTab;
			_urlPicTimes = new UrlPic(_skin.mcTimes.mcTimesLayer);
			if(selectTab == manager.tabTask)
			{
				_urlPicTimes.load(ResourcePathConstants.IMAGE_PANEL_FOLDER_LOAD+ACCEPT);
				_skin.mcTimes.y = _skin.mcLct2.y;
				_skin.mcBtnTxt.btnDo.y = _skin.mcBtnTxt.mcLct3.y;
				_skin.mcBtnTxt.alpha = 1;
			}
			else if(selectTab == manager.tabDgn)
			{
				_urlPicTimes.load(ResourcePathConstants.IMAGE_PANEL_FOLDER_LOAD+CHALLENGE);
				_skin.mcTimes.y = _skin.mcLct1.y;
				_skin.mcBtnTxt.btnDo.y = _skin.mcBtnTxt.mcLct2.y;
				_skin.mcBtnTxt.alpha = 0;
			}
			_skin.mcBtnTxt.btnDo.dgnItem = this;
		}
		
		internal function refresh(dt:DailyData):void
		{
			if(_dt != dt)
			{
				_dt = dt;
				var cfgDt:DailyCfgData = _dt.dailyCfgData;
				//
				var url:String = _dt.isUnlock ? cfgDt.url1 : cfgDt.url2;
				url = ResourcePathConstants.IMAGE_DAILY_FOLDER_LOAD + url + ResourcePathConstants.POSTFIX_JPG;
				_urlPicBg.load(url);
				//
				var manager:DailyDataManager = DailyDataManager.instance;
				var selectTab:int = manager.selectTab;
				if(selectTab == manager.tabTask)
				{
					_skin.mcTimes.txtTimesValue.text = _dt.taskRemainCount+"";
				}
				else if(selectTab == manager.tabDgn)
				{
					_skin.mcTimes.txtTimesValue.text = _dt.dgnRemainCount+"";
				}
				_skin.mcTimes.visible = _dt.isUnlock;
				//
				_skin.mcBtnTxt.txtDesc.htmlText = "";
				var pareseDes:Array = CfgDataParse.pareseDes(cfgDt.game_desc,0xffe1aa,6),str:String;
				for each(str in pareseDes)
				{
					_skin.mcBtnTxt.txtDesc.htmlText += str;
				}
				//
				_skin.mcBtnTxt.visible = _dt.isUnlock;
			}
		}
		
		internal function onClick(btn:MovieClip):void
		{
			if(!_dt || !_dt.isUnlock)
			{
				trace("TabDailyTaskDgnItem.onClick(btn) 报空或未解锁");
				return;
			}
			if(btn == _skin.mcBtnTxt.btnDo)
			{
				/*trace("TabDailyTaskDgnItem.onClick btnDo");*/
				var npcId:int;
				var manager:DailyDataManager = DailyDataManager.instance;
				var selectTab:int = manager.selectTab;
				if(selectTab == manager.tabTask)
				{
					/*trace("TabDailyTaskDgnItem.onClick Task");*/
					npcId = _dt.taskNpc;
				}
				else if(selectTab == manager.tabDgn)
				{
					npcId = _dt.dgnCfgData.npc;
				}
				DailyDataManager.instance.requestTeleport(npcId);
				PanelMediator.instance.closePanel(PanelConst.TYPE_DAILY);
			}
		}
		
		internal function onOverOut(isOver:Boolean):void
		{
			if(!_dt || !_dt.isUnlock)
			{
				trace("TabDailyTaskDgnItem.onOverOut(isOver) 报空或未解锁");
				return;
			}
			/*trace("TabDailyTaskDgnItem.onOverOut isOver"+isOver);*/
			var manager:DailyDataManager = DailyDataManager.instance;
			var selectTab:int = manager.selectTab;
			if(selectTab != manager.tabDgn)
			{
				return;
			}
			if(isOver)
			{
				if(!_tweenMcTimes)
				{
					_tweenMcTimes = new TweenLite(_skin.mcTimes,duration,{y:_skin.mcLct0.y});
				}
				if(!_tweenMcBtnTxt)
				{
					_tweenMcBtnTxt = new TweenLite(_skin.mcBtnTxt,duration,{alpha:1});
				}
				_tweenMcTimes.play();
				_tweenMcBtnTxt.play();
				if(_effectLoader)
				{
					_effectLoader.destroy();
				}
				_effectLoader = new UIEffectLoader(_skin.parent,_skin.x+_skin.width/2,_skin.y+_skin.height/2,1,1,EffectConst.RES_MAINUI_BTN);
			}
			else
			{
				_tweenMcTimes.reverse();
				_tweenMcBtnTxt.reverse();
				if(_effectLoader)
				{
					_effectLoader.destroy();
				}
			}
		}
		
		internal function isMouseOn():Boolean
		{
			if(!_skin)
			{
				return false;
			}
			var mx:Number = _skin.mouseX*_skin.scaleX;//返回相对图像的起始点位置
			var my:Number = _skin.mouseY*_skin.scaleY;
			var result:Boolean = mx > 0 && mx <= _skin.width && my > 0 && my <= _skin.height;
			return result;
		}
		
		internal function destroy():void
		{
			if(_tweenMcTimes)
			{
				_tweenMcTimes.kill();
			}
			_tweenMcTimes = null;
			if(_tweenMcBtnTxt)
			{
				_tweenMcBtnTxt.kill();
			}
			if(_effectLoader)
			{
				_effectLoader.destroy();
				_effectLoader = null;
			}
			_tweenMcBtnTxt = null;
			_skin.mcBtnTxt.btnDo.dgnItem = null;
			_skin.dgnItem = null;
			_dt = null;
			_urlPicTimes.destroy();
			_urlPicTimes = null;
			_urlPicBg.destroy();
			_urlPicBg = null;
			_skin = null;
			_tab = null;
		}
	}
}