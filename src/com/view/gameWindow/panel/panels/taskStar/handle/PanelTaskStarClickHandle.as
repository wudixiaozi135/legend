package com.view.gameWindow.panel.panels.taskStar.handle
{
    import com.model.business.gameService.constants.GameServiceConstants;
    import com.model.business.gameService.socketManager.ClientSocketManager;
    import com.model.configData.ConfigDataManager;
    import com.model.configData.cfgdata.TaskCfgData;
    import com.model.consts.StringConst;
    import com.model.gameWindow.rsr.RsrLoader;
    import com.pattern.Observer.IObserver;
    import com.view.gameWindow.common.Alert;
    import com.view.gameWindow.panel.PanelConst;
    import com.view.gameWindow.panel.PanelMediator;
    import com.view.gameWindow.panel.panels.bag.BagDataManager;
    import com.view.gameWindow.panel.panels.prompt.Panel1BtnPromptData;
    import com.view.gameWindow.panel.panels.task.TaskDataManager;
    import com.view.gameWindow.panel.panels.task.constants.TaskStates;
    import com.view.gameWindow.panel.panels.taskStar.McTaskStar;
    import com.view.gameWindow.panel.panels.taskStar.PanelTaskStar;
    import com.view.gameWindow.panel.panels.taskStar.data.PanelTaskStarDataManager;
    import com.view.gameWindow.tips.rollTip.RollTipMediator;
    import com.view.gameWindow.tips.rollTip.RollTipType;
    import com.view.gameWindow.util.FilterUtil;
    import com.view.gameWindow.util.HtmlUtils;
    import com.view.gameWindow.util.Progress.Progress;
    
    import flash.display.MovieClip;
    import flash.events.MouseEvent;
    import flash.utils.ByteArray;
    import flash.utils.Endian;
    
    import mx.utils.StringUtil;

    /**
     * 星级任务面板点击处理
     * @author Administrator
     */
    public class PanelTaskStarClickHandle implements IObserver
    {
        private var _panel:PanelTaskStar;
        private var _mc:McTaskStar;
		private var _isAuto:Boolean;//是否自动升星
		private var _progress:Progress;

        public function PanelTaskStarClickHandle(panel:PanelTaskStar)
        {
			PanelTaskStarDataManager.instance.attach(this);
			var rsr:RsrLoader = new RsrLoader();
            _panel = panel;
			
            _mc = _panel.skin as McTaskStar;
            _mc.addEventListener(MouseEvent.CLICK, onClick, false, 0, true);
			
			_progress = new Progress();
			_progress.x = int(_mc.btnVisible.x + _mc.btnVisible.width/2 - _progress.width/2);
			_progress.y = int(_mc.btnVisible.y - _progress.height - 30);
        }
		
		public function get isInProgress():Boolean
		{
			return _progress._isShow;
		}

        protected function onClick(event:MouseEvent):void
        {
            switch (event.target)
            {
                case _mc.btnClose:
                    dealClose();
                    break;
                case _mc.mcReceiveLayer.btnRefresh://刷新星级
                    refreshHandler();
                    break;
                case _mc.mcReceiveLayer.btnReceive://接取按钮
                    handlerReceiveTask();
                    break;
                case _mc.mcRewardLayer.txtReward1://三倍奖励
                    handlerReward(3);
                    break;
                case _mc.mcRewardLayer.txtReward2://二倍奖励
					if(PanelTaskStarDataManager.instance.isReal == 0 && Boolean(PanelTaskStarDataManager.instance.isFree))
					{
						handlerReward(3);
					}
					else
					{
                  	  	handlerReward(2);
					}
                    break;
                case _mc.mcRewardLayer.txtReward3://单倍奖励
					if(PanelTaskStarDataManager.instance.isReal == 0 && Boolean(PanelTaskStarDataManager.instance.isFree))
					{
						handlerReward(3);
					}
					else
					{
                   	 	handlerReward(1);
					}
                    break;
				case _mc.btnVisible:
					dealBtnPrompt();
					break;
				case _mc.mcReceiveLayer.btnZoom://增加次数
					_mc.mcReceiveLayer.btnZoom.selected = true;
//					Alert.show2("成功增加一次任务次数");
//					Alert.show3("成功增加一次任务次数");
					break;
				
				case _mc.mcReceiveLayer.protectSingleBtn:
					_mc.mcReceiveLayer.protectSingleBtn.selected = !_mc.mcReceiveLayer.protectSingleBtn.selected;
					PanelTaskStarDataManager.instance.sendSetting(!_mc.mcReceiveLayer.protectSingleBtn.selected ? 1 : 0);
					break;
                default :
                    break;
            }
        }

        private function refreshHandler():void
        {
//            if (PanelTaskStarDataManager.instance.state == TaskStates.TS_DOING)
//            {
//                RollTipMediator.instance.showRollTip(RollTipType.ERROR, StringConst.TASK_STAR_PANEL_0065);
//                return;
//            }
            if (!_progress._isShow)
            {
//                if (_mc.mcReceiveLayer.protectSingleBtn.selected)
				
				if(PanelTaskStarDataManager.instance.isReal == 0 && Boolean(PanelTaskStarDataManager.instance.isFree))
				{
					dealUpgrade(false);
					return;
				}
				
				if(PanelTaskStarDataManager.instance.setting)
                {
					if(!showRollTips())
					{
                   		_isAuto = true;
                   	 	setPromptBtn();
					}
                }
                else
                {
                    _isAuto = false;
                    dealUpgrade();
                }
            }
        }
        private function handlerReceiveTask():void
        {
            if (_mc.mcReceiveLayer.txtBtnReceive.text == StringConst.TASK_STAR_PANEL_0064)
            {
                dealClose();
            }
			else
            {
				if(PanelTaskStarDataManager.instance.maxStar < getTopStar(0))
				{
					if(PanelTaskStarDataManager.instance.isReal == 0 && Boolean(PanelTaskStarDataManager.instance.isFree))
					{
						dealUpgrade(false);
					}
				}
				TaskDataManager.instance.setAutoTask(false,"PanelTaskStarClickHandle::handlerReceiveTask");
                checkReceiveTask(PanelTaskStarDataManager.instance.newTid);
            }
        }
		
		private function dealBtnPrompt():void
		{
			showProgress(false);
		}
		
		private function setPromptBtn():void
		{
			if (PanelTaskStarDataManager.instance.selected == false)
			{
				var msg1:String = StringConst.TASK_STAR_PANEL_0056;
				Alert.show3(msg1, function ():void
				{
					dealAutoUpgrade();
				}, null, function (bol:Boolean):void
				{
					PanelTaskStarDataManager.instance.selected = bol;
				}, null, StringConst.PROMPT_PANEL_0036,"","",null,"left");
			} else
			{
				dealAutoUpgrade();
			}
		}
		
		private function dealAutoUpgrade():void
		{
			if(showRollTips())
			{
				return;
			}
			
			showProgress(true,600,dealUpgrade);
		}
		
		private function showProgress(show:Boolean,time:int = 0,completeCallback:Function = null):void
		{
			if(!_progress)
			{
				return;
			}
			
			if(show)
			{
				if(completeCallback != null)
				{
					_progress.compleFunc = completeCallback;
				}
				
				if(time > 0)
				{
					_progress.setProgressInfo(time, StringConst.TASK_STAR_PANEL_0055);
				}
				
				_mc.addChild(_progress);
				_progress.show();
				_mc.btnprompt.visible = true;
				_mc.btnVisible.visible = true;
				fadeBg(true);
			}
			else
			{
				if(_mc.contains(_progress))
				{
					_mc.removeChild(_progress);
				}
				_progress.hide();
				_mc.btnprompt.visible = false;
				_mc.btnVisible.visible = false;
				fadeBg(false);
			}
		}
		
		public function update(proc:int=0):void
		{
			if(proc == GameServiceConstants.SM_TASK_STAR_INFO)
			{
				if(_progress._isShow)
				{
					if(showRollTips())
					{
						showProgress(false);
					}
					else
					{
						showProgress(true);
					}
				}
			}
		}
		
		private function fadeBg(isFade:Boolean):void
		{
			if(isFade)
			{
				_mc.rewardContainer.filters = [FilterUtil.getGrayfiltes()];
				_mc.rewardContainer.alpha = 0.3;
			}
			else
			{
				_mc.rewardContainer.filters = null;
				_mc.rewardContainer.alpha = 1;
			}
		}
		
		

        public function checkReceiveTask(tid:int):void
        {
			var costDes:String = PanelTaskStarDataManager.instance.costDes;
            if (PanelTaskStarDataManager.instance.isNumUseUp)
            {
                RollTipMediator.instance.showRollTip(RollTipType.ERROR, StringConst.TASK_STAR_PANEL_0031);
                dealClose();
                return;
            }
			
			if(PanelTaskStarDataManager.instance.isFree != 1)
			{
				if(!PanelTaskStarDataManager.instance.isCostEnough)
				{
					Alert.warning(StringConst.TIP_GOLD_NOT_ENOUGH);
					return;
				}
				
				if(PanelTaskStarDataManager.instance.addNumSelected)
				{
					dealReceive();
				}
				else
				{
					Alert.show3(StringUtil.substitute(StringConst.TASK_STAR_PANEL_0066,costDes),dealReceive,null,function (bol:Boolean):void
					{
						PanelTaskStarDataManager.instance.addNumSelected = bol;
					}, null, StringConst.PROMPT_PANEL_0036,"","",null,"left");
				}
				return;
			}
			
			if(PanelTaskStarDataManager.instance.isComplete)
			{
				return;
			}
			
			dealReceive();
           
        }
		
		private function dealReceive():void
		{
			var ctid:int = PanelTaskStarDataManager.instance.tid;
			var taskCfgDataC:TaskCfgData = ConfigDataManager.instance.taskCfgData(ctid);
			var state:int = PanelTaskStarDataManager.instance.state;
			if (taskCfgDataC && state == TaskStates.TS_DOING)
			{
				dealClose();
				
				
				//                Panel1BtnPromptData.strName = StringConst.TASK_STAR_PANEL_0019;
				//                var strContent:String = StringConst.TASK_STAR_PANEL_0200 + "<br>";
				//                var currentStar:int = PanelTaskStarDataManager.instance.currentStar;
				//                var currentTaskName:String = PanelTaskStarDataManager.instance.currentTaskName;
				//                strContent += HtmlUtils.createHtmlStr(0x00ff00, currentStar + StringConst.TASK_STAR_PANEL_0018 + currentTaskName) + "<br>";
				//                strContent += StringConst.TASK_STAR_PANEL_0201 + "<br>";
				//                var taskCfgData2:TaskCfgData = ConfigDataManager.instance.taskCfgData(tid);
				//                var star:int = PanelTaskStarDataManager.instance.getStar(taskCfgData2.type);
				//                strContent += HtmlUtils.createHtmlStr(0x00ff00, star + StringConst.TASK_STAR_PANEL_0018 + taskCfgData2.name) + "<br>";
				//                strContent += HtmlUtils.createHtmlStr(0xff0000, StringConst.TASK_STAR_PANEL_0202);
				//                Panel1BtnPromptData.strContent = strContent;
				//                Panel1BtnPromptData.strBtn = StringConst.TASK_STAR_PANEL_0021;
				//                Panel1BtnPromptData.funcBtn = sendData;
				//                Panel1BtnPromptData.funcBtnParam = tid;
				////                Panel1BtnPromptData.funcCloseBtn = dealClose;
				//                PanelMediator.instance.switchPanel(PanelConst.TYPE_1BTN_PROMPT);
			} else
			{
				sendData(PanelTaskStarDataManager.instance.newTid);
				dealClose();
			}
		}
        
        /**默认按除魔，采矿，挖掘顺序返回*/
        private function getDefaultStarType():int
        {
            var chumo_star:int = PanelTaskStarDataManager.instance.chumo_star;
            var caikuang_star:int = PanelTaskStarDataManager.instance.caikuang_star;
            var wajue_star:int = PanelTaskStarDataManager.instance.wajue_star;
            if (chumo_star == PanelTaskStarDataManager.FULL_STAR)
            {
                return PanelTaskStarDataManager.instance.chumo_tid;
            }
            if (caikuang_star == PanelTaskStarDataManager.FULL_STAR)
            {
                return PanelTaskStarDataManager.instance.caikuang_tid;
            }
            if (wajue_star == PanelTaskStarDataManager.FULL_STAR)
            {
                return PanelTaskStarDataManager.instance.wajue_tid;
            }
            return 0;
        }

        /*领奖*/
        private function handlerReward(type:int):void
        {
            PanelTaskStarDataManager.instance.sendData(type,PanelTaskStarDataManager.instance.isReal==0 && Boolean(PanelTaskStarDataManager.instance.isFree));
        }

        private function handlerSelect(mc:MovieClip, taskType:int):void
        {
			if(PanelTaskStarDataManager.instance.isComplete)
			{
				return;
			}
            _mc.mcSelect.x = mc.x;
            _mc.mcSelect.y = mc.y;
            _mc.mcSelect.visible = true;
            PanelTaskStarDataManager.selectTid = taskType;
//            _mc.btnTxt.text = StringConst.TASK_STAR_PANEL_0006;//接受任务
        }

        private function dealClose():void
        {
            PanelMediator.instance.closePanel(PanelConst.TYPE_TASK_STAR);
            PanelTaskStarDataManager.selectTid = -1;
        }

        private function checkExistCurrentTask(tid:int):void
        {
            if (PanelTaskStarDataManager.instance.isNumUseUp)
            {
                trace("今日星级任务次数已用完");
                RollTipMediator.instance.showRollTip(RollTipType.ERROR, StringConst.TASK_STAR_PANEL_0031);
                return;
            }
            var taskCfgData:TaskCfgData = ConfigDataManager.instance.taskCfgData(tid);
            var ctid:int = PanelTaskStarDataManager.instance.tid;
            var taskCfgDataC:TaskCfgData = ConfigDataManager.instance.taskCfgData(ctid);
            var state:int = PanelTaskStarDataManager.instance.state;
            if (taskCfgDataC && taskCfgData.type == taskCfgDataC.type)
            {
                var goldUnBind:int = BagDataManager.instance.goldUnBind;
                if (goldUnBind < 50)
                {
                    RollTipMediator.instance.showRollTip(RollTipType.ERROR, StringConst.TASK_STAR_PANEL_0029);
                    return;
                }
//				trace("PanelTaskStarClickHandle.checkExistCurrentTask 使用元宝完成");
                sendQuickDoneData(tid);
            }
            else if (taskCfgDataC && state == TaskStates.TS_DOING)
            {
                Panel1BtnPromptData.strName = StringConst.TASK_STAR_PANEL_0019;
                var strContent:String = StringConst.TASK_STAR_PANEL_0200 + "<br>";
                var currentStar:int = PanelTaskStarDataManager.instance.currentStar;
                var currentTaskName:String = PanelTaskStarDataManager.instance.currentTaskName;
                strContent += HtmlUtils.createHtmlStr(0x00ff00, currentStar + StringConst.TASK_STAR_PANEL_0018 + currentTaskName) + "<br>";
                strContent += StringConst.TASK_STAR_PANEL_0201 + "<br>";
                var taskCfgData2:TaskCfgData = ConfigDataManager.instance.taskCfgData(tid);
                var star:int = PanelTaskStarDataManager.instance.getStar(taskCfgData2.type);
                strContent += HtmlUtils.createHtmlStr(0x00ff00, star + StringConst.TASK_STAR_PANEL_0018 + taskCfgData2.name) + "<br>";
                strContent += HtmlUtils.createHtmlStr(0xff0000, StringConst.TASK_STAR_PANEL_0202);
                Panel1BtnPromptData.strContent = strContent;
                Panel1BtnPromptData.strBtn = StringConst.TASK_STAR_PANEL_0021;
                Panel1BtnPromptData.funcBtn = sendData;
                Panel1BtnPromptData.funcBtnParam = tid;
                PanelMediator.instance.switchPanel(PanelConst.TYPE_1BTN_PROMPT);
            }
            else
            {
                sendData(tid);
            }
        }

        private function sendQuickDoneData(tid:int):void
        {
            var byteArray:ByteArray = new ByteArray();
            byteArray.endian = Endian.LITTLE_ENDIAN;
            byteArray.writeInt(tid);
            ClientSocketManager.getInstance().asyncCall(GameServiceConstants.CM_COMPLETE_TASK_PROGRESS, byteArray);
            PanelMediator.instance.closePanel(PanelConst.TYPE_TASK_STAR);
        }

        /**接取任务*/
        private function sendData(tid:int):void
        {
            var byteArray:ByteArray = new ByteArray();
            byteArray.endian = Endian.LITTLE_ENDIAN;
			byteArray.writeInt(tid);
			byteArray.writeInt(0);
            ClientSocketManager.getInstance().asyncCall(GameServiceConstants.CM_RECEIVE_TASK, byteArray);
			
			if(!PanelTaskStarDataManager.instance.isFree)
			{
				Alert.message(StringConst.TASK_STAR_PANEL_0071);
			}
        }

        private function dealUpgrade(showTip:Boolean = true):void
        {
			if(showTip && showRollTips())
			{
				showProgress(false);
				return;
			}
			
       	 	var byteArray:ByteArray = new ByteArray();
       	 	byteArray.endian = Endian.LITTLE_ENDIAN;
       	 	ClientSocketManager.getInstance().asyncCall(GameServiceConstants.CM_REFRESH_TASK_STAR, byteArray);
			Alert.message(StringUtil.substitute(StringConst.TASK_STAR_PANEL_0068,PanelTaskStarDataManager.UP_STAR_COST));
        }
		
		private function showRollTips():Boolean
		{
			var maxStar:int = PanelTaskStarDataManager.instance.maxStar;
			if (maxStar >= getTopStar(PanelTaskStarDataManager.instance.selectStar))
			{
				trace("您的星级任务已达到满星，无法再刷新");
				if(_isAuto == true)
				{
					RollTipMediator.instance.showRollTip(RollTipType.ERROR, StringConst.TASK_STAR_PANEL_0053);
				}
				else
				{
					RollTipMediator.instance.showRollTip(RollTipType.ERROR, StringConst.TASK_STAR_PANEL_0032);
				}
				return true;
			}
			if (PanelTaskStarDataManager.instance.isNumUseUp)
			{
				trace("今日星级任务次数已用完");
				RollTipMediator.instance.showRollTip(RollTipType.ERROR, StringConst.TASK_STAR_PANEL_0031);
				return true;
			}
			var moneyBind:int = BagDataManager.instance.coinBind;
			var moneyUnBind:int = BagDataManager.instance.coinUnBind;
			if ((moneyBind + moneyUnBind) < PanelTaskStarDataManager.UP_STAR_COST)
			{
				trace("您没有足够的金币，无法刷新星级任务");
				RollTipMediator.instance.showRollTip(RollTipType.SYSTEM, StringConst.TASK_STAR_PANEL_0033);
				return true;
			}
			
			return false;
		}
		
		/**
		 *获取自动升星需要升到几星 
		 * @param selectedIndex
		 * @return 
		 * 
		 */		
		private function getTopStar(selectedIndex:int):int
		{
			if(_isAuto == false)
			{
				return 10;
			}
			else
			{
				switch(selectedIndex)
				{
					case 0:
						return 10;
					case 1:
						return 9;
					case 2:
						return 8;
					case 3:
						return 7;
					case 4:
						return 6;
				}
			}
			return 10;
		}
		
        public function destroy():void
        {
			PanelTaskStarDataManager.instance.detach(this);
			
			showProgress(false);
			if(_progress)
			{
				_progress.destroy();
				_progress = null;
			}
			
			if(_mc)
			{
				_mc.removeEventListener(MouseEvent.CLICK, onClick);
				_mc = null;
			}
            _panel = null;
        }
		
	}
}