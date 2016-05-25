package com.view.gameWindow.mainUi.subuis.minimap
{
    import com.model.business.gameService.constants.GameServiceConstants;
    import com.model.consts.EffectConst;
    import com.model.consts.StringConst;
    import com.model.consts.ToolTipConst;
    import com.model.gameWindow.rsr.RsrLoader;
    import com.pattern.Observer.IObserver;
    import com.view.gameWindow.mainUi.MainUi;
    import com.view.gameWindow.mainUi.subclass.McMapProperty;
    import com.view.gameWindow.mainUi.subuis.displaySetting.DisplaySettingManager;
    import com.view.gameWindow.mainUi.subuis.musicSet.MusicSettingManager;
    import com.view.gameWindow.panel.panels.achievement.AchievementDataManager;
    import com.view.gameWindow.panel.panels.guideSystem.GuideSystem;
    import com.view.gameWindow.panel.panels.guideSystem.unlock.UnlockFuncId;
    import com.view.gameWindow.panel.panels.guideSystem.unlock.UnlockObserver;
    import com.view.gameWindow.panel.panels.mail.data.PanelMailDataManager;
    import com.view.gameWindow.panel.panels.map.MapDataManager;
    import com.view.gameWindow.tips.toolTip.TipVO;
    import com.view.gameWindow.tips.toolTip.ToolTipManager;
    import com.view.gameWindow.util.HtmlUtils;
    import com.view.gameWindow.util.UIEffectLoader;

    import flash.display.MovieClip;

    public class MiniMap extends MainUi implements IMiniMap,IObserver
	{
		private const miniMapTW:int = 530, miniMapTH:int = 380;
		private var _scaleX:Number,_scaleY:Number,_brinkW:int,_brinkH:int;
		private var _effectLoader:UIEffectLoader;
        private var _btnHideCheck:Boolean;

		private var _miniMapPicHandle:MiniMapPicHandle;
		private var _unlockObserver:UnlockObserver;
		public function MiniMap()
		{
			super();
			PanelMailDataManager.instance.attach(this);
			AchievementDataManager.getInstance().attach(this);
			MapDataManager.instance.attach(this);
		}
		
		override public function initView():void
		{
			_skin = new McMapProperty();
			addChild(_skin);
			_skin.txtNoReqCount.mouseEnabled=false;
			super.initView();
			new MiniMapClickHandle(_skin as McMapProperty);
			_miniMapPicHandle = new MiniMapPicHandle(_skin as McMapProperty);
			_unlockObserver = new UnlockObserver();
			_unlockObserver.setCallback(updateFunctionBtn);
			GuideSystem.instance.unlockStateNotice.attach(_unlockObserver);
		}
		
		private function updateFunctionBtn(id:int):void
		{
			if (id == UnlockFuncId.DAILY_VIT || id == UnlockFuncId.CONVERT_LIST)
			{
				initFunctionBtns();
			}
		}
		
		private function initFunctionBtns():void
		{
			
		}
		
		public function showMiniMap(mapId:int, xTile:int, yTile:int):void
		{
			_miniMapPicHandle.showMiniMap(mapId,xTile,yTile);
		}
		
		public function refreshMiniMapPos(x:Number,y:Number):void
		{
			_miniMapPicHandle.refreshMiniMapPos(x,y);
		}
		
		public function addMstSign(id:int):void
		{
			_miniMapPicHandle.addMstSign(id);
		}
		
		public function refreshMstSign(id:int):void
		{
			_miniMapPicHandle.refreshMstSign(id);
		}
		
		public function removeMstSign(id:int):void
		{
			_miniMapPicHandle.removeMstSign(id);
		}
		
		public function addPlayerSign(id:int):void
		{
			_miniMapPicHandle.addPlayerSign(id);
		}
		
		public function removePlayerSign(id:int):void
		{
			_miniMapPicHandle.removePlayerSign(id);
		}
		
		public function refreshPlayerSign(id:int):void
		{
			_miniMapPicHandle.refreshPlayerSign(id);	
		}

		public function setBtnHide(check:Boolean):void
		{
            _btnHideCheck = check;
			var mc:McMapProperty = _skin as McMapProperty;
			if (mc)
			{
				if (mc.btnHide.selected != check)
				{
					mc.btnHide.selected = check;
				}
			}
		}

		public function setBtnMuisc(selected:Boolean):void
		{
			var mc:McMapProperty = _skin as McMapProperty;
			if (mc)
			{
				if (mc.btnMusic.selected != selected)
				{
					mc.btnMusic.selected = selected;
				}
			}
		}

		public function update(proc:int=0):void
		{

			var noCount:int=AchievementDataManager.getInstance().noRequstCount;
			_skin.txtNoReqCount.htmlText=HtmlUtils.createHtmlStr(0xffffff,noCount+"",12,false);
			_skin.txtNoReqCount.visible=noCount>0;
			_skin.txtRequstBG.visible=noCount>0;

			
			_miniMapPicHandle.updateProc(proc);
			
			if(PanelMailDataManager.instance.newMail)
			{
				if(!_effectLoader)
				{
					_effectLoader = new UIEffectLoader(_skin,_skin.btnMail.x-2, _skin.btnMail.y-2,1,1,EffectConst.RES_MAINUI_BTN_EMAIL);
				}
			}
			else
			{
				if(_effectLoader)
				{
					_effectLoader.destroy();
					_effectLoader = null;
				}
				
			}
		}
		
		override protected function addCallBack(rsrLoader:RsrLoader):void
		{
			rsrLoader.addCallBack(_skin.txtRequstBG,function (mc:MovieClip):void
			{
				_skin.txtRequstBG.mouseEnabled=false;
				var noCount:int=AchievementDataManager.getInstance().noRequstCount;
				_skin.txtRequstBG.visible=noCount>0;
			});
			var skin:McMapProperty = _skin as McMapProperty;
			rsrLoader.addCallBack(skin.btnMusic, function (mc:MovieClip):void
			{
				skin.btnMusic.buttonMode = true;
				ToolTipManager.getInstance().detach(mc);

				var tipVo:TipVO = new TipVO();
				tipVo.tipType = ToolTipConst.TEXT_TIP;
				tipVo.tipData = StringConst.MUSIC_SETTING_8;
				ToolTipManager.getInstance().hashTipInfo(mc, tipVo);
				ToolTipManager.getInstance().attach(mc);
				MusicSettingManager.instance.addEvent(mc);
			});

			rsrLoader.addCallBack(skin.btnHide, function (mc:MovieClip):void
			{
                mc.selected = _btnHideCheck;
				skin.btnHide.buttonMode = true;
				ToolTipManager.getInstance().detach(mc);
				var vo:TipVO = new TipVO();
				vo.tipType = ToolTipConst.TEXT_TIP;
				vo.tipData = StringConst.DISPLAY_SETTING_15;
				ToolTipManager.getInstance().hashTipInfo(mc, vo);
				ToolTipManager.getInstance().attach(mc);
				DisplaySettingManager.instance.addEvent(mc);
			});
			
			rsrLoader.addCallBack(skin.btnAchieve, function (mc:MovieClip):void
			{
				skin.btnAchieve.buttonMode = true;
				ToolTipManager.getInstance().attachByTipVO(skin.btnAchieve,ToolTipConst.TEXT_TIP,StringConst.BTNTIPS_0008);
			});
			
			rsrLoader.addCallBack(skin.btnFriend, function (mc:MovieClip):void
			{
				skin.btnFriend.buttonMode = true;
				ToolTipManager.getInstance().attachByTipVO(skin.btnFriend,ToolTipConst.TEXT_TIP,StringConst.BTNTIPS_0009);
			});
			
			rsrLoader.addCallBack(skin.btnAvtivityDaily, function (mc:MovieClip):void
			{
				skin.btnAvtivityDaily.buttonMode = true;
				ToolTipManager.getInstance().attachByTipVO(skin.btnAvtivityDaily,ToolTipConst.TEXT_TIP,StringConst.BTNTIPS_0024);
			});
			
			rsrLoader.addCallBack(skin.btnMap, function (mc:MovieClip):void
			{
				skin.btnMap.buttonMode = true;
				ToolTipManager.getInstance().attachByTipVO(skin.btnMap,ToolTipConst.TEXT_TIP,StringConst.BTNTIPS_0013);
			});
			
			rsrLoader.addCallBack(skin.btnSystemSet, function (mc:MovieClip):void
			{
				skin.btnSystemSet.buttonMode = true;
				ToolTipManager.getInstance().attachByTipVO(skin.btnSystemSet,ToolTipConst.TEXT_TIP,StringConst.BTNTIPS_0014);
			});
			
			rsrLoader.addCallBack(skin.btnMail, function (mc:MovieClip):void
			{
				skin.btnMail.buttonMode = true;
				ToolTipManager.getInstance().attachByTipVO(skin.btnMail,ToolTipConst.TEXT_TIP,StringConst.BTNTIPS_0015);
			});
			
			rsrLoader.addCallBack(skin.btnRanking, function (mc:MovieClip):void
			{
				skin.btnRanking.buttonMode = true;
				ToolTipManager.getInstance().attachByTipVO(skin.btnRanking,ToolTipConst.TEXT_TIP,StringConst.BTNTIPS_0016);
			});

            rsrLoader.addCallBack(skin.btnStronger, function (mc:MovieClip):void
            {
                mc.buttonMode = true;
                ToolTipManager.getInstance().attachByTipVO(mc, ToolTipConst.TEXT_TIP, StringConst.BTNTIPS_0028);
            });
		}
		
	}
}