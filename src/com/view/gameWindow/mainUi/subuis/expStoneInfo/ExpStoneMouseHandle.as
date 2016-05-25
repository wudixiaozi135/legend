package com.view.gameWindow.mainUi.subuis.expStoneInfo
{
    import com.model.configData.ConfigDataManager;
    import com.model.configData.cfgdata.LevelCfgData;
    import com.model.consts.StringConst;
    import com.view.gameWindow.common.Alert;
    import com.view.gameWindow.flyEffect.FlyEffectMediator;
    import com.view.gameWindow.mainUi.MainUiMediator;
    import com.view.gameWindow.mainUi.subclass.McExpStone;
    import com.view.gameWindow.mainUi.subclass.McMainUIBottom;
    import com.view.gameWindow.mainUi.subuis.bottombar.BottomBar;
    import com.view.gameWindow.mainUi.subuis.bottombar.ExpRecorder;
    import com.view.gameWindow.panel.PanelConst;
    import com.view.gameWindow.panel.PanelMediator;
    import com.view.gameWindow.panel.panels.expStone.AlertExpStoneData;
    import com.view.gameWindow.panel.panels.expStone.ExpStoneDataManager;
    import com.view.gameWindow.panel.panels.roleProperty.RoleDataManager;
    import com.view.gameWindow.panel.panels.vip.VipDataManager;
    
    import flash.events.MouseEvent;
    import flash.geom.Point;

    public class ExpStoneMouseHandle
	{
		private var _mc:McExpStone;
		
		public function ExpStoneMouseHandle(mc:McExpStone)
		{
			_mc = mc;
			_mc.addEventListener(MouseEvent.CLICK,clickHandle);
		}
		
		public function clickHandle(event:MouseEvent):void
		{
			if(_mc.mcMask.scaleY < 1)
			{
				Alert.warning(StringConst.EXP_STONE_TIP5);
			}
			else
			{
				AlertExpStoneData.item = ConfigDataManager.instance.itemCfgData(3001);
				AlertExpStoneData.num = ExpStoneDataManager.instance.num;
				AlertExpStoneData.sum = ExpStoneDataManager.instance.sum;
				AlertExpStoneData.funcBtn = function():void
				{
                    ExpRecorder.storeData();
					ExpStoneDataManager.instance.getExpPanel(1);
					doFly();
                };
				AlertExpStoneData.funcBtn2 = function():void
				{
					if(ExpStoneDataManager.instance.type == 3)
					{
						if(VipDataManager.instance.lv < 2)
						{
							Alert.warning(StringConst.TIP_VIP_NOT_ENOUGH);
							return;
						}
					}
                    ExpRecorder.storeData();
					ExpStoneDataManager.instance.getExpPanel(2);
					doFly();
                };
				PanelMediator.instance.openPanel(PanelConst.TYPE_ALERT_EXP_STONE);
			}
		}
		
		private function doFly():void
		{
			var startPoint:Point, endPoint:Point;
			var mc:McMainUIBottom = (MainUiMediator.getInstance().bottomBar as BottomBar).skin as McMainUIBottom;
			if (mc)
			{
				var levelCfgData:LevelCfgData = ConfigDataManager.instance.levelCfgData(RoleDataManager.instance.lv);
				if (!levelCfgData)
				{
					return;
				}
				var scaleX:Number = RoleDataManager.instance.exp / levelCfgData.player_exp;
				var expX:int= scaleX*mc.mcExp.width;
				endPoint = mc.localToGlobal(new Point(mc.mcExp.x+ expX, mc.mcExp.y + ((mc.mcExp.height) >> 1)));
			}
			if (_mc)
			{
				startPoint = _mc.localToGlobal(new Point(_mc.x + ((_mc.width) >> 1), _mc.y + 20));
//				FlyEffectMediator.instance.doFlyExp(startPoint, endPoint);
                FlyEffectMediator.instance.deExpStoneEffect(startPoint);
			}
		}
		
		public function destroy():void
		{
			if(_mc)
			{
				_mc.removeEventListener(MouseEvent.CLICK,clickHandle);
				_mc = null;
			}
		}
	}
}