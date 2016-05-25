package com.view.gameWindow.panel.panels.thingNew.skillNew
{
    import com.greensock.TweenMax;
    import com.model.configData.cfgdata.SkillCfgData;
    import com.model.consts.StringConst;
    import com.model.gameWindow.rsr.RsrLoader;
    import com.view.gameWindow.common.HighlightEffectManager;
    import com.view.gameWindow.flyEffect.FlyEffectMediator;
    import com.view.gameWindow.panel.PanelConst;
    import com.view.gameWindow.panel.PanelMediator;
    import com.view.gameWindow.panel.panelbase.PanelBase;
    import com.view.gameWindow.panel.panels.guideSystem.InterObjCollector;
    import com.view.gameWindow.panel.panels.skill.SkillData;
    import com.view.gameWindow.panel.panels.skill.SkillDataManager;
    import com.view.gameWindow.panel.panels.thingNew.McSkillNew;
    import com.view.gameWindow.scene.entity.constants.EntityTypes;
    import com.view.gameWindow.tips.toolTip.ToolTipManager;
    import com.view.gameWindow.util.HtmlUtils;
    import com.view.gameWindow.util.cell.IconCellSkill;
    import com.view.newMir.NewMirMediator;

    import flash.display.Bitmap;
    import flash.display.MovieClip;
    import flash.events.MouseEvent;
    import flash.geom.Rectangle;
    import flash.utils.clearTimeout;
    import flash.utils.setTimeout;

    /**
	 * 获得新技能提示面板类
	 * @author Administrator
	 */	
	public class PanelSkillNew extends PanelBase implements IPanelSkillNew
	{
		private var _cell:IconCellSkill;
		private var _bgHightLight:HighlightEffectManager;
		private var _isMovie:Boolean = false;
		private var _timerId:int, _delay:int = 4000;
		public function get cell():IconCellSkill
		{
			return _cell;
		}

		public function PanelSkillNew()
		{
			super();
		}
		
		override protected function initSkin():void
		{
			var skin:McSkillNew = new McSkillNew();
			_skin = skin;
			addChild(_skin);
			setTitleBar(skin.mcDrag);
			_bgHightLight = new HighlightEffectManager();
            skin.btnClose.visible = false;//屏蔽关闭按钮
            skin.btnClose.mouseEnabled = false;//
		}
		
		override protected function initData():void
		{
			var skin:McSkillNew = _skin as McSkillNew;
			skin.addEventListener(MouseEvent.CLICK,onClick);
			//
			skin.title.mouseEnabled = false;
			skin.txt.mouseEnabled = false;
			skin.title.htmlText = HtmlUtils.createHtmlStr(0xffcc00, StringConst.SKILL_NEW_PANEL_0002);
			skin.txt.text = StringConst.SKILL_NEW_PANEL_0001;
			InterObjCollector.instance.add(skin.txt);
			var skillDataNew:SkillData = SkillDataManager.instance.skillDataNew;
			if(skillDataNew)
			{
				_cell = new IconCellSkill(skin.mc);
				_cell.refresh(skillDataNew.skillCfgDt);
				ToolTipManager.getInstance().attach(_cell);
			}
			//
			_timerId = setTimeout(onTimer,_delay);
			handlerEffect();
		}

		override protected function addCallBack(rsrLoader:RsrLoader):void
		{
			var skin:McSkillNew = _skin as McSkillNew;
			rsrLoader.addCallBack(skin.skillBg, function (mc:MovieClip):void
			{
				_bgHightLight.show(mc, mc);
			});
		}

		//倒计时结束 默认使用
		private function onTimer():void
		{
			if (_isMovie) return;
			_isMovie = true;
            clearTimeout(_timerId);

            var cfgDt:SkillCfgData = cell.cfgDt;
            if (cfgDt.view_type == EntityTypes.ET_PLAYER)//显示类型为玩家的技能执行飞行特效
            {
                FlyEffectMediator.instance.doFlySkillNew(index);
            }
            closeHandler();
		}
		
		protected function onClick(event:MouseEvent):void
		{
			var skin:McSkillNew = _skin as McSkillNew;
			switch(event.target)
			{
				default:
					dealClick();
					break;
				case skin.btnClose://关闭按钮
					closeHandler();
					_isMovie = true;
					break;
			}
		}

		//播放icon动画
		private function dealClick():void
		{
            if (_isMovie) return;
            _isMovie = true;
			clearTimeout(_timerId);

			var cfgDt:SkillCfgData = cell.cfgDt;
			if(cfgDt.view_type == EntityTypes.ET_PLAYER)//显示类型为玩家的技能执行飞行特效
			{
				FlyEffectMediator.instance.doFlySkillNew(index);
			}
			closeHandler();
		}
		
		override public function setPostion():void
		{
			var rect:Rectangle = getPanelRect();
			var newMirMediator:NewMirMediator = NewMirMediator.getInstance();
			var newX:int = int((newMirMediator.width - rect.width) >> 1);
			var newY:int = int((newMirMediator.height - rect.height)) - 100;
			x != newX ? x = newX : null;
			y != newY ? y = newY : null;
		}
		
		override public function resetPosInParent():void
		{
			super.resetPosInParent();
			setPostion();
		}

		private function handlerEffect():void
		{
			var rect:Rectangle = getPanelRect();
			var newMirMediator:NewMirMediator = NewMirMediator.getInstance();
			var newY:int = newMirMediator.height - rect.height - 200;
			TweenMax.fromTo(this, 1, {alpha: 0}, {
				y: newY, alpha: 1, onComplete: function ():void
				{
					TweenMax.killTweensOf(this);
				}
			});
		}

		private function closeHandler():void
		{
			alpha = 1;
			TweenMax.to(this, 1, {
				x: (x + 280), alpha: 0, onComplete: function ():void
				{
					TweenMax.killTweensOf(this);
                    PanelMediator.instance.closePanel(PanelConst.TYPE_SKILL_NEW, index);
				}
			});
		}

		public function cellCopyBmp():Bitmap
		{
			return cell.copyBitMap();
		}
		
		override public function destroy():void
		{
			clearTimeout(_timerId);
			if(_cell)
			{
				ToolTipManager.getInstance().detach(_cell);
				_cell.destroy();
				_cell = null;
			}
			if (_skin)
			{
				if (_bgHightLight)
				{
					_bgHightLight.hide(_skin.skillBg);
					_bgHightLight = null;
				}
				_skin.removeEventListener(MouseEvent.CLICK, onClick);
			}
			InterObjCollector.instance.remove(skin.txt);
			super.destroy();
		}
	}
}