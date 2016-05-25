package com.view.gameWindow.panel.panels.activityNow
{
    import com.greensock.TweenMax;
    import com.model.configData.ConfigDataManager;
    import com.model.configData.cfgdata.ActivityCfgData;
    import com.model.configData.cfgdata.MapRegionCfgData;
    import com.model.configData.cfgdata.NpcCfgData;
    import com.model.consts.ConstActivityNow;
    import com.model.consts.StringConst;
    import com.model.dataManager.TeleportDatamanager;
    import com.model.gameWindow.rsr.RsrLoader;
    import com.view.gameWindow.mainUi.MainUiMediator;
    import com.view.gameWindow.panel.PanelConst;
    import com.view.gameWindow.panel.PanelMediator;
    import com.view.gameWindow.panel.panelbase.PanelBase;
    import com.view.gameWindow.panel.panels.daily.DailyDataManager;
    import com.view.gameWindow.panel.panels.onhook.AutoSystem;
    import com.view.gameWindow.panel.panels.roleProperty.RoleDataManager;
    import com.view.gameWindow.panel.panels.task.TaskDataManager;
    import com.view.gameWindow.scene.GameFlyManager;
    import com.view.gameWindow.scene.entity.constants.EntityTypes;
    import com.view.gameWindow.scene.entity.entityItem.autoJob.AutoJobManager;
    import com.view.gameWindow.tips.rollTip.RollTipMediator;
    import com.view.gameWindow.tips.rollTip.RollTipType;
    import com.view.gameWindow.util.TimerManager;
    import com.view.newMir.NewMirMediator;
    
    import flash.display.MovieClip;
    import flash.events.MouseEvent;
    import flash.geom.Point;
    import flash.geom.Rectangle;
    import flash.text.TextFormat;
    import flash.utils.Dictionary;

    public class PanelActivityNow extends PanelBase
	{
		public function PanelActivityNow()
		{
			super();
		}
		
		override protected function initSkin():void
		{
            var skin:McActivityNowIcon = new McActivityNowIcon();
			_skin = skin;
			skin.mcBg.resUrl = ConstActivityNow.getResUrlBig(activityCfgData.id);
			addChild(_skin);
			skin.btnNpc.buttonMode = true;
			skin.btnNpc.alpha = 0;
			skin.btnName.buttonMode = true;
			skin.btnName.alpha = 0;
//			setTitleBar(skin.mcDrag);
		}
		
		override protected function initData():void
		{
			initText();
			_skin.addEventListener(MouseEvent.CLICK,onClick);
			if(activityCfgData.secondToStart>0){
				TimerManager.getInstance().add(1000,initText);
			}
//			skin.txtActivityName.
            handlerEffect();
		}
		
		protected function onClick(event:MouseEvent):void
		{
			// TODO Auto-generated method stub
            var skin:McActivityNowIcon = _skin as McActivityNowIcon;
			switch (event.target)
			{
				default :
					break;
				case skin.btnShoe:
				case skin.btnNpc:
					if (RoleDataManager.instance.stallStatue)
					{
						RollTipMediator.instance.showRollTip(RollTipType.ERROR, StringConst.STALL_PANEL_0019);
						return;
					}
			}
			if(event.target == skin.btnClose)
			{
                closeHandler();
			}
			else if(event.target == skin.btnShoe)
			{
				if(!activityCfgData)
					return;
				var npcCfgData:NpcCfgData = ConfigDataManager.instance.npcCfgData(activityCfgData.npc);
				TeleportDatamanager.instance.setTargetEntity(activityCfgData.npc,EntityTypes.ET_NPC);
				
				TeleportDatamanager.instance.requestTeleportPostioin(npcCfgData.mapid,npcCfgData.teleport_x,npcCfgData.teleport_y);
				
				AutoSystem.instance.stopAuto();
				closeHandler();
//				GameFlyManager.getInstance().flyToMapByNPC(activityCfgData.npc);
			}
			else if(event.target == skin.btnName)
			{
				PanelMediator.instance.openDefaultIndexPanel(PanelConst.TYPE_DAILY,DailyDataManager.instance.tabActivity);
			}
			else if(event.target == skin.btnNpc)
			{
				dealTxtEnter();
			}
		}
		
		private function dealTxtEnter():void
		{
			var actCfgData:ActivityCfgData = activityCfgData;
			if(!actCfgData)
				return;
			var npcId:int = actCfgData.npc;
			var born_region:int = actCfgData.born_region;
			if(npcId)
			{
				AutoJobManager.getInstance().setAutoTargetData(npcId,EntityTypes.ET_NPC);
				closeHandler();
				
			}
			else if(born_region)
			{
				var mapRegionCfgData:MapRegionCfgData = ConfigDataManager.instance.mapRegionCfgData(born_region);
				AutoJobManager.getInstance().setAutoFindPathPos(mapRegionCfgData.randomPoint, mapRegionCfgData.map_id, 0);
			}
			else
			{
				trace("TabDailyActivityMouseHandle.dealTxtEnter() 配置错误");
			}
		}
		
		private function initText():void
		{
			// TODO Auto Generated method stub
            var skin:McActivityNowIcon = _skin as McActivityNowIcon;
			var cfgDt:ActivityCfgData = activityCfgData;
			var format:TextFormat =  skin.txtActivityName.defaultTextFormat;
			format.underline = true;
			skin.txtActivityName.defaultTextFormat = format;
			skin.txtActivityName.setTextFormat(format);
			var format1:TextFormat =  skin.txtNpc.defaultTextFormat;
			format1.underline = true;
			skin.txtNpc.defaultTextFormat = format1;
			skin.txtNpc.setTextFormat(format1);		
			
			skin.txtOpen.text = StringConst.ACTIVITY_OOO2;
			skin.txtActivityName.text = activityCfgData.name;
			skin.txtReward.text = getReward();
			skin.txtTime.text = activityCfgData.currentActvTimeCfgDtToEnter.today_start_to_end;
			
			if(activityCfgData.isInActv){
				skin.txtTimeToStart.visible = false;
				if(activityCfgData.npc!=0)
				{
					skin.btnNpc.visible = true;
					skin.txtNpc.visible = true;
					skin.btnShoe.visible = true;
					skin.txtNpc.text = ConfigDataManager.instance.npcCfgData(activityCfgData.npc).name;
				}
				else
				{
					skin.btnNpc.visible = false;
					skin.txtNpc.visible = false;
					skin.btnShoe.visible = false;
				}
				TimerManager.getInstance().remove(initText);
			}else{
				skin.txtTimeToStart.visible = true;
				skin.txtNpc.visible = false;
				skin.btnShoe.visible = false;
				skin.btnNpc.visible = false;
				skin.txtTimeToStart.text = (int(activityCfgData.secondToStart/60)+1)+StringConst.ACTIVITY_0003;
			}
		}
		
		private function getReward():String
		{
			// TODO Auto Generated method stub
			var string:String = StringConst.ACTIVITY_0004;
			var str:String = activityCfgData.reward;
			var arr:Array = str.split("|");
			for(var i:int = 0;i<arr.length;i++)
			{
				string += ConfigDataManager.instance.itemCfgData(int((arr[i] as String).charAt(0))).name;
				if(i<arr.length-1)
					string += "、";
			}
			return string;
		}
		
		override protected function addCallBack(rsrLoader:RsrLoader):void
		{
            var skin:McActivityNowIcon = _skin as McActivityNowIcon;
			rsrLoader.addCallBack(skin.btnShoe,function(mc:MovieClip):void
			{
				skin.btnShoe.buttonMode = true;
			});
		}
		
		private function get activityCfgData():ActivityCfgData
		{
			var actvCfgDts:Dictionary = ConfigDataManager.instance.activityCfgDatas();
			var actvCfgDt:ActivityCfgData;
			var nextCfgDt:ActivityCfgData;
			for each(actvCfgDt in actvCfgDts)
			{
				var boolean:Boolean = actvCfgDt.secondToEnter != int.MIN_VALUE && actvCfgDt.secondToEnter != int.MAX_VALUE;
				if(!boolean)
				{
					continue;
				}
				if(actvCfgDt.isEnterOpen)
				{
					
					return actvCfgDt;
				}
				else
				{
					if(!nextCfgDt || actvCfgDt.secondToEnter < nextCfgDt.secondToEnter)
					{
						nextCfgDt = actvCfgDt;
					}
				}
			}
			if(nextCfgDt.secondToStart > 4*60)
				nextCfgDt = null;
			return nextCfgDt;
		}

        override public function setPostion():void
        {
            var mc:MovieClip = MainUiMediator.getInstance().activityNow.skin;
            var popPoint:Point = mc.parent.localToGlobal(new Point(mc.btn.x + (mc.btn.width) >> 1, mc.btn.y));
            x = popPoint.x;
            y = popPoint.y;
        }

        override public function resetPosInParent():void
        {
            var rect:Rectangle = getPanelRect();
            var newMirMediator:NewMirMediator = NewMirMediator.getInstance();
            var newX:int = int((newMirMediator.width - rect.width - 260));
            var newY:int = 210;
            x = newX;
            y = newY;
        }

        private function handlerEffect():void
        {
            var rect:Rectangle = getPanelRect();
            var newMirMediator:NewMirMediator = NewMirMediator.getInstance();
            var newX:int = int((newMirMediator.width - rect.width - 260));
            var newY:int = 210;

            TweenMax.fromTo(this, 1, {alpha: 0, scaleX: 0, scaleY: 0}, {
                x: newX, y: newY, alpha: 1, scaleX: 1, scaleY: 1, onComplete: function ():void
                {
                    TweenMax.killTweensOf(this);
                }
            });
        }

        public function closeHandler():void
        {
            alpha = 1;
            var mc:MovieClip = MainUiMediator.getInstance().activityNow.skin;
            var popPoint:Point = mc.parent.localToGlobal(new Point(mc.btn.x + (mc.btn.width) >> 1, mc.btn.y));

            TweenMax.to(this, 1, {
                x: popPoint.x, y: popPoint.y, alpha: 0, scaleX: 0, scaleY: 0, onComplete: function ():void
                {
                    TweenMax.killTweensOf(this);
                    PanelMediator.instance.closePanel(PanelConst.TYPE_ACTIVITY_NOW);
                }
            });
        }

		override public function destroy():void
		{
			TimerManager.getInstance().remove(initText);
            TweenMax.killTweensOf(this);
			super.destroy();
		}
		
	}
}