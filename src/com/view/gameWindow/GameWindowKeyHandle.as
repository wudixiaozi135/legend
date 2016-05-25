package com.view.gameWindow
{
    import com.model.consts.ConstPkMode;
    import com.model.consts.JobConst;
    import com.model.consts.StringConst;
    import com.view.gameWindow.common.Alert;
    import com.view.gameWindow.mainUi.MainUiMediator;
    import com.view.gameWindow.mainUi.subuis.chatframe.IChatFrame;
    import com.view.gameWindow.mainUi.subuis.pet.PetDataManager;
    import com.view.gameWindow.mainUi.subuis.rolehead.PkDataManager;
    import com.view.gameWindow.panel.PanelConst;
    import com.view.gameWindow.panel.PanelMediator;
    import com.view.gameWindow.panel.panels.guideSystem.GuideSystem;
    import com.view.gameWindow.panel.panels.guideSystem.unlock.UnlockFuncId;
    import com.view.gameWindow.panel.panels.mail.data.PanelMailDataManager;
    import com.view.gameWindow.panel.panels.onhook.AutoSystem;
    import com.view.gameWindow.panel.panels.onhook.states.common.FightPlace;
    import com.view.gameWindow.panel.panels.roleProperty.RoleDataManager;
    import com.view.gameWindow.panel.panels.school.simpleness.SchoolDataManager;
    import com.view.gameWindow.scene.GameSceneManager;
    import com.view.gameWindow.scene.entity.constants.EntityTypes;
    import com.view.gameWindow.scene.entity.entityItem.autoJob.AutoJobManager;
    import com.view.gameWindow.scene.entity.entityItem.interf.IEntity;
    import com.view.gameWindow.tips.rollTip.RollTipMediator;
    import com.view.gameWindow.tips.rollTip.RollTipType;
    import com.view.newMir.NewMirMediator;
    
    import flash.display.Stage;
    import flash.events.Event;
    import flash.events.KeyboardEvent;
    import flash.text.TextField;
    import flash.ui.Keyboard;
    import flash.utils.Dictionary;
    import flash.utils.getTimer;

    /**
	 * 游戏窗口键盘事件处理类
	 * @author Administrator
	 */	
	public class GameWindowKeyHandle
	{
		private var _keyCodes:Dictionary;
		private var shiftKeyDownTime:int;

		public function GameWindowKeyHandle()
		{
			_keyCodes = new Dictionary();
			_keyCodes[49] = 0;
			_keyCodes[50] = 1;
			_keyCodes[51] = 2;
			_keyCodes[52] = 3;
			_keyCodes[53] = 4;
			_keyCodes[54] = 5;
			_keyCodes[81] = 6;
			_keyCodes[87] = 7;
			_keyCodes[69] = 8;
			_keyCodes[82] = 9;
		}
		
		public function addEvent(stage:Stage):void
		{
			stage.addEventListener(KeyboardEvent.KEY_DOWN,onKeyDown);
			stage.addEventListener(KeyboardEvent.KEY_UP,onKeyUp);
			stage.addEventListener(Event.DEACTIVATE,onDeactivate);
		}
		
		protected function onDeactivate(event:Event):void
		{
			GameSceneManager.getInstance().resetBarKeyDowns();
		}
		
		protected function onKeyDown(event:KeyboardEvent):void
		{
			if(MainUiMediator.getInstance().isShowDeadMask)
			{
				return;
			}
			if(MainUiMediator.getInstance().chatFrame.input.isFocus)
			{
				return;
			}
			if(GameSceneManager.getInstance().stage.focus is TextField) return;
			switch(event.keyCode)
			{
				case Keyboard.SHIFT:
					dealKeyShiftDown();
					break;
				case Keyboard.CONTROL:
					dealKeyCtrlDown();
					break;
				case 49://1
				case 50://2
				case 51://3
				case 52://4
				case 53://5
				case 54://6
				case 81://q
				case 87://w
				case 69://e
				case 82://r
					dealKeyDownActBarCell(event.keyCode);
					break;
				default:
					break;
			}
		}
		
		private function dealKeyShiftDown():void
		{
			GameSceneManager.getInstance().isShiftKeyDown = true;
			if(shiftKeyDownTime)
			{
				return;
			}
			var selectEntity:IEntity = AutoJobManager.getInstance().selectEntity;
			if(selectEntity && selectEntity.entityType == EntityTypes.ET_PLAYER)
			{
				shiftKeyDownTime = getTimer();
				var autoSystem:AutoSystem = AutoSystem.instance;
				var isAutoAttack:Boolean = autoSystem.isAutoAttack();
				if(!isAutoAttack)
				{
					autoSystem.startIndepentAttack(selectEntity.entityType,selectEntity.entityId);
				}
				else
				{
					autoSystem.stopAuto();
				}
			}
		}
		
		private function dealKeyCtrlDown():void
		{
			GameSceneManager.getInstance().isCtrlKeyDown = true;
		}
		
		private function dealKeyDownActBarCell(keyCode:uint):void
		{
            if (RoleDataManager.instance.stallStatue)
            {
                return;
            }
			var attrHp:int = RoleDataManager.instance.attrHp;
			if(attrHp <= 0)
			{
				return;
			}
			var key:int = _keyCodes[keyCode] as int;
			var barKeyDowns:Vector.<int> = GameSceneManager.getInstance().barKeyDowns;
			var indexOf:int = barKeyDowns.indexOf(key);
			if(indexOf == -1)
			{
				barKeyDowns.push(key);
				GameSceneManager.getInstance().lastPressKeyTime = 0;
			}
		}
		
		protected function onKeyUp(event:KeyboardEvent):void
		{
			if(MainUiMediator.getInstance().isShowDeadMask)
			{
				return;
			}
			if(MainUiMediator.getInstance().chatFrame.input.isFocus)
			{
				GameSceneManager.getInstance().resetBarKeyDowns();
				return;
			}
			if(GameSceneManager.getInstance().stage.focus is TextField) return;
			/*trace(event.keyCode);*/
			switch(event.keyCode)
			{
				case Keyboard.ESCAPE:
					dealKeyEsc();
					break;
				case Keyboard.SPACE:
					dealKeySpace();
					break;
				case 49://1
				case 50://2
				case 51://3
				case 52://4
				case 53://5
				case 54://6
				case 81://q
				case 87://w
				case 69://e
				case 82://r
					dealKeyUpActBarCell(event.keyCode);
					break;
				case Keyboard.ENTER:
					dealKeyEnter();
					break;
				case Keyboard.SHIFT:
					dealKeyShiftUp();
					break;
				case Keyboard.CONTROL:
					dealKeyCtrlUp();
					break;
				case 77://M
					dealKeyM();
					break;
				case 66://B
					dealKeyB();
					break;
				case 90://z
					dealKeyZ();
					break;
				case 67://c
					dealKeyC();
					break;
				case 86://v
					dealKeyV();
					break;
				case 71://g
					dealKeyG();
					break;
				case 72://H
					dealKeyH();
					break;
				case 88://X
					dealKeyX();
					break;
				case 79://O
					dealKeyO();
					break;
				case 84://t
					dealKeyT();
					break;
				case 73://I
					dealKeyI();
					break;
				case 70://F
					dealKeyF();
					break;
				case 78://N
					dealKeyN();
					break;
				case 85://U
					dealKeyU();
					break;
				case 80://P
					dealKeyP();
					break;
				case 75://K
					dealKeyK();
					break;
				case 65://A
					dealKeyA(event);
					break;
				case 83://S
					dealKeyS(event);
					break;
				default:
					break;
			}
		}
		
		private function dealKeyS(event:KeyboardEvent):void
		{
			var job:int = RoleDataManager.instance.job;
			if(event.shiftKey && job == JobConst.TYPE_DS)
			{
				PetDataManager.instance.callPetBack();
			}
		}
		
		private function dealKeyA(event:KeyboardEvent):void
		{
			var job:int = RoleDataManager.instance.job;
			if(event.shiftKey && job == JobConst.TYPE_DS)
			{
				PetDataManager.instance.changePetModel();
			}
		}
		
		private function dealKeyK():void
		{
			if(checkBottomBtnOpenState(UnlockFuncId.RANK))
			{
				PanelMediator.instance.switchPanel(PanelConst.TYPE_RANK);
			}
		}
		
		private function dealKeyP():void
		{
			PanelMailDataManager.instance.getMailList();
			PanelMailDataManager.instance.newMail = false;
			PanelMediator.instance.switchPanel(PanelConst.TYPE_MAIL);
		}
		
		private function dealKeyU():void
		{
			PanelMediator.instance.switchPanel(PanelConst.TYPE_ASSIST_SET);
		}
		
		private function dealKeyN():void
		{
			PanelMediator.instance.switchPanel(PanelConst.TYPE_TEAM);
		}
		
		private function dealKeyF():void
		{
			PanelMediator.instance.switchPanel(PanelConst.TYPE_FRIEND);
		}
		
		private function dealKeyI():void
		{
			if(checkBottomBtnOpenState(UnlockFuncId.ACHIEVEMENT))
			{
				PanelMediator.instance.switchPanel(PanelConst.TYPE_ACHI);
			}
		}
		
		private function dealKeyT():void
		{
			if(checkBottomBtnOpenState(UnlockFuncId.MALL))
			{
				PanelMediator.instance.switchPanel(PanelConst.TYPE_MALL);
			}
			
		}
		
		private function dealKeyO():void
		{
			if(checkBottomBtnOpenState(UnlockFuncId.POSITION))
			{
				PanelMediator.instance.switchPanel(PanelConst.TYPE_POSITION);
			}
		}
		
		private function dealKeyX():void
		{
			if(checkBottomBtnOpenState(UnlockFuncId.FORGE))
			{
				PanelMediator.instance.switchPanel(PanelConst.TYPE_FORGE);
			}
		}
		
		private function dealKeyH():void
		{
			if(GameSceneManager.getInstance().isShiftKeyDown)
			{
				if(PkDataManager.instance.pkMode != ConstPkMode.ALL)
				{
					PkDataManager.instance.changePkMode(ConstPkMode.ALL);
				}
				else
				{
					PkDataManager.instance.changePkMode(ConstPkMode.PEACE);
				}
			}
		}
		
		private function dealKeyG():void
		{
			if (checkBottomBtnOpenState(UnlockFuncId.GUILD))
			{
				//帮会
				if (SchoolDataManager.getInstance().schoolBaseData.schoolId != 0)  //如果已经有门派了
				{
					PanelMediator.instance.switchPanel(PanelConst.TYPE_SCHOOL);
				}
				else
				{
					PanelMediator.instance.switchPanel(PanelConst.TYPE_SCHOOL_CREATE);//测试代码
				}
			}
		}
		
		private function checkBottomBtnOpenState(id:int):Boolean
		{
			var isOpen:Boolean = GuideSystem.instance.isUnlock(id);
			if (!isOpen)
			{
				var tip:String = GuideSystem.instance.getUnlockTip(id);
				Alert.message(tip);
			}
			
			return isOpen;
		}
		
		private function dealKeyV():void
		{
			PanelMediator.instance.switchPanel(PanelConst.TYPE_SKILL);
		}
		
		private function dealKeyC():void
		{
			PanelMediator.instance.switchPanel(PanelConst.TYPE_ROLE_PROPERTY);
		}
		
		private function dealKeyEsc():void
		{
			AutoSystem.instance.stopAuto();
			AutoJobManager.getInstance().reset(true);
			AutoJobManager.getInstance().selectEntity = null;
			GameSceneManager.getInstance().clearMoveState();
            PanelMediator.instance.closeAllOpenedPanel();
		}
		
		private function dealKeySpace():void
		{
			AutoJobManager.getInstance().useJointSkill();
			if (DEF::CLIENTLOGIN)
			{
				doTest();
			}
		}
		/**调用测试代码*/
		private function doTest():void
		{
			/*PanelMediator.instance.switchPanel(PanelConst.TYPE_ALERT_EXP_STONE2);*/
		}
		
		private function dealKeyUpActBarCell(keyCode:int):void
		{
			var key:int = _keyCodes[keyCode] as int;
			var barKeyDowns:Vector.<int> = GameSceneManager.getInstance().barKeyDowns;
			var indexOf:int = barKeyDowns.indexOf(key);
			indexOf != -1 ? barKeyDowns.splice(indexOf,1) : null;
		}
		
		private function dealKeyM():void
		{
			PanelMediator.instance.switchPanel(PanelConst.TYPE_MAP);
		}
		
		private function dealKeyB():void
		{
			PanelMediator.instance.switchPanel(PanelConst.TYPE_BAG,true);
		}
		
		private function dealKeyZ():void
		{
			if (RoleDataManager.instance.stallStatue)
			{
				RollTipMediator.instance.showRollTip(RollTipType.ERROR, StringConst.STALL_PANEL_0019);
				return;
			}
			AutoSystem.instance.stopAutoEx();
			if(AutoSystem.instance.isAutoFight())
			{
//				AutoSystem.instance.stopAutoFight(FightPlace.FIGHT_PLACE_ALL);
			}
			else
			{
				AutoSystem.instance.startAutoFight(FightPlace.FIGHT_PLACE_AUTO);
			}
		}
		
		private function dealKeyEnter():void
		{
			var chatFrame:IChatFrame = NewMirMediator.getInstance().gameWindow.mainUiMediator.chatFrame;
			if(chatFrame)
			{
				chatFrame.showBg();
				chatFrame.input.setFocus();
			}
		}
		
		private function dealKeyShiftUp():void
		{
			GameSceneManager.getInstance().isShiftKeyDown = false;
			var nowTime:int = getTimer();
			if(shiftKeyDownTime && nowTime - shiftKeyDownTime >= 1000)
			{
				AutoSystem.instance.stopAuto();
			}
			shiftKeyDownTime = 0;
		}
		
		private function dealKeyCtrlUp():void
		{
			GameSceneManager.getInstance().isCtrlKeyDown = false;
		}
	}
}