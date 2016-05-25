package com.view.gameWindow.panel.panels.boss.individual
{
    import com.model.business.fileService.constants.ResourcePathConstants;
    import com.model.consts.GameConst;
    import com.model.consts.StringConst;
    import com.model.consts.ToolTipConst;
    import com.model.gameWindow.rsr.RsrLoader;
    import com.view.gameWindow.mainUi.MainUiMediator;
    import com.view.gameWindow.panel.panels.bag.BagDataManager;
    import com.view.gameWindow.panel.panels.boss.BossDataManager;
    import com.view.gameWindow.panel.panels.boss.MCIndividualItem;
    import com.view.gameWindow.panel.panels.daily.DailyDataManager;
    import com.view.gameWindow.panel.panels.guideSystem.InterObjCollector;
    import com.view.gameWindow.panel.panels.roleProperty.RoleDataManager;
    import com.view.gameWindow.tips.rollTip.RollTipMediator;
    import com.view.gameWindow.tips.rollTip.RollTipType;
    import com.view.gameWindow.tips.toolTip.TipVO;
    import com.view.gameWindow.tips.toolTip.ToolTipManager;
    import com.view.gameWindow.util.FilterUtil;
    import com.view.gameWindow.util.HtmlUtils;
    import com.view.gameWindow.util.ServerTime;
    import com.view.gameWindow.util.SimpleStateButton;
    import com.view.gameWindow.util.TimeUtils;
    import com.view.gameWindow.util.TimerManager;
    import com.view.gameWindow.util.UIEffectLoader;
    import com.view.gameWindow.util.UrlPic;
    
    import flash.display.MovieClip;
    import flash.display.Sprite;
    import flash.events.Event;
    import flash.events.MouseEvent;
    import flash.filters.ColorMatrixFilter;

	public class IndividualItem 
	{
		
		private var _skin:MCIndividualItem;
		private var _parent:TabIndividualViewHandle;
		private var _data:IndividualItemData;
		private var _rsloader:RsrLoader;
		private var _bossIcon:UrlPic;
		//private var _awarditems:Vector.<IconCellEx> = new Vector.<IconCellEx>;
		public var isClick:Boolean = false;
		private var _leftTime:int;
		private var _tipsVo:TipVO = new TipVO;
		private var _bool:Boolean;
		 
		private var _effectLoader:UIEffectLoader;
//		private var _effectBox:Sprite = new Sprite;
		public function IndividualItem(parent:TabIndividualViewHandle,rsloader:RsrLoader)
		{
			_parent = parent;
			_rsloader = rsloader;
			_skin = new MCIndividualItem();
			_skin.mouseEnabled = false;
//			_skin.addChild(_effectBox);
//			_effectBox.mouseChildren = false;
//			_effectBox.mouseEnabled = false;
			init();
		}

		public function get skin():MCIndividualItem
		{
			return _skin;
		}
		private function init():void
		{
			_rsloader.addCallBack(_skin.longMc.mc,function (mc:MovieClip):void
			{
				InterObjCollector.instance.add(_skin.longMc);
				InterObjCollector.autoCollector.add(_skin.longMc);
			}
			); 
			_rsloader.loadItemRes(_skin.killedMc.mc); 
			_rsloader.loadItemRes(_skin.longMc.mc);
			_rsloader.loadItemRes(_skin.goldMc.mc);	
			_rsloader.load(_skin,ResourcePathConstants.IMAGE_PANEL_FOLDER_LOAD);
			_rsloader.addCallBack(_skin.mcstatebg,function (mc:MovieClip):void
			{
				if(isClick)
					mc.visible = true; 
				else
					mc.visible = false; 
			}
			);			
			_skin.bg2.addEventListener(MouseEvent.CLICK,onClickItem);
			_skin.speedTxt.addEventListener(MouseEvent.CLICK,onClickItem2);
			_skin.longMc.addEventListener(MouseEvent.CLICK,onClickItem3);
			_skin.addEventListener(MouseEvent.ROLL_OVER,onOver);
			_skin.addEventListener(MouseEvent.ROLL_OUT,onOut);
			_skin.addEventListener(Event.ADDED_TO_STAGE,onAdd);
			_skin.addEventListener(Event.REMOVED_FROM_STAGE,onRemove); 
 
			SimpleStateButton.addState(_skin.speedTxt);
			SimpleStateButton.addState(_skin.longMc);
			_skin.speedTxt.htmlText = StringConst.BOSS_PANEL_0038;
			_skin.speedTxt.visible = false;
			_skin.goldTxt.visible = false;
			_skin.goldMc.visible = false;
			
			_skin.longMc.visible = false;
			_skin.killedMc.visible = false;
			_skin.mcstatebg.visible = false;
			
			_bossIcon = new UrlPic(_skin.bossIcon);
            _skin.goldTxt.mouseEnabled = false;
            ToolTipManager.getInstance().attachByTipVO(_skin.goldMc, ToolTipConst.TEXT_TIP, HtmlUtils.createHtmlStr(0xffcc00, StringConst.MALL_COST_TYPE_1));

		}
 
		 
		 
		
		public function firstItemCheck():void
		{
			isClick = true;
			if(_skin.mcstatebg)
			{
				_skin.mcstatebg.visible = true;
				_parent.showBoss(_data);
			}
		}
		private function onAdd(e:Event):void
		{
			_skin.stage.addEventListener(MouseEvent.CLICK,onStageClick);
		}
		private function onRemove(e:Event):void
		{
			_skin.removeEventListener(Event.ADDED_TO_STAGE,onAdd);
			_skin.stage.removeEventListener(MouseEvent.CLICK,onStageClick); 
			_skin.stage.removeEventListener(Event.REMOVED_FROM_STAGE,onRemove);
		}	
		
		private function onStageClick(e:MouseEvent):void
		{ 
			if(e.target!=_skin.bg2 && e.target.parent is MCIndividualItem)
			{
				_skin.mcstatebg.visible = false;
				_skin.bossIcon.filters = [];
				isClick = false;
			}
		}
		
		private function onOver(e:MouseEvent):void
		{
			//_skin.mcstatebg.visible = true;
			_skin.bossIcon.filters = [FilterUtil.brightness(35)];
		}
		
		private function onOut(e:MouseEvent):void
		{
			if(!isClick)
			{
				//_skin.mcstatebg.visible = false;
				_skin.bossIcon.filters = [];
			}
		}
		
		private function onClickItem2(e:MouseEvent):void
		{
			if(!_bool)
				return;
			var object:Object = TimeUtils.calcTime2(_leftTime);
			if(BagDataManager.instance.goldUnBind >= object.min)
			{
				BossDataManager.instance.clearDungeonTime(_data.bossCfgData.dungeon_id,_leftTime);
				MainUiMediator.getInstance().bottomBar.sysAlert.removeItemById(GameConst.INDIVIDUAL_BOSS);
				//_leftTime = 0;
			}
			else
			{
				RollTipMediator.instance.showRollTip(RollTipType.ERROR,StringConst.DGN_GOALS_026);	
			}
		}
		
		private function onClickItem3(e:MouseEvent):void
		{
			if (RoleDataManager.instance.stallStatue)
			{
				RollTipMediator.instance.showRollTip(RollTipType.ERROR, StringConst.STALL_PANEL_0019);
				return;
			}
			if(!_bool)
			{
				RollTipMediator.instance.showRollTip(RollTipType.ERROR,StringConst.DGN_TOWER_0034);
			}
			else
			{
				if( _leftTime > 0)
				{
					RollTipMediator.instance.showRollTip(RollTipType.ERROR,StringConst.DGN_TOWER_0043);
					return;
				}
				BossDataManager.instance.dungeonId = _data.bossCfgData.dungeon_id;
				BossDataManager.instance.enterBossDungeon(_data.bossCfgData.monster_group_id);
			}
 
			
		}
		
		public function onClickItem(e:MouseEvent):void
		{
			_skin.mcstatebg.visible = true;
			isClick = true;
			_parent.showBoss(_data);
		}
		
		internal function refresh(data:IndividualItemData):void
		{
			_data = data;	
			if(RoleDataManager.instance.checkReincarnLevel(_data.reincarn,_data.level))
			{
				_bool = true; 
				_skin.levelTxt2.visible = false;
				dealFilters(null);
			}
			else
			{
				_bool = false;
				var matrix:Array=[0.3086, 0.6094, 0.0820, 0, 0,  
					0.3086, 0.6094, 0.0820, 0, 0,  
					0.3086, 0.6094, 0.0820, 0, 0,  
					0,      0,      0,      1, 0];  
				
				var filter:ColorMatrixFilter=new ColorMatrixFilter(matrix);  
				_skin.levelTxt2.visible = true;
				_skin.levelTxt2.text = data.level.toString()+StringConst.BOSS_PANEL_0036;
				dealFilters(filter);
			} 
			
			_bossIcon.load(ResourcePathConstants.IMAGE_BOSS_HEAD_LOAD+_data.url+".png");
			var longMcVisible:Boolean;
			if(_data.daily_complete_count>0)
			{ 
				_skin.killedMc.visible = true; 
				longMcVisible = false; 
				 
			}
			else
			{
				longMcVisible = true; 
				_skin.killedMc.visible = false;
				 
			}
			_skin.levelTxt.text = data.level.toString(); 
			if(_data.online_cleared == 0)
			{
				_leftTime = data.online-(ServerTime.time - DailyDataManager.instance.daily_online_start);
				_skin.leftTimeTxt.text = TimeUtils.formatS3(TimeUtils.calcTime3(_leftTime));
			}
			else
			{
				_leftTime = 0;
				
			}
			
			if( _leftTime > 0 )
			{
				if(_bool)
				{
					_skin.speedTxt.visible = true;
					_skin.goldMc.visible = true;
					_skin.goldTxt.visible = true;
					longMcVisible = false; 
					 
					_skin.leftTimeTxt.visible = true;
					_skin.leftTimeTxt.textColor = 0xff0000;
				}
				else
				{
					_skin.leftTimeTxt.text = StringConst.PLACEHOLDER;
					_skin.speedTxt.visible = false; 
					_skin.goldMc.visible = false;
					_skin.goldTxt.visible = false;
					longMcVisible = true; 
					 
				}
				TimerManager.getInstance().add(1000,updateTime);
				
			}
			else  
			{
				_skin.speedTxt.visible = false; 
				_skin.goldMc.visible = false;
				_skin.goldTxt.visible = false;
				_skin.leftTimeTxt.text = StringConst.PLACEHOLDER;
				_skin.leftTimeTxt.textColor = 0x00ff00;
				longMcVisible = _data.daily_complete_count>0 ? false:true;
				 
				 
			}
			if(_effectLoader)
			{
				_effectLoader.destroy();
				_effectLoader = null;
			}
			_skin.longMc.visible = longMcVisible;
			if(longMcVisible && _bool)
			{
				var url:String = "boss/longMcEffect.swf";
				_effectLoader = new UIEffectLoader(_skin,401,55.5,1,1,url,function():void
				{
					_effectLoader.effect.mouseChildren = false;
					_effectLoader.effect.mouseEnabled = false;
				});
				
			}
			var num:int =  Math.ceil(_leftTime/60);
			_skin.goldTxt.text = String(num);
		 
		}
		
		private function dealFilters(filters:ColorMatrixFilter):void
		{
			if(filters)
			{
				//_skin.bossIcon.filters = [filters];
				//_skin.bg.filters = [filters];
				_skin.longMc.filters = [filters];
				
				/*_skin.longTxt.filters =  [filters];*/
			}
			else
			{
				//_skin.bossIcon.filters = [];
				//_skin.bg.filters = [];
				_skin.longMc.filters = [];
				
				/*_skin.longTxt.filters = [];*/
			}	
		}
		public function updateTime():void
		{
			if(0>=_leftTime)
			{
				TimerManager.getInstance().remove(updateTime); 
				_skin.speedTxt.visible = false; 
				_skin.goldMc.visible = false;
				_skin.goldTxt.visible = false;
				_skin.leftTimeTxt.text = StringConst.PLACEHOLDER;
				_skin.filters = [];
				_skin.leftTimeTxt.textColor = 0x00ff00;
				_bool = true;
				if(BossDataManager.instance.getIndividualBossCount()){
					BossDataManager.instance.notify(BossDataManager.INDIVIDUAL_BOSS_NEW);
				}
				return;
			}
			_leftTime =_data.online-(ServerTime.time - DailyDataManager.instance.daily_online_start);
			var num:int = Math.ceil(_leftTime/60);
			/*if(num>0)
			{
				_tipsVo.tipType = ToolTipConst.TEXT_TIP;
				_tipsVo.tipData = HtmlUtils.createHtmlStr(0xffffff,StringUtil.substitute(StringConst.BOSS_PANEL_0034,String(num)));
				ToolTipManager.getInstance().hashTipInfo(_skin.speedTxt,_tipsVo); 
 
			}*/
			_skin.goldTxt.text = String(num);
			
			if(_bool)
			{
				_skin.leftTimeTxt.text = TimeUtils.formatS3(TimeUtils.calcTime3(_leftTime));
			}
			else
			{
				_skin.leftTimeTxt.text =StringConst.PLACEHOLDER;
			}
		}
		
		internal function destroy():void
		{
            if (_skin.goldMc)
            {
                ToolTipManager.getInstance().detach(_skin.goldMc);
            }
			InterObjCollector.instance.remove(_skin.longMc);
			InterObjCollector.autoCollector.remove(_skin.longMc);
			if(_skin.parent)
			{
				_skin.parent.removeChild(_skin);
			}
			
			/*for(var i:int =0;i<_awarditems.length;i++)
			{
				ToolTipManager.getInstance().detach(_awarditems[i]);
			}*/
				
			TimerManager.getInstance().remove(updateTime);
			ToolTipManager.getInstance().detach(_skin.speedTxt);
			_skin.removeEventListener(MouseEvent.ROLL_OVER,onOver);
			_skin.removeEventListener(MouseEvent.ROLL_OUT,onOut);
			_skin.bg2.removeEventListener(MouseEvent.CLICK,onClickItem);
			_skin.speedTxt.removeEventListener(MouseEvent.CLICK,onClickItem2);
			_skin.longMc.removeEventListener(MouseEvent.CLICK,onClickItem3);
			SimpleStateButton.removeState(_skin.speedTxt);
			SimpleStateButton.removeState(_skin.longMc);
			_bossIcon.destroy();
			_bossIcon = null;
			/*_awarditems.length = 0;
			_awarditems = null;*/
			_data = null;
			_skin =null;
		}
	}
}