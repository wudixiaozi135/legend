package com.view.gameWindow.panel.panels.welfare.sign
{
    import com.model.consts.StringConst;
    import com.model.gameWindow.rsr.RsrLoader;
    import com.view.gameWindow.common.Alert;
    import com.view.gameWindow.panel.PanelConst;
    import com.view.gameWindow.panel.PanelMediator;
    import com.view.gameWindow.panel.panels.vip.PanelVip;
    import com.view.gameWindow.panel.panels.vip.VipDataManager;
    import com.view.gameWindow.panel.panels.welfare.MCSign;
    import com.view.gameWindow.panel.panels.welfare.WelfareDataMannager;
    import com.view.gameWindow.util.Calendar;
    import com.view.gameWindow.util.FilterUtil;
    import com.view.gameWindow.util.ServerTime;
    import com.view.gameWindow.util.SimpleStateButton;
    
    import flash.display.MovieClip;
    import flash.events.MouseEvent;
    
    import mx.utils.StringUtil;

    public class SignMouseHandle
	{
		private var _panel:TabSign;
		private var _skin:MCSign;
		private var _awardIndex:int;
		private var _openServerTime:uint; 
		public var loackTab:Boolean = false;
		public function SignMouseHandle(panel:TabSign)
		{
			_panel = panel;
			_skin = panel.skin as MCSign;
		}
		
		public function init(rsrLoader:RsrLoader):void
		{
			rsrLoader.addCallBack(_skin.qiandaoBtn,function (mc:MovieClip):void
			{
				_skin.qiandaoBtn.load=1;
				mc.addEventListener(MouseEvent.CLICK,onClick);
			}
			);
			
			rsrLoader.addCallBack(_skin.buqianBtn,function (mc:MovieClip):void
			{
				var buQianNum:int = WelfareDataMannager.instance.fillSignCount;
				_skin.buqianBtn.filters = buQianNum ==0?[FilterUtil.getGrayfiltes()]:[]; 
				_skin.buqianBtn.txt.text = StringUtil.substitute(StringConst.WELFARE_PANEL_0004,String(buQianNum));
				mc.addEventListener(MouseEvent.CLICK,onClick);
			}
			);
			
			rsrLoader.addCallBack(_skin.lingquBtn,function (mc:MovieClip):void
			{
				mc.addEventListener(MouseEvent.CLICK,onClick);
				_skin.lingquBtn.load=1;
			}
			);
			
			for(var i:int = 0;i < 5;i++)
			{
				rsrLoader.addCallBack(_skin['btn'+i],getFun(i));
			}
			_skin.txt2.addEventListener(MouseEvent.CLICK,onClick);
			_skin.txt1.addEventListener(MouseEvent.CLICK,onClick);
			SimpleStateButton.addState(_skin.txt2);
			SimpleStateButton.addState(_skin.txt1);
		}
		
		private function getFun(index:int):Function
		{
			var fun:Function = function (mc:MovieClip):void
			{
				mc.addEventListener(MouseEvent.CLICK,onClick);	
				var awardIndex:int = WelfareDataMannager.instance.awardIndex;
				mc.load=1;
				if(index == awardIndex)
				{
					mc.selected = true;
					dealBtn(awardIndex);
				}
				else
				{
					mc.selected = false;
				}
            };
			
			return fun;
		}
		
		public function onClick(e:MouseEvent):void
		{
			switch(e.target)
			{
				/*case :
				{
					WelfareDataMannager.instance.fillSign(e.target.num);
					break;
				} */
				case _skin.qiandaoBtn:
				{
					WelfareDataMannager.instance.sign();
					break;
				}
				case _skin.buqianBtn:
				{
					if(VipDataManager.instance.lv == 0)
					{
						Alert.warning(StringConst.WELFARE_PANEL_0019);
						return;
					}
					
					if(WelfareDataMannager.instance.fillSignCount == 0)
					{
						Alert.warning(StringConst.WELFARE_PANEL_0020);
						return;
					}
					//var data1:int = WelfareDataMannager.instance.signList.indexOf(1);
					var singList:Array = WelfareDataMannager.instance.signList;
					var data:int = singList.indexOf(0); 
					var currentDate:Date = Calendar.instance.currentDate;
					if(data+1 >currentDate.date)
					{
						Alert.warning(StringConst.WELFARE_PANEL_0021);
						return;
					} 
					var a:Number = ServerTime.openTime;
					var b:Number = a*1000;
					var openDate:Date = new Date(b);
					if(currentDate.month == openDate.month)
					{
						var index:int = openDate.date-1;
						data = singList.indexOf(0,index);
						if(data ==-1)
						{
							Alert.warning(StringConst.WELFARE_PANEL_0021);
							return;
						}
					}
					else if(currentDate.month > openDate.month)
					{
						data = singList.indexOf(0);
						 
					}		
					if(data+1 >currentDate.date)
					{
						Alert.warning(StringConst.WELFARE_PANEL_0029);
						return;
					}  
					WelfareDataMannager.instance.fillSign(data+1);
					break;
				}	
				case _skin.lingquBtn:
				{
					/*_panel.viewHandle.flyAward();
					return;*/
					var temp:Array = [2,5,10,18,26];
					if(temp[_awardIndex] > WelfareDataMannager.instance.qianInMonthNum)
					{
						Alert.warning(StringConst.WELFARE_PANEL_0022);
						return;
					}
					var flag:int = WelfareDataMannager.instance.awardList[_awardIndex];
					if(flag == 1)
					{
						Alert.warning(StringConst.WELFARE_PANEL_0023);
						return;
					}
                    if (_panel.viewHandle)
                    {
                        _panel.viewHandle.storeFlyDatas();
                    } 
					
					var count:int = WelfareDataMannager.instance.awardCount;
					WelfareDataMannager.instance.getSignReward(count);
					break;
				}
				case _skin.btn0:
				{
					dealBtn(0);
					break;
				}
				case _skin.btn1:
				{
					dealBtn(1);
					break;
				}	
				case _skin.btn2:
				{
					dealBtn(2);
					break;
				}
				case _skin.btn3:
				{
					dealBtn(3);
					break;
				}
				case _skin.btn4:
				{
					dealBtn(4);
					break;
				}
				case _skin.txt2:
				{
					//Alert.warning(StringConst.WELFARE_PANEL_0018);
					PanelMediator.instance.openPanel(PanelConst.TYPE_VIP);
					 
					break;
				}
				case _skin.txt1:
				{
					PanelMediator.instance.openPanel(PanelConst.TYPE_VIP);
					var panel:PanelVip = PanelMediator.instance.openedPanel(PanelConst.TYPE_VIP) as PanelVip;
					panel.setTabIndex(1);
					break;
				}
					
			}
		}
		
		public function dealBtn(index:int):void
		{
			WelfareDataMannager.instance.awardIndex = index;
			_awardIndex = index;
			var temp:Array = [0,1,2,3,4];
			var awardList:Array = WelfareDataMannager.instance.awardList;
			temp.splice(index,1);
			_skin['btn'+index].selected = true;
			for(var i:int = 0;i < temp.length; i++)
			{
				_skin['btn'+temp[i]].selected = false; 
			}
			temp = [2,5,10,18,26];
			WelfareDataMannager.instance.awardCount = temp[index];
			_panel.viewHandle.rerfresh();
			_panel.viewHandle.refreshAward();
//			var matrix:Array=[0.3086, 0.6094, 0.0820, 0, 0,  
//				0.3086, 0.6094, 0.0820, 0, 0,  
//				0.3086, 0.6094, 0.0820, 0, 0,  
//				0,      0,      0,      1, 0];  
//			
//			var filter:ColorMatrixFilter=new ColorMatrixFilter(matrix);  
//			if(awardList[index] == 1)
//			{
//				_skin.lingquBtn.mouseEnabled = false;
//				
//				_skin.lingquBtn.filters = [filter];
//			}
//			else
//			{
//				var arr:Array = WelfareDataMannager.instance.getRecivableAward();
//				if(arr.indexOf(index)==-1){
//					_skin.lingquBtn.mouseEnabled = false;
//					_skin.lingquBtn.filters = [filter];
//				}else{
//					_skin.lingquBtn.filters = [];
//					_skin.lingquBtn.mouseEnabled = true;
//				}
//			}	
		}
		
		public function destroy():void
		{
			_skin.lingquBtn.removeEventListener(MouseEvent.CLICK,onClick);
			_skin.buqianBtn.removeEventListener(MouseEvent.CLICK,onClick);
			_skin.qiandaoBtn.removeEventListener(MouseEvent.CLICK,onClick);
			for(var i:int = 0;i < 5;i++)
			{
				_skin['btn'+i].removeEventListener(MouseEvent.CLICK,onClick);
			}
			_skin.txt2.removeEventListener(MouseEvent.CLICK,onClick);
			_skin.txt1.removeEventListener(MouseEvent.CLICK,onClick);
			SimpleStateButton.removeState(_skin.txt2);
			SimpleStateButton.removeState(_skin.txt1);
		}
	}
}