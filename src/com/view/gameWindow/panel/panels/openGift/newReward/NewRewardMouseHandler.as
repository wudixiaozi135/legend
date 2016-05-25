package com.view.gameWindow.panel.panels.openGift.newReward
{
	import com.model.configData.ConfigDataManager;
	import com.model.configData.cfgdata.OpenServerNewRewardCfgData;
	import com.model.consts.StringConst;
	import com.view.gameWindow.common.Alert;
	import com.view.gameWindow.panel.panels.bag.BagData;
	import com.view.gameWindow.panel.panels.bag.BagDataManager;
	import com.view.gameWindow.panel.panels.openActivity.McOpenNew;
	import com.view.gameWindow.panel.panels.openGift.data.OpenServiceActivityDatamanager;
	import com.view.gameWindow.panel.panels.roleProperty.RoleDataManager;
	
	import flash.events.MouseEvent;
	
	import mx.utils.StringUtil;

	public class NewRewardMouseHandler
	{
		private var skin:McOpenNew;
		private var panel:NewReward;
		public function NewRewardMouseHandler(p:NewReward)
		{
			panel = p;
			skin = panel.skin;
			skin.addEventListener(MouseEvent.CLICK,onClick);
		}
		
		protected function onClick(event:MouseEvent):void
		{
			// TODO Auto-generated method stub
			var day:int = OpenServiceActivityDatamanager.instance.curDay;
			var cfg:OpenServerNewRewardCfgData =ConfigDataManager.instance.OpenServerNewRewardData(day,day);
			if(event.target == skin.btnGet)
			{
				var str:String = StringUtil.substitute(StringConst.PANEL_OPEN_GIFT_022,cfg.gold,cfg.name);
				Alert.show2(str,function ():void
				{
					if(BagDataManager.instance.goldUnBind>=cfg.gold)
					{
						OpenServiceActivityDatamanager.instance.getNewReward();
						if(panel)
							panel.viewHandler.storeBitmaps();
					}else
					{
						Alert.warning(StringConst.DUNGEON_REWARD_CARD_TIP_0002);
					}
				},null,StringConst.PANEL_OPEN_GIFT_023);
				
			}
		}
		
		public function destroy():void
		{
			skin.removeEventListener(MouseEvent.CLICK,onClick);
			skin = null;
			panel = null;
		}
	}
}