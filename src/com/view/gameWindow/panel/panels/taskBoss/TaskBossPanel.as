package com.view.gameWindow.panel.panels.taskBoss
{
	import com.greensock.TweenMax;
	import com.model.business.fileService.UrlBitmapDataLoader;
	import com.model.business.fileService.constants.ResourcePathConstants;
	import com.model.business.fileService.interf.IUrlBitmapDataLoaderReceiver;
	import com.model.business.gameService.constants.GameServiceConstants;
	import com.model.configData.ConfigDataManager;
	import com.model.configData.cfgdata.EquipCfgData;
	import com.model.configData.cfgdata.ItemCfgData;
	import com.model.configData.cfgdata.TaskCfgData;
	import com.model.consts.FontFamily;
	import com.model.consts.ItemType;
	import com.model.consts.SlotType;
	import com.model.consts.StringConst;
	import com.model.consts.ToolTipConst;
	import com.model.gameWindow.rsr.RsrLoader;
	import com.pattern.Observer.IObserver;
	import com.view.gameWindow.common.HighlightEffectManager;
	import com.view.gameWindow.flyEffect.FlyEffectMediator;
	import com.view.gameWindow.mainUi.subuis.chatframe.msg.LinkWord;
	import com.view.gameWindow.mainUi.subuis.chatframe.msg.Message;
	import com.view.gameWindow.mainUi.subuis.chatframe.msg.MessageFactory;
	import com.view.gameWindow.mainUi.subuis.chatframe.msg.MessageFactoryWorld;
	import com.view.gameWindow.mainUi.subuis.tasktrace.TaskTraceItem;
	import com.view.gameWindow.panel.PanelConst;
	import com.view.gameWindow.panel.PanelMediator;
	import com.view.gameWindow.panel.panelbase.PanelBase;
	import com.view.gameWindow.panel.panels.guideSystem.InterObjCollector;
	import com.view.gameWindow.panel.panels.roleProperty.RoleDataManager;
	import com.view.gameWindow.panel.panels.task.TaskDataManager;
	import com.view.gameWindow.panel.panels.task.constants.TaskStates;
	import com.view.gameWindow.panel.panels.task.linkText.LinkText;
	import com.view.gameWindow.panel.panels.vip.VipDataManager;
	import com.view.gameWindow.scene.entity.constants.EntityTypes;
	import com.view.gameWindow.scene.entity.entityItem.autoJob.AutoJobManager;
	import com.view.gameWindow.tips.rollTip.RollTipMediator;
	import com.view.gameWindow.tips.rollTip.RollTipType;
	import com.view.gameWindow.tips.toolTip.TipVO;
	import com.view.gameWindow.tips.toolTip.ToolTipManager;
	import com.view.gameWindow.util.HtmlUtils;
	import com.view.gameWindow.util.UtilColorMatrixFilters;
	import com.view.gameWindow.util.UtilItemParse;
	import com.view.gameWindow.util.UtilNumChange;
	import com.view.gameWindow.util.cell.IconCellEx;
	import com.view.gameWindow.util.cell.ThingsData;
	import com.view.gameWindow.util.scrollBar.IScrollee;
	import com.view.gameWindow.util.scrollBar.ScrollBar;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.events.TextEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.clearInterval;
	import flash.utils.setInterval;
	
	import mx.utils.StringUtil;

	/**
	 * @author wqhk
	 * 2014-8-20
	 */
	public class TaskBossPanel extends PanelBase implements IScrollee,IObserver,IUrlBitmapDataLoaderReceiver
	{
		private static const PROGRESS_WIDTH:int = 625;
		
		private var _scrollBar:ScrollBar;
		private var _scrollRect:Rectangle;
		private var _listCtner:MovieClip;
		private var _ui:McTaskBossPanel;
		
		private var _listItems:Vector.<TaskBossCell>;
		private var _selectedItem:TaskBossCell;
		private var _progressPoint:Vector.<MovieClip>;
		private var _dataManager:TaskBossDataManager;
		private var _msgFactory:MessageFactory;
		private var _msg:Message;
		private var _acceptBtnVisible:Boolean = false;
		
		public function TaskBossPanel()
		{
			super();
			
			_dataManager = TaskBossDataManager.instance;
		}
		
		override public function destroy():void
		{
			InterObjCollector.instance.remove(_ui.acceptBtn);
			InterObjCollector.instance.remove(_ui.btns.btnGiveUp);
			InterObjCollector.instance.remove(_ui.btns.btnDoneNow);
			
			if(_iconLoader)
			{
				_iconLoader.destroy();
				_iconLoader = null;
			}
			_dataManager.detach(this);
			VipDataManager.instance.detach(this);
			RoleDataManager.instance.detach(this);
			ToolTipManager.getInstance().detach(_ui.progressBar);
			ToolTipManager.getInstance().detach(_ui.progressPoint0);
			ToolTipManager.getInstance().detach(_ui.progressPoint1);
			ToolTipManager.getInstance().detach(_ui.progressPoint2);
			ToolTipManager.getInstance().detach(_ui.progressPoint3);
			ToolTipManager.getInstance().detach(_ui.progressBar);
			ToolTipManager.getInstance().detach(_ui.btns.btnDoneNow);
			
			clearHL();
			
			_ui.nameTxt.removeEventListener(TextEvent.LINK,linkHandler);
			removeEventListener(MouseEvent.CLICK,clickHandler);
			clearList();
			super.destroy();
		}
		
		public function clearHL():void
		{
			if(!hlMgr)
			{
				return;
			}
			
			for each(var item:DisplayObject in highlightList)
			{
				hlMgr.hide(item);
			}
			
			hlMgr = null;
		}
		
		
		public function get listContentHeight():Number
		{
			if(_listItems && _listItems.length>0)
			{
				return _listItems.length*_listItems[0].height;
			}
			
			return 0;
		}
		
		public function clearList():void
		{
			if(_listItems && _listItems.length>0)
			{
				for each(var item:TaskBossCell in _listItems)
				{
					item.removeEventListener(MouseEvent.CLICK,itemClickHandler);
					item.removeEventListener(MouseEvent.CLICK,itemStateClickHandler);
					if(item.parent)
					{
						item.parent.removeChild(item);
					}
				}
			}
			_listItems = null;
		}
		
		private function itemClickHandler(e:MouseEvent):void
		{
			var cell:TaskBossCell = TaskBossCell(e.currentTarget); 
			executeSelected(cell);
		}
		
		private function flyRewardPoint(cell:TaskBossCell):void
		{
			var fpoint:Point =new Point(cell.x+40-_scrollRect.x,cell.y+130-_scrollRect.y);
			var endpoint:Point;
			var award:MCflyRewardpoint = new MCflyRewardpoint();
			award.x = fpoint.x;
			award.y = fpoint.y; 
			_ui.addChild(award);
			
			var id:uint = setInterval(function():void
			{
				if(_ui.progressBar)
				{
				 endpoint = new Point((_ui.progressBar.x+_ui.progressBar.maskTop.width-10),_ui.progressBar.y); 
				 TweenMax.fromTo(award,1,{x:fpoint.x,y:fpoint.y},{x:endpoint.x,y:endpoint.y,onComplete:onComplete});
				 clearInterval(id);
				}
			},200);
			
			function onComplete():void
			{
				if(award && award.parent)
				{
					award.parent.removeChild(award);
				}
			}
		}
		protected function executeSelected(cell:TaskBossCell):void
		{
			if(_selectedItem)
			{
				_selectedItem.selected = false;
			}
			
			_selectedItem = cell;
			
			if(_selectedItem)
			{
				_selectedItem.selected = true;
				setDetailInfo(_selectedItem.data);
			}
			else
			{
				setDetailInfo(null);
			}
		}
		
		private var _data:TaskBossData;
		
		protected function setDetailInfo(data:TaskBossData):void
		{
			_data = data;
			if(_msg && _msg.parent)
			{
				_msg.parent.removeChild(_msg);
				_msg = null;
			}
			
			if(!data)
			{
				_ui.nameTxt.htmlText = "";
				_ui.acceptConditionTxt.text = "";
				_ui.rewardTxt.text = "";
				_ui.acceptBtn.visible = false;
				_acceptBtnVisible = false;
				if(_bossIcon && _bossIcon.parent)
				{
					_bossIcon.parent.removeChild(_bossIcon);
				}
				return ;
			}
			
			var linkTxt:String = (data.preHint ? data.preHint : HtmlUtils.createHtmlStr(0x53b436,data.monsterName,12,false,2,FontFamily.FONT_NAME,true,data.monsterId.toString()));
			_ui.nameTxt.htmlText = 
				linkTxt + " "+
				HtmlUtils.createHtmlStr(data.progress < data.monsterNum?0xff0000:0x53b436,String(data.progress<data.monsterNum?data.progress:data.monsterNum) + "/" + data.monsterNum);
			if(data.state == TaskStates.TS_DONE)
			{
				_ui.nameTxt.htmlText = 
					linkTxt + " "+
					HtmlUtils.createHtmlStr(0x53b436,data.monsterNum + "/" + data.monsterNum);
			}
			if(data.costCfgData.unbind_gold>0)
			{
				_ui.txt_00.visible = false;
				_ui.itemBottom.visible = false;
				_ui.acceptConditionTxt.text = StringUtil.substitute(StringConst.TASK_WANT_PANEL_CONDITION_GOLD,data.costCfgData.unbind_gold);
			}
			else if(data.costCfgData.vip>0)
			{
				_ui.itemBottom.visible = true;
				_ui.txt_00.visible = true;
				_ui.acceptConditionTxt.text = StringUtil.substitute(StringConst.TASK_WANT_PANEL_CONDITION_VIP,data.costCfgData.vip);
				_ui.acceptConditionTxt.textColor = VipDataManager.instance.lv < data.costCfgData.vip ?0xff0000:0x00ff00;
			}
			else
			{
				_ui.txt_00.visible = false;
				_ui.itemBottom.visible = false;
				_ui.acceptConditionTxt.text = "";
			}
			
			var ch:UtilNumChange = new UtilNumChange();
			var reward:String = "";
			if(data.costCfgData.exp>0)
			{
				reward += ch.changeNum(data.costCfgData.exp)+StringConst.DUNGEON_PANEL_0015+ " ";
			}
			
			if(data.costCfgData.bind_coin > 0)
			{
				reward += ch.changeNum(data.costCfgData.bind_coin)+StringConst.GOLD_COIN + " ";
			}
			
//			if(data.costCfgData.reward_point > 0)
//			{
//				reward += ch.changeNum(data.costCfgData.reward_point)+StringConst.TASK_WANT_PANEL_0003 + " ";
//			}
			
			if(data.costCfgData.gongxun_point > 0)
			{
				reward += ch.changeNum(data.costCfgData.gongxun_point)+StringConst.TIP_ACHI + " ";
			}
			
			_ui.rewardTxt.text = reward;
			
			var taskCfg:TaskCfgData = ConfigDataManager.instance.taskCfgData(data.id);
			
			var itemStr:String = taskCfg.reward_items;
			
			if(itemStr)
			{
				var items:Array = itemStr.split("|");
				if(!_msgFactory)
				{
					_msgFactory = new MessageFactoryWorld;
					_msgFactory.flagOpen = 0;
				}
				
				var caretInex:int = reward.length;
				var linkWords:Vector.<LinkWord> = new Vector.<LinkWord>;
				var des:String;
				for each(var item:String in items)
				{
					var parts:Array = item.split(":");
					var linkWord:LinkWord;
					if(parts.length == 3)
					{
						var type:int = parseInt(parts[1]);
						switch(type)
						{
							case 2:
								linkWord = LinkWord.createLinkWord(LinkWord.TYPE_EQUIP);
								linkWord.data = LinkWord.joinData(0,parseInt(parts[0]));
								linkWord.type = LinkWord.TYPE_EQUIP;
								break;
							case 1:
								linkWord = LinkWord.createLinkWord(LinkWord.TYPE_ITEM);
								linkWord.data = LinkWord.joinData(parseInt(parts[0]));
								linkWord.type = LinkWord.TYPE_EQUIP;
								break;
						}
						
						if(linkWord)
						{
							linkWord.caretIndexBegin = caretInex;
							des = linkWord.getDescription();
							caretInex += des.length;
							linkWord.caretIndexEnd = caretInex;
							reward += des+"×"+parts[2];
							caretInex = reward.length;
							linkWords.push(linkWord);
						}
						
					}
					
					
				}
				
				var head:String  = LinkWord.encodeMsgHead(linkWords);
				
				_msg = _msgFactory.createMessage("[] " + head + reward,0xFFCC00,300);
				_ui.rewardTxt.text ="";
				_msg.x = _ui.rewardTxt.x;
				_msg.y = _ui.rewardTxt.y;
				
				_ui.rewardTxt.parent.addChild(_msg);
			}
			
			switch(data.state)
			{
				case TaskStates.TS_CAN_SUBMIT:
					_ui.acceptBtn.gotoAndStop(2);
					_ui.acceptBtn.visible = true;
					_acceptBtnVisible = true;
					_ui.btns.visible = false;
					break;
				case TaskStates.TS_DOING:
					_ui.acceptBtn.visible = false;
					_acceptBtnVisible = false;
					_ui.btns.visible = true;
					break;
				case TaskStates.TS_UNKNOWN:
					_ui.acceptBtn.gotoAndStop(1);
					_ui.acceptBtn.visible = true;
					_acceptBtnVisible = true;
					_ui.btns.visible = false;
					break;
				case TaskStates.TS_DONE:
					_ui.acceptBtn.visible = false;
					_acceptBtnVisible = false;
					_ui.btns.visible = false;
					break;
				
			}
			
			if(_iconLoader)
			{
				_iconLoader.destroy();
				_iconLoader = null;
			}
			
			_iconLoader = new UrlBitmapDataLoader(this);
			_iconLoader.loadBitmap(ResourcePathConstants.IMAGE_TASK_BOSS_LOAD+"m"+data.iconId+ResourcePathConstants.POSTFIX_JPG);		
		}
		
		private var _iconLoader:UrlBitmapDataLoader;
		
		private var _bossIcon:Bitmap;
		public function urlBitmapDataReceive(url:String, bitmapData:BitmapData, info:Object):void
		{
			if(!_bossIcon)
			{
				_bossIcon = new Bitmap();
			}
			
			if(_ui.bossIcon)
			{
				_bossIcon.bitmapData = bitmapData;
				_ui.bossIcon.addChild(_bossIcon);
			}
		}
		
		public function urlBitmapDataProgress(url:String, progress:Number, info:Object):void
		{
			
		}
		
		public function urlBitmapDataError(url:String, info:Object):void
		{
			
		}
		
		private function setProgress(value:int):void
		{
			var unitWidth:int = PROGRESS_WIDTH/_dataManager.totalProgressNum;
			
			var progressCfgList:Vector.<TaskBossRewardData> = _dataManager.progressRewardData;
			
			var isSetProgress:Boolean = false;
			
			if(value > _dataManager.totalProgress)
			{
				value = _dataManager.totalProgress;
			}
			var i:int;
			var progressCfg:TaskBossRewardData;
			for(i = progressCfgList.length - 1; i >= 0; --i)
			{
				progressCfg = progressCfgList[i];
				var nextProgressCfg:TaskBossRewardData;
				var unitValue:int;
				var perc:Number;
				var progressWidth:int;
				if(value>=progressCfg.cfgData.reward_point)
				{
					
					if(!isSetProgress)
					{
						nextProgressCfg = progressCfgList[i+1];
						unitValue = nextProgressCfg.cfgData.reward_point - progressCfg.cfgData.reward_point;
						perc = (value-progressCfg.cfgData.reward_point)/unitValue;
	
						
						if(perc>=1)
						{
							perc = 1;
							
							nextProgressCfg.canRewarded = 1;
						}
						
						progressWidth = (i+1)*unitWidth+unitWidth*perc;
						_ui.progressBar.maskTop.width = progressWidth;
						isSetProgress = true;
					}
					
					progressCfg.canRewarded = 1;
				}
				else
				{
					progressCfg.canRewarded = 0;
					
					if(!isSetProgress && i == 0)
					{
						unitValue = progressCfg.cfgData.reward_point;
						perc = value/unitValue;
						
						progressWidth = unitWidth*perc;
						_ui.progressBar.maskTop.width = progressWidth;
						isSetProgress = true;
					}
				}
			}
			
			for(i = 0; i < progressCfgList.length; ++i)
			{
				progressCfg = progressCfgList[i];
				
				var pointMc:MovieClip = _ui["progressPoint"+i];
				
				if(progressCfg.isRewarded)
				{
					pointMc.gotoAndStop(3);
					
					if(highlightList.indexOf(pointMc) != -1)
					{
						hlMgr.hide(pointMc);
					}
				}
				else if(progressCfg.canRewarded)
				{
					pointMc.gotoAndStop(2);
					
					if(highlightList.indexOf(pointMc) == -1)
					{
						if(!hlMgr)
						{
							hlMgr = new HighlightEffectManager();
						}
						
						hlMgr.show(pointMc.parent,pointMc);
						highlightList.push(pointMc);
					}
				}
				else
				{
					pointMc.gotoAndStop(1);
					
					if(highlightList.indexOf(pointMc) != -1)
					{
						hlMgr.hide(pointMc);
					}
				}
			}
			
		}
		
		private var highlightList:Array = [];
		private var hlMgr:HighlightEffectManager;
		public function updateList():void
		{
			clearList();
			
			var data:Vector.<TaskBossData> = TaskBossDataManager.instance.listData;
			
			_listItems = new Vector.<TaskBossCell>();
			
			for(var i:int = 0; i < data.length; ++i)
			{
				var cell:TaskBossCell = new TaskBossCell();
				cell.addEventListener(MouseEvent.CLICK,itemClickHandler,true);	
				cell.data = data[i];
				cell.y = i*cell.height;
				_listItems.push(cell);
				_listCtner.addChild(cell);
				cell.initView();
				cell.setStateBitmap(cell.data.state);
				if(cell.data.state == TaskStates.TS_DONE)
				{
					dealFilters(UtilColorMatrixFilters.GREY_FILTERS,cell);
				}
			}
		}
		
		private function stateBtnTip():String
		{
			return HtmlUtils.createHtmlStr(0xcccc00,StringConst.TASK_WANT_PANEL_0004);		
		}
		
		private function itemStateClickHandler(e:MouseEvent):void
		{
			var data:TaskBossData = _selectedItem.data;
			if(data.state == TaskStates.TS_DOING)
			{
				_dataManager.requestQuickDone(data.id);
			}
		}
		
		public function resetScrollBar():void
		{
			if(_scrollBar)
			{
				var old:int = _scrollBar.scrollRectY;
				_scrollBar.resetScroll();
				scrollTo(old);
			}
		}
		
		private function findCell(id:int):TaskBossCell
		{
			for each(var item:TaskBossCell in _listItems)
			{
				if(item.data.id == id)
				{
					return item;
				}
			}
			
			return null;
		}
		
		private function getLastSelected():TaskBossCell
		{
			if(_selectedItem)
			{
				var cell:TaskBossCell = findCell(_selectedItem.data.id);
				if(cell)
				{
					return cell;
				}
			}
			
			return null
		}
		
		override public function update(proc:int=0):void
		{
			switch(proc)
			{
				case GameServiceConstants.SM_TASK_WANTED_INFO:
					updateList();
					resetScrollBar();
					setProgress(_dataManager.progress);
					if(_listItems.length>0)
					{
						var lastSelected:TaskBossCell = getLastSelected();
						if(lastSelected)
						{
							executeSelected(lastSelected);
						}
						else
						{
							initSelecetedItem();
						}
					}
					else
					{
						executeSelected(null);
					}
					break;
				case GameServiceConstants.SM_TASK_GIVEUPED:
				case GameServiceConstants.SM_TASK_RECEIVED:
					if(_dataManager.newData)
					{
						updateListItem(_dataManager.newData);
					}
					break;
				case GameServiceConstants.SM_TASK_SUBMITTED:
					 flyRewardPoint(_selectedItem);
					break;
				case GameServiceConstants.SM_CHR_INFO:
					if(RoleDataManager.instance.lv > RoleDataManager.instance.oldLv)
					{
						updateList();
					}
					break;
				
				
			}
			if(_selectedItem)
			{
				_ui.acceptConditionTxt.textColor = VipDataManager.instance.lv < _selectedItem.data.costCfgData.vip?0xff0000:0x00ff00;
			}
			updateItemState();
			super.update(proc);
		}
		
		private function initSelecetedItem():void
		{
			for each(var item:TaskBossCell in _listItems)
			{
				if(item.data.state == TaskStates.TS_DOING || item.data.state == TaskStates.TS_CAN_SUBMIT)
				{
					executeSelected(item);
					return;
				}
			}
			for each(var cell:TaskBossCell in _listItems)
			{
				if(cell.data.state == TaskStates.TS_UNKNOWN)
				{
					executeSelected(cell);
					return;
				}
			}
			executeSelected(_listItems[0]);
		}
		
		private function updateItemState():void
		{
			for each(var cell:TaskBossCell in _listItems)
			{
				cell.setStateBitmap(cell.data.state);
				if(cell.data.state == TaskStates.TS_DONE)
				{
					dealFilters(UtilColorMatrixFilters.GREY_FILTERS,cell);
				}
			}
			
		}

		public static const HEIGHT:int = 382;
		public static const WIDTH:int = 309;
		
		override protected function addCallBack(rsrLoader:RsrLoader):void
		{
			
			rsrLoader.addCallBack(_ui.mcScrollBar,function (mc:MovieClip):void//滚动条资源加载完成后构造滚动条控制类
			{
				if(!_scrollBar)
				{
					_scrollBar = new ScrollBar(_skin.parent as IScrollee,mc,0,_ui.listCtner);
					_scrollBar.resetHeight(HEIGHT);
					
					TaskBossDataManager.instance.requestTaskData();
				}
				
			});
			
			rsrLoader.addCallBack(_ui.acceptBtn,function (mc:MovieClip):void
			{
				_ui.acceptBtn.useHandCursor = true;
				_ui.acceptBtn.buttonMode = true;
				_ui.acceptBtn.visible = _acceptBtnVisible;
				
				InterObjCollector.instance.add(mc);
			});
			
			rsrLoader.addCallBack(_ui.btns.btnGiveUp,function (mc:MovieClip):void
			{
				mc.useHandCursor = true;
				mc.buttonMode = true;
				InterObjCollector.instance.add(mc);
			});
			
			rsrLoader.addCallBack(_ui.btns.btnDoneNow,function (mc:MovieClip):void
			{
				mc.useHandCursor = true;
				mc.buttonMode = true;
				InterObjCollector.instance.add(mc);
			});
			
			//
			var tipVO:TipVO;
			rsrLoader.addCallBack(_ui.progressPoint0,function (mc:MovieClip):void
			{
				mc.mouseEnabled = true;
				mc.mouseChildren = true;
				mc.useHandCursor = true;
				mc.buttonMode = true;
				
				tipVO = new TipVO();
				
				tipVO.tipType = ToolTipConst.TEXT_TIP;
				tipVO.tipData = rewardTip0;
				ToolTipManager.getInstance().hashTipInfo(mc,tipVO);
				ToolTipManager.getInstance().attach(mc);
			});
			
			rsrLoader.addCallBack(_ui.progressPoint1,function (mc:MovieClip):void
			{
				mc.mouseEnabled = true;
				mc.mouseChildren = true;
				mc.useHandCursor = true;
				mc.buttonMode = true;
				
				tipVO = new TipVO();
				
				tipVO.tipType = ToolTipConst.TEXT_TIP;
				tipVO.tipData = rewardTip1;
				ToolTipManager.getInstance().hashTipInfo(mc,tipVO);
				ToolTipManager.getInstance().attach(mc);
			});
			
			rsrLoader.addCallBack(_ui.progressPoint2,function (mc:MovieClip):void
			{
				mc.mouseEnabled = true;
				mc.mouseChildren = true;
				mc.useHandCursor = true;
				mc.buttonMode = true;
				
				tipVO = new TipVO();
				
				tipVO.tipType = ToolTipConst.TEXT_TIP;
				tipVO.tipData = rewardTip2;
				ToolTipManager.getInstance().hashTipInfo(mc,tipVO);
				ToolTipManager.getInstance().attach(mc);
			});
			
			rsrLoader.addCallBack(_ui.progressPoint3,function (mc:MovieClip):void
			{
				mc.mouseEnabled = true;
				mc.mouseChildren = true;
				mc.useHandCursor = true;
				mc.buttonMode = true;
				
				tipVO = new TipVO();
				
				tipVO.tipType = ToolTipConst.TEXT_TIP;
				tipVO.tipData = rewardTip3;
				ToolTipManager.getInstance().hashTipInfo(mc,tipVO);
				ToolTipManager.getInstance().attach(mc);
			});
		}
		
		override protected function initSkin():void
		{
			_ui = new McTaskBossPanel();
			_skin = _ui;
			addChild(_skin);
			setTitleBar(_ui.mcTitleBar);
			
			_listCtner = _ui.listCtner;
			
			_scrollRect = new Rectangle(0,0,WIDTH,HEIGHT);
			_listCtner.scrollRect = _scrollRect;
			
			_progressPoint = new Vector.<MovieClip>;
			
			_ui.progressBar.maskTop.width = 0;
			addEventListener(MouseEvent.CLICK,clickHandler);
			_ui.nameTxt.addEventListener(TextEvent.LINK,linkHandler);
			
			_ui.txtName.text = StringConst.TIP_ACHI+StringConst.TASK_0015
			
			var tipVO:TipVO = new TipVO();
			tipVO.tipType = ToolTipConst.TEXT_TIP;
			tipVO.tipData = progressTip;
			ToolTipManager.getInstance().hashTipInfo(_ui.progressBar,tipVO);
			ToolTipManager.getInstance().attach(_ui.progressBar);
			
			
			_dataManager.attach(this);
			VipDataManager.instance.attach(this);
			RoleDataManager.instance.attach(this);
			executeSelected(null);
			
			var tipVO2:TipVO = new TipVO();
			
			tipVO2.tipType = ToolTipConst.TEXT_TIP;
			tipVO2.tipData = stateBtnTip;
			ToolTipManager.getInstance().hashTipInfo(_ui.btns.btnDoneNow,tipVO2);
			ToolTipManager.getInstance().attach(_ui.btns.btnDoneNow);
			_ui.txt_00.text = StringConst.TASK_WANT_PANEL_0007;
			_ui.txt_01.text = StringConst.TASK_WANT_PANEL_0008;
			_ui.txt_02.text = StringConst.TASK_WANT_PANEL_0009;
			_ui.btns.visible = false;
			_ui.btns.btnGiveUp.useHandCursor = true;
			_ui.btns.btnGiveUp.buttonMode = true;
			_ui.btns.btnDoneNow.useHandCursor = true;
			_ui.btns.btnDoneNow.buttonMode = true;
		}
		
		private function linkHandler(e:TextEvent):void
		{
			if(e.text && _data)
			{
				if(_data.link)
				{
					TaskTraceItem.executeLink(_data.link,_data.id,e.text);
				}
				else
				{
					var id:int = int(e.text);
					TaskDataManager.instance.setAutoTask(true,"boss::linkHandler");
					AutoJobManager.getInstance().setAutoTargetData(id,EntityTypes.ET_MONSTER);
				}
			}
		}
		
		private function progressTip():String
		{
			var tip:String = 
				HtmlUtils.createHtmlStr(0xffffff,
					StringUtil.substitute(StringConst.TASK_WANT_PANEL_TIP_PROGRESS,_dataManager.progress,_dataManager.totalProgress));
			return tip;
		}
		
		private function rewardTip0():String
		{
			return rewardTip(0);
		}
		
		private function rewardTip1():String
		{
			return rewardTip(1);
		}
		
		private function rewardTip2():String
		{
			return rewardTip(2);
		}
		
		private function rewardTip3():String
		{
			return rewardTip(3);
		}
		
		private function rewardTip(index:int):String
		{
			var reward:TaskBossRewardData = _dataManager.progressRewardData[index];
			
			
			var tip:String = HtmlUtils.createHtmlStr(0xffffff,StringUtil.substitute(StringConst.TASK_WANT_PANEL_TIP_POINT,reward.cfgData.reward_point));
			var rewardStr:String = reward.cfgData.reward;
			var items:Array = rewardStr.split("|");
			for each(var item:String in items)
			{
				var parsed:Array = item.split(":");
				
				var id:int = parsed[0];
				var type:int = parsed[1];
				var num:int = parsed[2];
				
				if(type == SlotType.IT_ITEM)
				{
					var itemcfg:ItemCfgData = ConfigDataManager.instance.itemCfgData(id);
					if(!itemcfg)
					{
						return HtmlUtils.createHtmlStr(0xff0000,"error item id"+id);
					}
					tip += HtmlUtils.createHtmlStr(ItemType.getColorByQuality(itemcfg.quality),"["+itemcfg.name+"]×"+num+"\n");
				}
				else if(type == SlotType.IT_EQUIP)
				{
					var equipCfg:EquipCfgData = ConfigDataManager.instance.equipCfgData(id);
					if(!equipCfg)
					{
						return HtmlUtils.createHtmlStr(0xff0000,"error equip id"+id);
					}
					
					tip += HtmlUtils.createHtmlStr(ItemType.getColorByQuality(equipCfg.color),"["+equipCfg.name+"]×"+num+"\n");
				}
			}
			
			return tip;
		}
		
		public function updateListItem(data:TaskBossData):void
		{
			for each(var item:TaskBossCell in _listItems)
			{
				if(item.data.id == data.id)
				{
					item.data = data;
					
					if(item == _selectedItem)
					{
						executeSelected(item);
					}
				}
			}
		}
		
		
		
		protected function clickHandler(e:MouseEvent):void
		{
			var rewardData:TaskBossRewardData;
			switch(e.target)
			{
				case _ui.btnClose:
					PanelMediator.instance.closePanel(PanelConst.TYPE_TASK_BOSS);
					break;
				case _ui.acceptBtn:
					if(!_selectedItem)
						return;
					if(_selectedItem.data.state == 0)
					{
						if(_dataManager.doingTask)
						{
							RollTipMediator.instance.showRollTip(RollTipType.ERROR,StringConst.TASK_WANT_PANEL_PROMPT_HAVE);
						}
						else
						{
							_dataManager.requestAcceptTask(_selectedItem.data.id);
						}
					}
					else if(_selectedItem.data.state == TaskStates.TS_CAN_SUBMIT)
					{
						_dataManager.requestSubmitTask(_selectedItem.data.id);
					}
					break;
				case _ui.btns.btnGiveUp:
					_dataManager.requestCancelTask(_selectedItem.data.id);
					break;
				case _ui.btns.btnDoneNow:
					_dataManager.requestQuickDone(_selectedItem.data.id);
					break;
				case _ui.progressPoint0:
					requestReward(_dataManager.progressRewardData[0],0);
					break;
				case _ui.progressPoint1:
					requestReward(_dataManager.progressRewardData[1],1);
					break;
				case _ui.progressPoint2:
					requestReward(_dataManager.progressRewardData[2],2);
					break;
				case _ui.progressPoint3:
					requestReward(_dataManager.progressRewardData[3],3);
					break;
			}
		}
		
		private function requestReward(data:TaskBossRewardData,index:int):void
		{
			if(data.canRewarded && !data.isRewarded)
			{
				var awards:Vector.<ThingsData> =UtilItemParse.getThingsDatas(data.cfgData.reward);
				getAndFlyAwards(awards,index);
				_dataManager.requestGetDailyReward(data.cfgData.reward_point);
			}
		}
		
		private function getAndFlyAwards(data:Vector.<ThingsData>,index:int):void
		{
			var iconcell:IconCellEx;
			var iconData:Array = [];
			for each(var td:ThingsData in data)
			{
				iconcell = new IconCellEx(_ui['progressPoint'+index].parent,_ui['progressPoint'+index].x,_ui['progressPoint'+index].y,60,60);
				iconcell.url = ResourcePathConstants.IMAGE_ICON_ITEM_FOLDER_LOAD+td.cfgData.icon+ResourcePathConstants.POSTFIX_PNG;
				iconData.push(iconcell);
			}
			var id:uint = setInterval(function():void
			{
				FlyEffectMediator.instance.doFlyReceiveThings2(iconData);
				clearInterval(id);
			},500);
			
		}
		override public function initView():void
		{
			super.initView();
		}
		
		private function initListView():void
		{
			var ui:McTaskBossPanel = McTaskBossPanel(_skin);
			
			ui.mcScrollBar
		}
		
		private function dealFilters(filters:Array,mc:MovieClip):void
		{ 
			if(filters)
			{
				mc.bg.filters = filters;
				mc.bottom.filters = filters;
				mc.vipSign.filters = filters;
				mc.lvTxt.filters =  filters;
			}
			else
			{
				mc.bg.filters = [];
				mc.bottom.filters = [];
				mc.vipSign.filters = [];
				mc.lvTxt.filters =  [];
			}	
		}
		
		/**
		 * 
		 * @param pos 被滚动内容的scrollRect的y坐标
		 */		
		public function scrollTo(pos:int):void
		{
			_scrollRect.y = pos;
			_listCtner.scrollRect = _scrollRect;
		}
		public function get contentHeight():int
		{
			return listContentHeight;
		}
		
		public function get scrollRectHeight():int
		{
			return _scrollRect.height;
		}
		public function get scrollRectY():int
		{
			return _scrollRect.y;
		}
	}
}