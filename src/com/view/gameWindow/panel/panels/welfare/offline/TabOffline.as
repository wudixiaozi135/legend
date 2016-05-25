package com.view.gameWindow.panel.panels.welfare.offline
{
    import com.model.business.gameService.constants.GameServiceConstants;
    import com.model.configData.ConfigDataManager;
    import com.model.configData.cfgdata.LevelCfgData;
    import com.model.configData.cfgdata.OffLineExpGet;
    import com.model.configData.cfgdata.WorldLevelCfgData;
    import com.model.consts.StringConst;
    import com.model.consts.ToolTipConst;
    import com.model.gameWindow.rsr.RsrLoader;
    import com.view.gameWindow.common.Alert;
    import com.view.gameWindow.panel.panels.bag.BagDataManager;
    import com.view.gameWindow.panel.panels.roleProperty.RoleDataManager;
    import com.view.gameWindow.panel.panels.welfare.MCOffline;
    import com.view.gameWindow.panel.panels.welfare.WelfareDataMannager;
    import com.view.gameWindow.tips.toolTip.TipVO;
    import com.view.gameWindow.tips.toolTip.ToolTipManager;
    import com.view.gameWindow.util.HtmlUtils;
    import com.view.gameWindow.util.ServerTime;
    import com.view.gameWindow.util.TimeUtils;
    import com.view.gameWindow.util.tabsSwitch.TabBase;
    
    import flash.display.MovieClip;
    import flash.events.MouseEvent;
    
    import mx.utils.StringUtil;

    public class TabOffline extends TabBase
	{
		private var timeObj:Object;
		private var goldObj:Array = [];
		private var tipVO:TipVO;
	
		public function TabOffline()
		{
			super();
		}
		
		override protected function initSkin():void
		{
			var skin:MCOffline = new MCOffline;
			_skin = skin;
			addChild(skin);
		}
		
		override protected function initData():void
		{
			_skin.addEventListener(MouseEvent.CLICK,onClick);
			initTxt();
		}
		
		override protected function addCallBack(rsrLoader:RsrLoader):void
		{
			rsrLoader.addCallBack(skin.freebtneffect,function(mc:MovieClip):void
			{
				var offLineTime:uint = WelfareDataMannager.instance.offLineTime;
				mc.mouseEnabled = false;
				if(offLineTime >=3600)
				{
					mc.visible = true;
					mc.play();
				}
				else
				{
					mc.visible = false;
					mc.gotoAndStop(1);
				}
			});
			
		}
		
		private function initTxt():void
		{
			 
			_skin.lingquTxt0.text = StringConst.WELFARE_PANEL_0008;
			_skin.lingquTxt1.text = StringConst.WELFARE_PANEL_0009;
			_skin.lingquTxt2.text = StringConst.WELFARE_PANEL_0010;
			_skin.lingquTxt0.mouseEnabled = _skin.lingquTxt1.mouseEnabled = _skin.lingquTxt2.mouseEnabled = false;
			_skin.tipTxt.text = StringConst.WELFARE_PANEL_0024;
			_skin.txt1.text = _skin.txt2.text =StringConst.WELFARE_PANEL_0011;
			if(WelfareDataMannager.instance.initOpenTime)
			{
				var tipVO:TipVO = new TipVO();
				tipVO.tipType = ToolTipConst.TEXT_TIP;
				var time:String = TimeUtils.getDateString(ServerTime.openTime*1000);
				var openday:int = WelfareDataMannager.instance.openServiceDay;
				var maxday:int = ConfigDataManager.instance.maxOpenDay-1;
				var day:int = openday>maxday?maxday:openday;
				var worldCfg:WorldLevelCfgData =  ConfigDataManager.instance.worldLevel(day+1);
				var timeLimit:int = worldCfg.reincarn_limit;
				var str:String = StringUtil.substitute(StringConst.WELFARE_PANEL_0031,time,timeLimit.toString());
				tipVO.tipData = HtmlUtils.createHtmlStr(0xa56238,str,12,false,6);
				ToolTipManager.getInstance().hashTipInfo(_skin.kaifuTxt,tipVO);
				ToolTipManager.getInstance().attach(_skin.kaifuTxt);
			}
			
		}
		 
 		
		protected function onClick(event:MouseEvent):void
		{
 
			switch(event.target)
			{

				case _skin.freeBtn:
				{
					if (WelfareDataMannager.instance.flag == 1 || WelfareDataMannager.instance.isGetOffLineExp)
					{
						Alert.message(StringConst.WELFARE_PANEL_0025);
						return;
					}
					
					if(timeObj.min == 0 && timeObj.hour == 0)
					{
						Alert.warning(StringConst.WELFARE_PANEL_0026);
						return;
					}
					var exp1:int=int(_skin.exp0.text);
					checkExp(exp1,1);
					break;
				}
				case _skin.doubleBtn:
				{
					if (WelfareDataMannager.instance.flag == 1 || WelfareDataMannager.instance.isGetOffLineExp)
					{
						Alert.message(StringConst.WELFARE_PANEL_0025);
						return;
					}
					
					if(timeObj.min == 0 && timeObj.hour == 0)
					{
						Alert.warning(StringConst.WELFARE_PANEL_0026);
						return;
					}
					if(goldObj[0] > BagDataManager.instance.goldUnBind)
					{
						Alert.warning(StringConst.WELFARE_PANEL_0027);
						return;
					}
					var exp2:int=int(_skin.exp1.text);
					checkExp(exp2,2);
					break;
				}
				case _skin.threeBtn:
				{
					if (WelfareDataMannager.instance.flag == 1 || WelfareDataMannager.instance.isGetOffLineExp)
					{
						Alert.message(StringConst.WELFARE_PANEL_0025);
						return;
					}
					
					if(timeObj.min == 0 && timeObj.hour == 0)
					{
						Alert.warning(StringConst.WELFARE_PANEL_0026);
						return;
					}
					if(goldObj[1] > BagDataManager.instance.goldUnBind)
					{
						Alert.warning(StringConst.WELFARE_PANEL_0028);
						return;
					}
					var exp3:int=int(_skin.exp2.text);
					checkExp(exp3,3);
					break;
				}
			}
		}
		
		private function checkExp(exp:int,rate:int):void
		{
			var lv:int = RoleDataManager.instance.lv;
			var reincarn:int = RoleDataManager.instance.reincarn;
			var levelCfgData:LevelCfgData = ConfigDataManager.instance.levelCfgData(lv);
			//var exp:int;
			if(reincarn<levelCfgData.player_reincarn)
			{
				 
				if(exp+RoleDataManager.instance.exp>levelCfgData.player_exp)
				{
					Alert.show2(StringConst.WELFARE_PANEL_0032,function ():void
					{
						WelfareDataMannager.instance.getOffLineExp(rate);
						visibleMc(rate);
					});
				}
				else
				{
					WelfareDataMannager.instance.getOffLineExp(rate);
					visibleMc(rate);
				}
			}else
			{
				WelfareDataMannager.instance.getOffLineExp(rate);
				visibleMc(rate);
			}
			
			function visibleMc(rate:int):void
			{
				if(rate ==3)
				{
					_skin.freebtneffect.visible = false;
					_skin.freebtneffect.gotoAndStop(1);
				}
					
			}
		}
		
		
		override public function update(proc:int=0):void
		{
			 if(proc == GameServiceConstants.SM_QUERY_OFF_LINE)
			 {
				 refresh();
			 }
			 else if(proc == GameServiceConstants.CM_GET_OFF_LINE_EXP)
			 {
			 	clearTxt();
				checkSign();
			 }else if(proc == GameServiceConstants.SM_SYS_SERVER_CONFIG_INFO)
			 {
				 var tipVO:TipVO = new TipVO();
				 tipVO.tipType = ToolTipConst.TEXT_TIP;
				 var time:String = TimeUtils.getDateString(ServerTime.openTime*1000);
				 var openday:int = WelfareDataMannager.instance.openServiceDay;
				 var maxday:int = ConfigDataManager.instance.maxOpenDay-1;
				 var day:int = openday>maxday?maxday:openday;
				 var worldCfg:WorldLevelCfgData =  ConfigDataManager.instance.worldLevel(day+1);
				 var timeLimit:int = worldCfg.reincarn_limit;
				 var str:String = StringUtil.substitute(StringConst.WELFARE_PANEL_0031,time,timeLimit.toString());
				 tipVO.tipData = HtmlUtils.createHtmlStr(0xa56238,str,12,false,6);
				 ToolTipManager.getInstance().hashTipInfo(_skin.kaifuTxt,tipVO);
				 ToolTipManager.getInstance().attach(_skin.kaifuTxt);
			 }
		}
		
		private function checkSign():void
		{
			if(WelfareDataMannager.instance.signState == 0)
			{
				WelfareDataMannager.instance.dealSwitchTab(0);
			}
		}
		
		private function clearTxt():void
		{
            WelfareDataMannager.instance.flag = 1;
			_skin.exp0.text = _skin.exp1.text = _skin.exp2.text = "0";
			_skin.coin1.text = _skin.coin2.text = "0";
			_skin.coin0.text = StringConst.WELFARE_PANEL_0013;
			_skin.hour.text = _skin.minutes.text = _skin.second .text = "0"; 
			var n:int = WelfareDataMannager.instance.openDay+1;
			_skin.kaifuTxt.text = StringUtil.substitute(StringConst.WELFARE_PANEL_0012,n.toString());
			var day:int = WelfareDataMannager.instance.worldLevel;
			_skin.worldLvTxt.text = StringUtil.substitute(StringConst.WELFARE_PANEL_0030,day.toString());
			
		}
		
		override public function refresh():void
		{
            if (WelfareDataMannager.instance.flag == 1 || WelfareDataMannager.instance.isGetOffLineExp)
			{
				clearTxt();
				return;
			}
				
			var lv:int = RoleDataManager.instance.lv;
			var num:int = WelfareDataMannager.instance.offLineTime;
			timeObj = TimeUtils.calcTime3(num);
			num = timeObj.min +  timeObj.hour*60;
			var baseExp:int = ConfigDataManager.instance.getOffLineExp(lv).base_exp;
			num = baseExp*num;
			_skin.exp0.text = num.toString();
			_skin.exp1.text = (2*num).toString();
			_skin.exp2.text = (3*num).toString();
			_skin.coin0.text = StringConst.WELFARE_PANEL_0013;

            _skin.hour.text = timeObj.hour; //== 0? "0":String(timeObj.hour);
            _skin.minutes.text = timeObj.min; //== 0? "0":String(timeObj.min);
			_skin.second.text =  timeObj.sec;
			num = timeObj.hour; 
			
			var n:int = WelfareDataMannager.instance.openDay+1;
			_skin.kaifuTxt.text = StringUtil.substitute(StringConst.WELFARE_PANEL_0012,n.toString());
			var day:int = WelfareDataMannager.instance.worldLevel;
			_skin.worldLvTxt.text = StringUtil.substitute(StringConst.WELFARE_PANEL_0030,day.toString());
			/*if(timeObj.hour != 0 )
			{
				num = timeObj.hour;
				
				if(timeObj.min >= 45)
				{
					num++;
				}
			}
			if(59 > timeObj.min && timeObj.hour == 0)
			{
				num++;		
			} 
			*/
			if(timeObj.hour == 0 || timeObj.min >= 45)
			{
				num++
			}
			
			
			var offLineExpGet:OffLineExpGet = ConfigDataManager.instance.getOffLineExpGet(4320);
			_skin.coin1.text = String(num*offLineExpGet.double_get);
			goldObj[0] = num*offLineExpGet.double_get;
			_skin.coin2.text = String(num*offLineExpGet.three_get);
			goldObj[1] = num*offLineExpGet.three_get;
		}
		override public function destroy():void
		{
            WelfareDataMannager.instance.flag = 0;
			goldObj.length = 0;
			goldObj = null;
			_skin.removeEventListener(MouseEvent.CLICK,onClick);
			tipVO = null;
			super.destroy();
		}
		
	/*	override protected function initData():void
		{
//			WelfareDataMannager.instance.queryOffLine();
		}*/
		
		override protected function attach():void
		{
			// TODO Auto Generated method stub
			WelfareDataMannager.instance.attach(this);
			super.attach();
		}
		
		override protected function detach():void
		{
			// TODO Auto Generated method stub
			WelfareDataMannager.instance.detach(this);
			super.detach();
		}
		
	}
}