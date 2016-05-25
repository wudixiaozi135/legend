package com.view.gameWindow.panel.panels.trailer
{
	import com.model.configData.cfgdata.TaskCfgData;
	import com.model.consts.StringConst;
	import com.view.gameWindow.common.Alert;
	import com.view.gameWindow.panel.PanelConst;
	import com.view.gameWindow.panel.PanelMediator;
	import com.view.gameWindow.panel.panels.bag.BagDataManager;
	import com.view.gameWindow.panel.panels.task.constants.TaskStates;
	import com.view.gameWindow.scene.entity.constants.EntityTypes;
	import com.view.gameWindow.scene.entity.entityItem.autoJob.AutoJobManager;
	import com.view.gameWindow.util.HtmlUtils;
	
	import flash.events.MouseEvent;

	public class TrailerMouseHandler
	{
		private var panel:TrailerPanel;
		private var skin:MCTrailerPanel;

		private var progressGroup:ProgressGroup;


		public function TrailerMouseHandler(panel:TrailerPanel)
		{
			this.panel = panel;
			skin = panel.skin as MCTrailerPanel;
			skin.addEventListener(MouseEvent.CLICK,onClickFunc);
		}		
		
		protected function onClickFunc(event:MouseEvent):void
		{
			switch(event.target)
			{
				case skin.btnClose:
					PanelMediator.instance.switchPanel(PanelConst.TYPE_TRAILER_PANEL);
					break;
				case skin.btn1:
					onDealRefresh();
					break;
				case skin.btn2:
					onDealRequestTrailer();
					break;
				case skin.protectSingleBtn1:
					dealSingleBtn1();
					break;
				case skin.protectSingleBtn2:
					dealSingLeBtn2();
					break;
			}
		}
		
		private function dealSingLeBtn2():void
		{
			if(skin.protectSingleBtn2.selected==true)
			{
				if(BagDataManager.instance.goldUnBind<50)
				{
					Alert.message(StringConst.TRAILER_STRING_39);
					skin.protectSingleBtn2.selected=false;
					return ;
				}
				Alert.message(StringConst.TRAILER_STRING_27);
			}
		}
		
		private function onDealRequestTrailer():void
		{
			var trailerData:TrailerData = TrailerDataManager.getInstance().trailerData;
			if(trailerData.count>=trailerData.totalCount)
			{
				Alert.warning(StringConst.TRAILER_STRING_28);
				return ;
			}
			if(trailerData.state==TaskStates.TS_DOING||trailerData.state==TaskStates.TS_CAN_SUBMIT)
			{
				Alert.warning(StringConst.TRAILER_STRING_29);
				return ;
			}

			var param:int=0;
			if(skin.protectSingleBtn2.selected==true)
			{
				param=1;
			}
			var taskCfgData:TaskCfgData = TrailerDataManager.getInstance().getTasktrailerCfg();
			if(taskCfgData==null)return;
			TrailerDataManager.getInstance().requestTrailer(taskCfgData.id,param);
			PanelMediator.instance.switchPanel(PanelConst.TYPE_TRAILER_PANEL);
			PanelMediator.instance.switchPanel(PanelConst.TYPE_TRAILER_HINT);
			
			var task:TaskCfgData = TrailerDataManager.getInstance().getTasktrailerCfg();
			if(task)
			{
				AutoJobManager.getInstance().setAutoTargetData(task.end_npc,EntityTypes.ET_NPC);
			}
		}		
		
		private function dealSingleBtn1():void
		{
			if(skin.protectSingleBtn1.selected==true)
			{
				TrailerDataManager.getInstance().refreshTrailerId=panel.combox.selectedIndex+1;
			}else
			{
				TrailerDataManager.getInstance().refreshTrailerId=0;
			}
		}
		
		private function onDealRefresh():void
		{
			var trailerData:TrailerData = TrailerDataManager.getInstance().trailerData;
			if(trailerData.count>=trailerData.totalCount)
			{
				Alert.warning(StringConst.TRAILER_STRING_28);
				return ;
			}
			if(trailerData.state==TaskStates.TS_DOING||trailerData.state==TaskStates.TS_CAN_SUBMIT)
			{
				Alert.warning(StringConst.TRAILER_STRING_29);
				return ;
			}
			
			if(trailerData.quality>=TrailerDataManager.getInstance().refreshTrailerId&&TrailerDataManager.getInstance().refreshTrailerId!=0)
			{
				Alert.warning(StringConst.TRAILER_STRING_37);
				return ;
			}
			
			if(skin.protectSingleBtn1.selected==false)
			{
				refreshTrailer();
				return;
			}
			
			if(progressGroup!=null&&progressGroup.parent!=null)
			{
				clearProgressGroup();
				return;
			}
		
			progressGroup = new ProgressGroup();
			progressGroup.setStarFunc(refreshTrailer);
			progressGroup.setCompleFunc(refreshCompleFunc);
			skin.addChild(progressGroup);
			progressGroup.x=210;
			progressGroup.y=150;
			progressGroup.star();
		}
		
		private function refreshCompleFunc():void
		{
			var trailerData:TrailerData = TrailerDataManager.getInstance().trailerData;
			var htmlStr:String = HtmlUtils.createHtmlStr(TrailerConst.colors[trailerData.quality-1],TrailerConst.names[trailerData.quality-1]);
//			progressGroup.addMessage(htmlStr);
			if(trailerData.quality>=TrailerDataManager.getInstance().refreshTrailerId&&TrailerDataManager.getInstance().refreshTrailerId!=0)
			{
				clearProgressGroup();
				return;
			}
		}
		
		private function refreshTrailer():void
		{
			if(TrailerDataManager.getInstance().trailerData.quality==5)
			{
				Alert.warning(StringConst.TRAILER_STRING_23);
				clearProgressGroup();
				return;
			}
			if(TrailerDataManager.getInstance().trailerData.refreshCount<3)
			{
				TrailerDataManager.getInstance().refreshTrailer();
				return;
			}
			
//			if(BagDataManager.instance.goldBind<10)
//			{
//				clearProgressGroup();
//				Alert.show2(StringConst.TRAILER_STRING_34);
//				return;
//			}
			
			if(BagDataManager.instance.goldUnBind<10&&BagDataManager.instance.goldBind<10)
			{
				Alert.warning(StringConst.TRAILER_STRING_33);
				clearProgressGroup();
				return;
			}
			
			TrailerDataManager.getInstance().refreshTrailer();
		}
		
		private function clearProgressGroup():void
		{
			if(progressGroup!=null)
			{
				progressGroup.parent&&progressGroup.parent.removeChild(progressGroup);
				progressGroup.destroy();
			}
			progressGroup=null;
		}
		
		public function destroy():void
		{
			TrailerDataManager.getInstance().refreshTrailerId=0;
			clearProgressGroup();
			skin.removeEventListener(MouseEvent.CLICK,onClickFunc);
		}
	}
}