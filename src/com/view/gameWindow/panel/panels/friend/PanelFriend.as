package com.view.gameWindow.panel.panels.friend
{
    import com.model.business.fileService.constants.ResourcePathConstants;
    import com.model.consts.FontFamily;
    import com.model.consts.StringConst;
    import com.model.consts.ToolTipConst;
    import com.model.gameWindow.rsr.RsrLoader;
    import com.view.gameWindow.common.Accordion;
    import com.view.gameWindow.common.InputHandler;
    import com.view.gameWindow.common.List;
    import com.view.gameWindow.common.McScrollBar;
    import com.view.gameWindow.mainUi.MainUiMediator;
    import com.view.gameWindow.mainUi.subclass.McMapProperty;
    import com.view.gameWindow.mainUi.subuis.minimap.MiniMap;
    import com.view.gameWindow.panel.PanelConst;
    import com.view.gameWindow.panel.PanelMediator;
    import com.view.gameWindow.panel.panelbase.PanelBase;
    import com.view.gameWindow.panel.panels.mall.event.MallEvent;
    import com.view.gameWindow.panel.panels.menus.BlackMenu;
    import com.view.gameWindow.panel.panels.menus.EmptyMenu;
    import com.view.gameWindow.panel.panels.menus.EnemyMenu;
    import com.view.gameWindow.panel.panels.menus.FriendMenu;
    import com.view.gameWindow.panel.panels.menus.MenuBase;
    import com.view.gameWindow.panel.panels.menus.MenuMediator;
    import com.view.gameWindow.panel.panels.menus.handlers.BlackHandler;
    import com.view.gameWindow.panel.panels.menus.handlers.EnemyHandler;
    import com.view.gameWindow.panel.panels.menus.handlers.FriendHandler;
    import com.view.gameWindow.panel.panels.roleProperty.RoleDataManager;
    import com.view.gameWindow.tips.toolTip.TipVO;
    import com.view.gameWindow.tips.toolTip.ToolTipManager;
    import com.view.gameWindow.util.HtmlUtils;
    import com.view.selectRole.SelectRoleDataManager;

    import flash.display.DisplayObject;
    import flash.events.Event;
    import flash.events.MouseEvent;
    import flash.geom.Point;
    import flash.geom.Rectangle;
    import flash.text.TextField;
    import flash.text.TextFieldAutoSize;
    import flash.text.TextFormat;

    import mx.events.Request;
    import mx.utils.StringUtil;

    public class PanelFriend extends PanelBase
	{
		public function PanelFriend()
		{
			super();
		}

		private var mcFriendPanel:McPanelFriend;
		private var accordion:Accordion;
		private var latestList:List;
		private var friendList:List;
		private var enemyList:List;
		private var blackList:List;
		private var searchList:List;
		private var collection:Array;
		private var labels:Array = [StringConst.FRIEND_PANEL_001, StringConst.FRIEND_PANEL_002, StringConst.FRIEND_PANEL_003, StringConst.FRIEND_PANEL_004];
		private var moodTxtHandler:InputHandler;
		private var searchTxtHandler:InputHandler;
		private var selectedIndex:int = 0;
//		private var isShowOffline:Boolean = true;
		private var waitingClearTipOwnerList:Array = [];
		private var searchCtner:EmptyMenu;
		private var menu:MenuBase;

		override protected function initSkin():void
		{
			_skin = new McPanelFriend();
			mcFriendPanel = _skin as McPanelFriend;

			mcFriendPanel.icon.resUrl = getIconResUrl();

			addChild(mcFriendPanel);
			setTitleBar(mcFriendPanel.dragBox);

			accordion = new Accordion();
			accordion.onlyOneSelected = true;
			accordion.selectHandler = accordionSelectHandler;
			accordion.setStyle(McHead, null, null);
			accordion.addEventListener(Event.SELECT, accordionSelectHandler);
			latestList = createList(latestClickHandler, itemSetCallback);
			friendList = createList(friendClickHandler, itemSetCallback);
			enemyList = createList(enemyClickHandler, itemSetCallback);
			blackList = createList(blackClickHandler, itemSetCallback);
			collection = [];
			collection.push(latestList, friendList, enemyList, blackList);

			accordion.addContent(0, labels[0], latestList);
			accordion.addContent(1, labels[1], friendList);
			accordion.addContent(2, labels[2], enemyList);
			accordion.addContent(3, labels[3], blackList);

			mcFriendPanel.listCtner.addChild(accordion);


			mcFriendPanel.moodTxt.multiline = true;
			mcFriendPanel.moodTxt.wordWrap = true;
			mcFriendPanel.moodTxt.tabEnabled = false;
			mcFriendPanel.moodTxt.autoSize = TextFieldAutoSize.LEFT;
			var dataMgr:ContactDataManager = ContactDataManager.instance;

			moodTxtHandler = new InputHandler(mcFriendPanel.moodTxt, dataMgr.defaultMood, 3, moodTxtFocusOut);

			mcFriendPanel.searchTxt.tabEnabled = false;
			mcFriendPanel.searchTxt.maxChars = 20;
			searchTxtHandler = new InputHandler(mcFriendPanel.searchTxt, StringConst.FRIEND_PANEL_SEARCH, -1,null,searchTxtChange);

			dataMgr.attach(this);

			addEventListener(MouseEvent.CLICK, clickHandler);
		}
		
		override protected function addCallBack(rsrLoader:RsrLoader):void
		{
			rsrLoader.addCallBack(mcFriendPanel.onlineBtn,setOnlineBtnState);
		}

		override public function destroy():void
		{
			clearSearchCtner();

			moodTxtHandler.destroy();
			moodTxtHandler = null;

			searchTxtHandler.destroy();
			searchTxtHandler = null;

			ContactDataManager.instance.detach(this);

			if (waitingClearTipOwnerList)
			{
				for (var i:int = 0; i < waitingClearTipOwnerList.length; ++i)
				{
					ToolTipManager.getInstance().detach(waitingClearTipOwnerList[i]);
				}
				waitingClearTipOwnerList = [];
			}

			if (latestList)
			{
				latestList.destroy();
				latestList = null;
			}
			if (friendList)
			{
				friendList.destroy();
				friendList = null;
			}

			if (enemyList)
			{
				enemyList.destroy();
				enemyList = null;
			}

			if (blackList)
			{
				blackList.destroy();
				blackList = null;
			}

			if (searchList)
			{
				searchList.destroy();
				searchList = null;
			}

			if (accordion)
			{
				accordion.removeEventListener(Event.SELECT, accordionSelectHandler);
				accordion.destroy();
				accordion = null;
			}

			removeEventListener(MouseEvent.CLICK, clickHandler);
			super.destroy();
		}

		override protected function initData():void
		{
			mcFriendPanel.titleTxt.htmlText = HtmlUtils.createHtmlStr(mcFriendPanel.titleTxt.textColor, StringConst.TIP_FRIEND, 12, true);
			setRoleInfo(SelectRoleDataManager.getInstance().selectSid, RoleDataManager.instance.name);
			mcFriendPanel.onlineTxt.text = StringConst.FRIEND_PANEL_005;
			mcFriendPanel.addFriendTxt.text = StringConst.FRIEND_PANEL_006;
			mcFriendPanel.addFriendTxt.mouseEnabled = false;

			resetListAll();
			accordion.updatePos();

			ContactDataManager.instance.requestContactListAll();
		}

		override public function update(proc:int = 0):void
		{
			var dataManager:ContactDataManager = ContactDataManager.instance;
			switch (proc)
			{
				case ContactDataManager.UPDATE_MOOD:
					mcFriendPanel.moodTxt.text = dataManager.mood;
					break;
				case ContactDataManager.UPDATE_LIST_LATEST:
					resetList(ContactType.LATEST);
					break;
				case ContactDataManager.UPDATE_LIST_FRIEND:
					resetList(ContactType.FRIEND);
					break;
				case ContactDataManager.UPDATE_LIST_ENEMY:
					resetList(ContactType.ENEMY);
					break;
				case ContactDataManager.UPDATE_LIST_BLACK:
					resetList(ContactType.BLACK);
					break;
			}
		}

		public function setRoleInfo(serverId:int, name:String):void
		{
			mcFriendPanel.nameTxt.text = /*"["+serverId+"区]"+*/name;
		}

		/**切换某个标签*/
		public function setSelectShow(type:int):void
		{
			if (accordion)
			{
				accordion.foldContent(type, true);
			}
		}

		public function setListData(index:int, data:Array):void
		{
			var list:List = collection[index] as List;
			if (list)
			{
				list.data = data;
			}
		}

		public function setListLabel(index:int, label:String):void
		{

		}

		public function getIndex(type:int):int
		{
			return type == ContactType.LATEST ? 0 : type;
		}

		public function getList(type:int):List
		{
			var index:int = getIndex(type);

			if (index >= 0 && index < collection.length)
			{
				return collection[index];
			}

			return null;
		}

		private function getIconResUrl():String
		{
			return "friend/" + RoleDataManager.instance.job + "_" + RoleDataManager.instance.sex + ResourcePathConstants.POSTFIX_JPG;
		}

		private function moodTxtFocusOut(txt:String):void
		{
			if (txt != ContactDataManager.instance.mood)
			{
				ContactDataManager.instance.requestUpdateMood(txt);
			}
		}

		private function searchTxtChange(txt:String):void
		{
			txt = StringUtil.trim(txt);

			if (txt != "")
			{
				var data:Array = ContactDataManager.instance.findNameAt(ContactType.FRIEND, txt);

				if (!searchCtner)
				{
					searchCtner = new EmptyMenu();
					searchCtner.addEventListener(Event.SELECT, searchCtnerHandler);
				}

				var content:DisplayObject;
				if (data.length > 0)
				{
					if (!searchList)
					{
						searchList = createList(searchItemClickHandler, searchItemSetHandler, -1);
					}

					content = searchList;
					searchList.data = data;
				}
				else
				{
					var text:TextField = new TextField();
					text.defaultTextFormat = new TextFormat(FontFamily.FONT_NAME, 12, 0xffffff);
					text.text = StringConst.TIP_NO_SEARCH;
					text.selectable = false;
					text.height = text.textHeight + 5;
					content = text;
				}

				searchCtner.addContent(content);
				var pos:Point = mcFriendPanel.searchTxt.parent.localToGlobal(
						new Point(mcFriendPanel.searchTxt.x, mcFriendPanel.searchTxt.y + mcFriendPanel.searchTxt.height));
				searchCtner.x = pos.x;
				searchCtner.y = pos.y;
				MenuMediator.instance.showMenu(searchCtner);
			}
			else
			{
				clearSearchCtner();
			}
		}

		private function showSearchResult():void
		{

		}

		private function searchItemSetHandler(index:int, data:Object, target:DisplayObject):void
		{
			var entry:ContactEntry = data as ContactEntry;

			var view:* = target;

			view.txt.text = entry.toHeadDes();
			view.vipTxt.text = entry.toVipDes();
			view.lvTxt.text = StringConst.TIP_LV + ":" + entry.toLvDes();

			view.txt.textColor = 0xFFE1AA;
			view.vipTxt.textColor = 0xFFE1AA;
			view.lvTxt.textColor = 0xFFE1AA;

			target.scaleY = ContactDataManager.instance.isShowOffline || entry.online ? 1 : 0;
		}

		private function clearSearchCtner():void
		{
			if (searchCtner)
			{
				searchCtner.removeEventListener(Event.SELECT, searchCtnerHandler);
				MenuMediator.instance.hideMenu(searchCtner);
				searchCtner.destroy();
				searchCtner = null;
			}
		}

		private function searchItemClickHandler(index:int, data:Object, target:DisplayObject):void
		{
			clearSearchCtner();
			trace(index);
//			setAccordionSelectedIndex(getIndex(ContactType.FRIEND));

			accordion.foldContent(getIndex(ContactType.FRIEND), true);
		}

		private function setAccordionSelectedIndex(value:int):void
		{
			selectedIndex = value;

			if (selectedIndex == 2)
			{
				mcFriendPanel.addFriendTxt.text = StringConst.FRIEND_PANEL_007;
			}
			else if (selectedIndex == 3)
			{
				mcFriendPanel.addFriendTxt.text = StringConst.FRIEND_PANEL_008;
			}
			else
			{
				mcFriendPanel.addFriendTxt.text = StringConst.FRIEND_PANEL_006;
			}
		}

		private function resetList(type:int):void
		{
			var dataManager:ContactDataManager = ContactDataManager.instance;
			var list:List = getList(type);
			list.data = dataManager.getList(type);
			accordion.updatePos();

			setAccordionHead(type, list.data.length, dataManager.getTotalNum(type));
		}

		private function setAccordionHead(type:int, num:int, total:int):void
		{
			var index:int;
			if (type == ContactType.LATEST)
			{
				index = 0;
			}
			else
			{
				index = type;
			}

			var txt:String = HtmlUtils.createHtmlStr(0xA56238, labels[index] + "【" + num + "/" + total + "】");


			accordion.setContentLabel(index, txt);
		}

		private function resetListAll():void
		{
			resetList(ContactType.BLACK);
			resetList(ContactType.ENEMY);
			resetList(ContactType.FRIEND);
			resetList(ContactType.LATEST);
		}

		private function updateLists():void
		{
			for each(var list:List in collection)
			{
				list.updateItems();
				list.updatePos();
			}
			accordion.updatePos();
		}

		private function createData(name:String, serverId:int, job:int, lv:int, online:int, type:int = 1):ContactEntry
		{
			var entry:ContactEntry = new ContactEntry();
			entry.serverId = serverId;
			entry.roleId = 1;
			entry.name = name;
			entry.job = job;
			entry.lv = lv;
			entry.online = online;
			entry.type = type;
			return entry;
		}

		private function itemSetCallback(index:int, data:Object, target:DisplayObject):void
		{
			var entry:ContactEntry = data as ContactEntry;

			var view:* = target;

			view.txt.text = entry.toHeadDes();
			view.vipTxt.text = entry.toVipDes();
			view.lvTxt.text = StringConst.TIP_LV + ":" + entry.toLvDes();

			view.txt.textColor = entry.online ? 0xFFE1AA : 0x888888;
			view.vipTxt.textColor = entry.online ? 0xFFE1AA : 0x888888;
			view.lvTxt.textColor = entry.online ? 0xFFE1AA : 0x888888;

			target.scaleY = ContactDataManager.instance.isShowOffline || entry.online ? 1 : 0;

			var tip:TipVO = new TipVO();
			tip.tipData = getItemTip;
			tip.tipDataValue = data;
			tip.tipType = ToolTipConst.TEXT_TIP;
			ToolTipManager.getInstance().hashTipInfo(target, tip);
			ToolTipManager.getInstance().attach(target);

			if (waitingClearTipOwnerList.indexOf(target) == -1)
			{
				waitingClearTipOwnerList.push(target);
			}
		}

		private function getItemTip(data:Object):String
		{
			var entry:ContactEntry = data as ContactEntry;

			var txt:String = entry.toTipDes();

			return HtmlUtils.createHtmlStr(0xFFE1AA, txt);
		}

		private function latestClickHandler(index:int, data:Object, target:DisplayObject):void
		{
			clearOtherListSelectedState(0);
			listClickHandler(index, data, target);
		}

		private function friendClickHandler(index:int, data:Object, target:DisplayObject):void
		{
			clearOtherListSelectedState(1);
			listClickHandler(index, data, target);
			if (PanelMediator.instance.openedPanel(PanelConst.TYPE_MALL_GIVE))
			{
				MallEvent.dispatchEvent(new MallEvent(MallEvent.SELECT_FRIEND, data));
			}
		}

		private function enemyClickHandler(index:int, data:Object, target:DisplayObject):void
		{
			clearOtherListSelectedState(2);
			listClickHandler(index, data, target);
		}

		private function blackClickHandler(index:int, data:Object, target:DisplayObject):void
		{
			clearOtherListSelectedState(3);
			listClickHandler(index, data, target);
		}

		private function clearOtherListSelectedState(index:int):void
		{
			for (var i:int = 0; i < collection.length; ++i)
			{
				if (i != index)
				{
					collection[i].selectedIndex = -1;
				}
			}
		}

		private function listClickHandler(index:int, data:Object, target:DisplayObject):void
		{
			destroyMenu();
			if (!menu)
			{
				var entry:ContactEntry = ContactEntry(data);
				switch (entry.type)
				{
					case ContactType.LATEST:
					case ContactType.FRIEND:
						menu = new FriendMenu(new FriendHandler(entry.serverId, entry.roleId, entry.name, entry.type));
						break;
					case ContactType.ENEMY:
						menu = new EnemyMenu(new EnemyHandler(entry.serverId, entry.roleId, entry.name));
						break;
					case ContactType.BLACK:
						menu = new BlackMenu(new BlackHandler(entry.serverId, entry.roleId, entry.name));
						break;
//					default:
//						menu = new BlackMenu();
//						break;
				}

				if (menu)
				{
					menu.addEventListener(Event.SELECT, menuSelectHandler);
					var pos:Point = target.parent.localToGlobal(new Point(target.x + int(target.width / 2), target.y + target.height - 5));
					menu.x = pos.x;
					menu.y = pos.y;
					MenuMediator.instance.showMenu(menu);
				}
			}
		}

		private function destroyMenu():void
		{
			if (menu)
			{
				menu.removeEventListener(Event.SELECT, menuSelectHandler);
				MenuMediator.instance.hideMenu(menu);
				menu = null;
			}
		}

		private function createList(clickHandler:Function, itemSetHandler:Function, minNum:int = 7):List
		{
			var list:List = new List(7, McScrollBar, minNum, 252, 28);
			list.selectable = true;
			list.clickCallback = clickHandler;
			list.setStyle(McItem, itemSetHandler, null);
			return list;
		}

		private function searchCtnerHandler(e:Event):void
		{
			clearSearchCtner();
		}

		private function accordionSelectHandler(e:Request):void
		{
			setAccordionSelectedIndex(int(e.value));
		}
		
		private function setOnlineBtnState(m:*):void
		{
			mcFriendPanel.onlineBtn.selected = !ContactDataManager.instance.isShowOffline;
		}

		private function clickHandler(e:MouseEvent):void
		{
			switch (e.target)
			{
				case mcFriendPanel.closeBtn:
					PanelMediator.instance.closePanel(PanelConst.TYPE_FRIEND);
					break;
				case mcFriendPanel.onlineBtn:
					ContactDataManager.instance.isShowOffline = !mcFriendPanel.onlineBtn.selected;
					clearOtherListSelectedState(selectedIndex != 0 ? 0 : 1);
					updateLists();
					break;
				case mcFriendPanel.addFriendBtn:
					if (selectedIndex == 2)
					{
						//添加仇人
						PanelMediator.instance.openPanel(PanelConst.TYPE_SEARCH_FOR_ENEMY);
					}
					else if (selectedIndex == 3)
					{
						PanelMediator.instance.openPanel(PanelConst.TYPE_SEARCH_FOR_BLACK);
					}
					else
					{
						//添加好友
						PanelMediator.instance.openPanel(PanelConst.TYPE_SEARCH_FOR_FRIEND);
					}
					break;
				case mcFriendPanel.searchTxt:
					searchTxtChange(mcFriendPanel.searchTxt.text);
					break;
			}
		}

        override public function setPostion():void
        {
            var mc:McMapProperty = (MainUiMediator.getInstance().miniMap as MiniMap).skin as McMapProperty;
            if (mc)
            {
                var popPoint:Point = mc.localToGlobal(new Point(mc.btnFriend.x, mc.btnFriend.y));
                isMount(true, popPoint.x, popPoint.y);
            } else
            {
                isMount(true);
            }
        }

        override public function getPanelRect():Rectangle
        {
            return new Rectangle(0, 0, 342, 545);//为啥这个高度刚加载时这么大
        }

        private function menuSelectHandler(e:Request):void
		{
			destroyMenu();
		}

	}
}