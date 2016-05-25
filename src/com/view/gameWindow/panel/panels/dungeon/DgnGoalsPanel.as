package com.view.gameWindow.panel.panels.dungeon
{
	import com.greensock.TweenLite;
	import com.model.business.gameService.constants.GameServiceConstants;
	import com.model.consts.SlotType;
	import com.model.consts.StringConst;
	import com.model.gameWindow.rsr.RsrLoader;
	import com.view.gameWindow.common.Alert;
	import com.view.gameWindow.common.PropertyOrganizer;
	import com.view.gameWindow.panel.panelbase.PanelBase;
	import com.view.gameWindow.panel.panels.roleProperty.RoleDataManager;
	import com.view.gameWindow.tips.toolTip.ToolTipManager;
	import com.view.gameWindow.util.UtilItemParse;
	import com.view.gameWindow.util.cell.IconCellEx;
	import com.view.gameWindow.util.cell.ThingsData;
	import com.view.newMir.NewMirMediator;
	
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.events.TextEvent;
	import flash.utils.clearInterval;
	import flash.utils.setInterval;
	
	/**
	 * @author wqhk
	 * 2014-9-4
	 */
	public class DgnGoalsPanel extends PanelBase
	{
		public static const P1:String = "title";
		public static const P2:String = "elapsedTime";
		public static const P3:String = "stepTitle";
		public static const P4:String = "stepDes";
		public static const P5:String = "stepTarget";
		public static const P6:String = "stepCountdownTime";
		public static const P7:String = "countdownTime";
		public static const P8:String = "cancel";
		private static var propertyList:Array;
		
		private var _ui:McDungeonGoalsPanel;
		private var _p:PropertyOrganizer;
		
		private var _timeId:int;
		private var _foldTween:TweenLite;
		private var _startX:Number = 0;
		private var _startY:Number = 0;
		
		private var _iconEquips:Vector.<IconCellEx>;
		private const NUM_EQUIP:int = 6;
		
		public function DgnGoalsPanel()
		{
			super();
			canEscExit=false;
			propertyList = [P1,P2,P3,P4,P5,P6,P7];
		}
		
		override public function resetPosInParent():void
		{
			_startX = NewMirMediator.getInstance().width - _skin.width;
			_startY = (NewMirMediator.getInstance().height - _skin.height)/2;
			x = _startX;
			y = _startY;
		}
		
		override public function setPostion():void
		{
			resetPosInParent();
		}
		
		override public function destroy():void
		{
			var iconEquip:IconCellEx;
			for each(iconEquip in _iconEquips)
			{
				if(iconEquip)
				{
					ToolTipManager.getInstance().detach(iconEquip);
					iconEquip.destroy();
				}
			}
			_iconEquips = null;
			_ui.stepTargetTxt.removeEventListener(TextEvent.LINK,textClickHandler);
			
			if(_timeId)
			{
				clearInterval(_timeId);
				_timeId = 0;
			}
			
			if(_foldTween)
			{
				_foldTween.kill();
				_foldTween = null;
			}
			
			if(_p)
			{
				_p.destroy();
			}
			
			DgnGoalsDataManager.instance.detach(this);
			super.destroy();
		}
		
		override public function update(proc:int=0):void
		{
			super.update(proc);
			
			for each(var name:String in  propertyList)
			{
				_p.update(name);
			}
			
			if(proc == GameServiceConstants.SM_FINISH_DUNGEON)
			{
				if(_timeId)
				{
					clearInterval(_timeId);
					_timeId = 0;
				}
				_ui.mcFinish.visible = true;
			}
			if(proc == GameServiceConstants.SM_DUNGEON_STEP_PROGRESS)
			{
				updateEquips();
			}
		}
		
		override protected function  initSkin():void
		{
			_ui = new McDungeonGoalsPanel();
			_skin = _ui;
			_startX = NewMirMediator.getInstance().width - _skin.width;
			_startY = (NewMirMediator.getInstance().height - _skin.height)/2;
			x = _startX;
			y = _startY;
			
			addChild(_skin);
			
			_p = new PropertyOrganizer(this);
			
			var dm:DgnGoalsDataManager = DgnGoalsDataManager.instance;
			
			_p.register(P1,"skin.titleTxt.text",dm.getTitle);
			_p.register(P2,"skin.elapsedTimeTxt.text",dm.getElapsedTimeStr);
			_p.register(P3,"skin.stepTitleTxt.text",dm.getStepTitle);
			_p.register(P4,"skin.stepDesTxt.htmlText",dm.getStepDes);
			_p.register(P5,"skin.stepTargetTxt.htmlText",dm.getStepTarget);
			_p.register(P6,"skin.stepCountdownTimeTxt.htmlText",dm.getStepCountdownTimeStr);
			_p.register(P7,"skin.countdownTimeTxt.htmlText",dm.getCountdownTimeStr);
			_p.register(P8,"skin.btnCancel.txt.text",dm.getCancelBtnTxt);
			
			dm.attach(this);
			
			_timeId = setInterval(intervalHandler,1000);
			
			addEventListener(MouseEvent.CLICK,clickHandler);
			
			_ui.stepTargetTxt.addEventListener(TextEvent.LINK,textClickHandler);
			
			_ui.mcFinish.mouseEnabled = false;
			_ui.mcFinish.visible = false;
			//
			_ui.txtEquip.text = StringConst.BOSS_INFO_0004;
		}
		
		private function updateEquips():void
		{
			if(_iconEquips)
			{
				return;
			}
			var strBossDrop:String = DgnGoalsDataManager.instance.boss_drop;
			if(!strBossDrop)
			{
				return;
			}
			var dts:Vector.<ThingsData> = UtilItemParse.getThingsDatasByFilter(strBossDrop,function(dt:ThingsData):Boolean
			{
				if(dt.type != SlotType.IT_EQUIP)
				{
					return false;
				}
				if(!dt.equipCfgData)
				{
					return true;
				}
				var job:int = RoleDataManager.instance.job;
				if(dt.equipCfgData.job != 0 && dt.equipCfgData.job != job)
				{
					return true;
				}
				var sex:int = RoleDataManager.instance.sex;
				if(dt.equipCfgData.sex != 0 && dt.equipCfgData.sex != sex)
				{
					return true;
				}
				return false;
			});
			_iconEquips = new Vector.<IconCellEx>(NUM_EQUIP,true);
			var i:int,l:int = dts ? (dts.length < NUM_EQUIP ? dts.length : NUM_EQUIP) : 0;
			for (i=0;i<l;i++) 
			{
				var mcEquip:MovieClip = _skin["mcEquip"+i] as MovieClip;
				var iconEquip:IconCellEx = new IconCellEx(mcEquip.parent,mcEquip.x,mcEquip.y,mcEquip.width,mcEquip.height);
				_iconEquips[i] = iconEquip;
				IconCellEx.setItemByThingsData(iconEquip,dts[i]);
				ToolTipManager.getInstance().attach(iconEquip);
			}
		}
		
		private function textClickHandler(e:TextEvent):void
		{
			var dm:DgnGoalsDataManager = DgnGoalsDataManager.instance;
			dm.excuteStepTarget();
		}
		
		private function setFoldAnim(isFold:Boolean):void
		{
			if(_foldTween)
			{
				_foldTween.kill();
			}
			
			_foldTween = TweenLite.to(_skin,0.8,{x:isFold?_skin.width:0});
		}
		
		private function clickHandler(e:MouseEvent):void
		{
			switch(e.target)
			{
				case _ui.btnFold:
					setFoldAnim(_ui.btnFold.selected);
					break;
				case _ui.btnCancel:
					if(!DgnGoalsDataManager.instance.isFinish)
					{
						Alert.show2(StringConst.DGN_GOALS_022,confirmCancel);
					}
					else
					{
						confirmCancel();
					}
					break;
			}
		}
		
		private function confirmCancel():void
		{
			DgnGoalsDataManager.instance.requestReward(0);
			DgnGoalsDataManager.instance.requestCancel();
		}
		
		private function intervalHandler():void
		{
			_p.update(P2);
			_p.update(P6);
			_p.update(P7);
		}
		
		override protected function addCallBack(rsrLoader:RsrLoader):void
		{
			rsrLoader.addCallBack(_ui.btnCancel,function():void{
				_p.update(P8);
			});
			
			rsrLoader.addCallBack(_ui.btnFold,function():void{
				addChild(_ui.btnFold);
				
				resetPosInParent();
			});
		}
	}
}