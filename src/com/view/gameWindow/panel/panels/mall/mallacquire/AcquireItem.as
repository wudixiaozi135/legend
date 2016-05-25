package com.view.gameWindow.panel.panels.mall.mallacquire
{
	import com.model.consts.StringConst;
	import com.model.dataManager.TeleportDatamanager;
	import com.view.gameWindow.panel.PanelConst;
	import com.view.gameWindow.panel.PanelMediator;
	import com.view.gameWindow.panel.panels.boss.BossDataManager;
	import com.view.gameWindow.panel.panels.boss.PanelBoss;
	import com.view.gameWindow.panel.panels.mall.McAcquireItem;
	import com.view.gameWindow.panel.panels.mall.mallacquire.data.AcquireData;
	import com.view.gameWindow.panel.panels.roleProperty.RoleDataManager;
	import com.view.gameWindow.tips.rollTip.RollTipMediator;
	import com.view.gameWindow.tips.rollTip.RollTipType;

	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.TextEvent;

	/**
	 * Created by Administrator on 2014/11/22.
	 * 快速获取面板链接事件
	 */
	public class AcquireItem extends Sprite
	{
		public function AcquireItem()
		{
			_item = new McAcquireItem();
			addChild(_item);
			_item.txtGo.addEventListener(TextEvent.LINK, onLinkEvt, false, 0, true);

			addEventListener(Event.REMOVED, onRemove);
		}

		private var _item:McAcquireItem;

		private var _data:AcquireData;

		public function get data():AcquireData
		{
			return _data;
		}

		public function set data(value:AcquireData):void
		{
			_data = value;
			if (_item.txtGo)
			{
				_item.txtGo.htmlText = "<font color='#00ff00'><u><a href='event:" + _data.value + "'>" + StringConst.MALL_GO + "</a></u></font>";
			}
			if (_item.txtItem)
			{
				_item.txtItem.text = _data.keyName;
			}
		}

		private function onLinkEvt(event:TextEvent):void
		{
			switch (event.text)
			{
				case "charge"://充值元宝
					RollTipMediator.instance.showRollTip(RollTipType.ERROR, StringConst.PROMPT_PANEL_0007);
					break;
				case "sell"://摆摊出售道具
					var isCanFly:int = RoleDataManager.instance.isCanFly;
					if (isCanFly == 0)
					{
						RollTipMediator.instance.showRollTip(RollTipType.ERROR, StringConst.PROMPT_PANEL_0008);
					} else
					{
						TeleportDatamanager.instance.requestTeleportRegion(10301);//传送到比奇城的某个区域
					}
					break;
				case "achievement"://成就
					PanelMediator.instance.openPanel(PanelConst.TYPE_ACHI);
					break;
				case "bless"://祈福
					RollTipMediator.instance.showRollTip(RollTipType.ERROR, StringConst.PROMPT_PANEL_0007);
					break;
				case "daily"://日常
					PanelMediator.instance.openPanel(PanelConst.TYPE_DAILY);
					break;
				case "boss"://挑战BOSS
					BossDataManager.instance.dealSwitchPanleBoss();
					var panel:PanelBoss = PanelMediator.instance.openedPanel(PanelConst.TYPE_BOSS) as PanelBoss;
					if (panel)
					{
						panel.mouseHandle.switchTabByIndex(4);
					}
					break;
				case "treasure"://寻宝
					RollTipMediator.instance.showRollTip(RollTipType.ERROR, StringConst.PROMPT_PANEL_0007);
					break;
				case "mall"://商城消费
					PanelMediator.instance.openPanel(PanelConst.TYPE_MALL);
					break;
				default :
					break;
			}
			PanelMediator.instance.closePanel(PanelConst.TYPE_MALL_ACQUIRE);
		}

		private function onRemove(event:Event):void
		{
			removeEventListener(Event.ADDED, onRemove);
			if (_item)
			{
				_item.txtGo.removeEventListener(TextEvent.LINK, onLinkEvt);
				_item = null;
			}
		}
	}
}
