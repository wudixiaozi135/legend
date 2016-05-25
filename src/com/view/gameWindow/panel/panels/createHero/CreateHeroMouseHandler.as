package com.view.gameWindow.panel.panels.createHero
{
	import com.model.business.gameService.constants.GameServiceConstants;
	import com.model.business.gameService.socketManager.ClientSocketManager;
	import com.model.consts.StringConst;
	import com.view.gameWindow.panel.PanelConst;
	import com.view.gameWindow.panel.PanelMediator;
	import com.view.gameWindow.panel.panels.roleProperty.RoleDataManager;
	import com.view.gameWindow.panel.panels.task.TaskDataManager;
	import com.view.gameWindow.tips.rollTip.RollTipMediator;
	import com.view.gameWindow.tips.rollTip.RollTipType;
	import com.view.gameWindow.tips.toolTip.ToolTipManager;
	import com.view.gameWindow.util.UtilColorMatrixFilters;
	
	import flash.events.MouseEvent;
	import flash.utils.ByteArray;
	import flash.utils.Endian;
	import flash.utils.clearTimeout;
	import flash.utils.setTimeout;

	public class CreateHeroMouseHandler
	{
		private var _panel:PanelCreateHero;
		private var _skin:McCreateHero;
		private var _select:int;
		private var timout:uint;

		private var heroWakeUpPanel:HeroWakeUpPanel;
		
		public function CreateHeroMouseHandler(panel:PanelCreateHero)
		{
			_panel=panel;
			_skin=panel.skin as McCreateHero;
			_skin.addEventListener(MouseEvent.CLICK,onClickFunc);
			setSelect(2);
			timout = setTimeout(randomSend,30000);
		}
		
		private function randomSend():void
		{
//			_select=Math.random()*3+1;
			_select=2;
			playEffect();
		}
		
		private function playEffect():void
		{
			PanelMediator.instance.switchPanel(PanelConst.TYPE_HERO_CREATE);
			PanelMediator.instance.switchPanel(PanelConst.TYPE_HERO_WAKEUP);
			heroWakeUpPanel=PanelMediator.instance.openedPanel(PanelConst.TYPE_HERO_WAKEUP) as HeroWakeUpPanel
			heroWakeUpPanel.compleF=sendServer;
			heroWakeUpPanel.play();
		}
		
		private function onClickFunc(e:MouseEvent):void
		{
			switch(e.target)
			{
				case _skin.btnHero_00:
					setSelect(1);
					break;
				case _skin.btnHero_01:
					setSelect(2);
					break;
				case _skin.btnHero_02:
					setSelect(3);
					break;
				case _skin.submitBtn:
					if(_select==0)
					{
						RollTipMediator.instance.showRollTip(RollTipType.ERROR,StringConst.HERO_CREATE_001);
						return;
					}
					clearTimeout(timout);
					playEffect();
					break;
				default:
					return;
			}
		}
		
		private function setSelect(value:int):void
		{
			_skin.btnHero_00.filters=UtilColorMatrixFilters.GREY_FILTERS;
			_skin.btnHero_01.filters=UtilColorMatrixFilters.GREY_FILTERS;
			_skin.btnHero_02.filters=UtilColorMatrixFilters.GREY_FILTERS;
			_skin.btnHero_11
			_skin.txt_00.visible=false;
			_skin.txt_01.visible=false;
			_skin.txt_02.visible=false;
			_skin.txt_11.visible=false;
			_skin.txt_12.visible=false;
			_skin.txt_13.visible=false;
			_select=value;
			switch(value)
			{
				case 1:
					_skin.btnHero_00.filters=null;
					_skin.txt_00.visible=true;
					_skin.txt_11.visible=true;
					break;
				case 2:
					_skin.btnHero_01.filters=null;
					_skin.txt_01.visible=true;
					_skin.txt_12.visible=true;
					break;
				case 3:
					_skin.btnHero_02.filters=null;
					_skin.txt_02.visible=true;
					_skin.txt_13.visible=true;
					break;
				default:
					break;
			}
			_panel.playerEffect(RoleDataManager.instance.job,_select);
		}
		
		private function sendServer():void
		{
			TaskDataManager.instance.setAutoTask(true);
			var paras:ByteArray=new ByteArray();
			paras.endian=Endian.LITTLE_ENDIAN;
			paras.writeShort(_select);
			ClientSocketManager.getInstance().asyncCall(GameServiceConstants.CM_CREATE_HERO,paras);
		}
		
		internal function destroy():void
		{
			ToolTipManager.getInstance().detach(_skin.txt_11);
			ToolTipManager.getInstance().detach(_skin.txt_12);
			ToolTipManager.getInstance().detach(_skin.txt_13);
			_skin.removeEventListener(MouseEvent.CLICK,onClickFunc);
		}
	}
}