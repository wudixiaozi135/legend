package com.view.gameWindow.panel.panels.welfare.sign
{
    import com.model.configData.ConfigDataManager;
    import com.model.configData.cfgdata.VipCfgData;
    import com.model.consts.EffectConst;
    import com.model.consts.StringConst;
    import com.model.consts.ToolTipConst;
    import com.model.gameWindow.rsr.RsrLoader;
    import com.view.gameWindow.common.HighlightEffectManager;
    import com.view.gameWindow.flyEffect.FlyEffectMediator;
    import com.view.gameWindow.panel.panels.bag.BagDataManager;
    import com.view.gameWindow.panel.panels.vip.VipDataManager;
    import com.view.gameWindow.panel.panels.welfare.MCSign;
    import com.view.gameWindow.panel.panels.welfare.WelfareDataMannager;
    import com.view.gameWindow.tips.toolTip.TipVO;
    import com.view.gameWindow.tips.toolTip.ToolTipManager;
    import com.view.gameWindow.util.Calendar;
    import com.view.gameWindow.util.FilterUtil;
    import com.view.gameWindow.util.LoaderCallBackAdapter;
    import com.view.gameWindow.util.UIEffectLoader;
    import com.view.gameWindow.util.UtilItemParse;
    import com.view.gameWindow.util.cell.IconCellEx;
    import com.view.gameWindow.util.cell.ThingsData;
    
    import flash.display.Bitmap;
    import flash.display.MovieClip;
    import flash.display.Sprite;
    import flash.events.MouseEvent;
    import flash.filters.ColorMatrixFilter;
    import flash.utils.Dictionary;
    import flash.utils.clearInterval;
    import flash.utils.setInterval;
    
    import mx.utils.StringUtil;

    public class SignViewHandle
	{
		private var _panle:TabSign;
		private var _skin:MCSign;
		private var _awardCells:Vector.<IconCellEx> = new Vector.<IconCellEx>();
		private var _calendarMcs:Array = [];
		private const cellNum:int = 42;
		private var _calendar:Calendar;
		private var loadNum:int = 0;

		private var filterUi:HighlightEffectManager;

        private var _btnEffect:UIEffectLoader;
        private var _btnEffectContainer:Sprite;

        private var _btnSignEffect:UIEffectLoader;
        private var _btnSignEffectContainer:Sprite;

        private var _flyDatas:Array = [];//储存飘的icon
		public function SignViewHandle(panle:TabSign)
		{
			_panle = panle;
			_skin = panle.skin as MCSign;
            addEffect();

            _calendar = Calendar.instance;
			filterUi = new HighlightEffectManager
		}

        private function addEffect():void
        {
            _skin.addChild(_btnEffectContainer = new Sprite());
            _btnEffectContainer.mouseEnabled = false;
            _btnEffectContainer.mouseChildren = false;
            _btnEffect = new UIEffectLoader(_btnEffectContainer, 0, 0, 1, 1, EffectConst.RES_WELFARE_EFFECT);
            _btnEffectContainer.x = _skin.lingquBtn.x - ((160 - _skin.lingquBtn.width) >> 1);
            _btnEffectContainer.y = _skin.lingquBtn.y - ((80 - _skin.lingquBtn.height) >> 1) - 2;
            _btnEffectContainer.visible = false;

            _skin.addChild(_btnSignEffectContainer = new Sprite());
            _btnSignEffectContainer.mouseEnabled = false;
            _btnSignEffectContainer.mouseChildren = false;
            _btnSignEffect = new UIEffectLoader(_btnSignEffectContainer, 0, 0, 1, 1, EffectConst.RES_WELFARE_EFFECT);
            _btnSignEffectContainer.x = _skin.qiandaoBtn.x - ((160 - _skin.qiandaoBtn.width) >> 1);
            _btnSignEffectContainer.y = _skin.qiandaoBtn.y - ((80 - _skin.qiandaoBtn.height) >> 1) - 2;
            _btnSignEffectContainer.visible = false;
        }

        private function removeEffect():void
        {
            if (_btnEffect)
            {
                _btnEffect.destroy();
                _btnEffect = null;
            }
            if (_btnEffectContainer && _btnEffectContainer.parent)
            {
                _skin.removeChild(_btnEffectContainer);
                _btnEffectContainer = null;
            }

            if (_btnSignEffect)
            {
                _btnSignEffect.destroy();
                _btnSignEffect = null;
            }
            if (_btnSignEffectContainer && _btnSignEffectContainer.parent)
            {
                _skin.removeChild(_btnSignEffectContainer);
                _btnSignEffectContainer = null;
            }
        }
        
		public function init(rsrLoader:RsrLoader):void
		{
			_calendar.checkCalendar();
			for(var j:int = 0;j < 42;j++)
			{
				rsrLoader.addCallBack(_skin['num'+j],getFun2(j));
			}
			rsrLoader.addCallBack(_skin.mcNum,function(mc:MovieClip):void
			{
				mc.num = WelfareDataMannager.instance.qianInMonthNum;
				loadNum++;
			}
			);
			
			rsrLoader.addCallBack(_skin.mcMonth,function(mc:MovieClip):void
			{
				var r:int = _calendar.currentDate.month+1;
				mc.num =r;
			}
			);
			
			var loaderCallBackAdapter:LoaderCallBackAdapter = new LoaderCallBackAdapter();
			loaderCallBackAdapter.addCallBack(rsrLoader,function():void
			{
				var arr1:Array = WelfareDataMannager.instance.getRecivableAward();
				for(var j:int=0;j<5;j++)
				{
					filterUi.hide(_skin["btn"+j]);
				}
				for(var i:int=0;i<arr1.length;i++)
				{
					if(_skin["btn"+i].hasOwnProperty("load"))
					{
						filterUi.show(_skin,_skin["btn"+arr1[i]]);
					}
				}
			},_skin.btn0,_skin.btn1,_skin.btn2,_skin.btn3,_skin.btn4);
			
			rsrLoader.addCallBack(_skin.lingquBtn,function (mc:MovieClip):void
			{
				_skin.lingquBtn.load=true;
				var index:int = WelfareDataMannager.instance.awardIndex;
				var awardList:Array = WelfareDataMannager.instance.awardList;
				if(awardList[index] == 1)
				{
//					filterUi.hide(_skin.lingquBtn);
                    _btnEffectContainer.visible = false;
				}
				else
				{
					var arr:Array = WelfareDataMannager.instance.getRecivableAward();
					if(arr.indexOf(index)==-1){
//						filterUi.hide(_skin.lingquBtn);
                        _btnEffectContainer.visible = false;
					}else{
						_skin.lingquBtn.filters = [];
						_skin.lingquBtn.mouseEnabled = true;
//						filterUi.show(_skin,_skin.lingquBtn);
                        _btnEffectContainer.visible = true;
					}
				}	
			});
			
			rsrLoader.addCallBack(_skin.qiandaoBtn,function(mc:MovieClip):void
			{
				_skin.qiandaoBtn.load=1;
				handelNumCell();
			});
			
			for(var i:int = 0;i < 6;i++)
			{
				var mc:MovieClip = _skin['mcIcon'+i];
				var cell:IconCellEx = new IconCellEx(mc.parent,mc.x,mc.y,mc.width,mc.height);	
				_awardCells.push(cell);
			}
			
			var id:int = setInterval(function ():void
			{
				if(loadNum == 43)
				{
					WelfareDataMannager.instance.querySign();
					clearInterval(id);
					loadNum = 0;
				}
			},20);
			
			initText();
		}
		
		private function getFun2(index:int):Function
		{
			var fun:Function = function (mc:MovieClip):void
			{
				_calendarMcs[index] = mc;
				mc.addEventListener(MouseEvent.CLICK,_panle.mouseHandle.onClick);
				if(_calendar.lastMonthRemainNums > index || index >= ( _calendar.lastMonthRemainNums+_calendar.currentMonthNums))
				{
					mc.alpha = 0.4;
					mc.buttonMode = false;
					mc.mouseEnabled = false;
				}
				mc.num = _calendar.calender[index];
				if( _calendar.currentMonthDates.indexOf(index)!=-1 && index == _calendar.currentDateIndex)
				{
					mc.isToday = true;
				}
				//trace('_calendar.calender[index]>>>',index,"  ",_calendar.calender[index]);
				loadNum++;
            };
			
			return fun;
		}
		
		private function initText():void
		{
			var data:Array = [2,5,10,18,26];
			for(var i:int = 0;i < 5;i++)
			{
				_skin['qiandaoTxt'+i].text = StringUtil.substitute(StringConst.WELFARE_PANEL_0001,data[i]);
				_skin['qiandaoTxt'+i].mouseEnabled = false;
			}
			
			//_skin.buqianTxt.mouseEnabled = false;
			_skin.txt0.text = StringConst.WELFARE_PANEL_0005;
			_skin.txt1.htmlText = StringConst.WELFARE_PANEL_0002;
			_skin.txt2.htmlText = StringConst.WELFARE_PANEL_0003;
			
			initVipTips();
		}
		
		private function initVipTips():void
		{
			// vip特权 tip
			var tipVo:TipVO = new TipVO;
			tipVo.tipType = ToolTipConst.TEXT_TIP;
			var dic:Dictionary = ConfigDataManager.instance.getAllVipCfgData();
			var str:String = StringUtil.substitute(StringConst.WELFARE_PANEL_0007,VipDataManager.instance.lv);
			var i:int = 1;
			for each(var vipdata:VipCfgData in dic)
			{
				str += StringUtil.substitute(StringConst.WELFARE_PANEL_0006,i,vipdata.add_sign_num);
				i++;
			}
			tipVo.tipData = str;
			ToolTipManager.getInstance().hashTipInfo(_skin.txt1,tipVo);
			ToolTipManager.getInstance().attach(_skin.txt1);
			
		}
		
		
		
		public function refreshAward():void
		{
			var count:int = WelfareDataMannager.instance.awardCount;
			var str:String = ConfigDataManager.instance.getSignRewardByMonth(_calendar.currentDate.month+1,count).reward;
		    var awards:Vector.<ThingsData> =UtilItemParse.getThingsDatas(str);	
			var len2:int = awards.length;
			//destroyCells();
			for(var i:int = 0;i < _awardCells.length;i++)
			{
				//var cell:IconCellEx = new IconCellEx(_skin['mcIcon'+i].parent,_skin['mcIcon'+i].x,_skin['mcIcon'+i].y,_skin['mcIcon'+i].width,_skin['mcIcon'+i].height);	
				if(len2>i)
				{
					//_awardCells.push(cell);
					IconCellEx.setItemByThingsData(_awardCells[i],awards[i]);
					ToolTipManager.getInstance().attach(_awardCells[i]); 
					_skin['cell'+i].visible = true;
				}
				else
				{
					_skin['cell'+i].visible = false;
				}
				
			}
		}
		
		public function rerfresh():void
		{
			var buQianNum:int = WelfareDataMannager.instance.fillSignCount;
			if(_skin.buqianBtn.txt)
			{
				_skin.buqianBtn.filters = buQianNum ==0?[FilterUtil.getGrayfiltes()]:[];
				_skin.buqianBtn.txt.text = StringUtil.substitute(StringConst.WELFARE_PANEL_0004,String(buQianNum))
			}
			_skin.mcNum.num = WelfareDataMannager.instance.qianInMonthNum;
			var index:int = WelfareDataMannager.instance.awardIndex;
			var awardList:Array = WelfareDataMannager.instance.awardList;
			var matrix:Array=[0.3086, 0.6094, 0.0820, 0, 0,  
				0.3086, 0.6094, 0.0820, 0, 0,  
				0.3086, 0.6094, 0.0820, 0, 0,  
				0,      0,      0,      1, 0];  
			var filter:ColorMatrixFilter=new ColorMatrixFilter(matrix); 
			if(awardList[index] == 1)
			{
				_skin.lingquBtn.mouseEnabled = false;
				_skin.lingquBtn.filters = [filter];
//				filterUi.hide(_skin.lingquBtn);
                _btnEffectContainer.visible = false;
			}
			else
			{
				var arr:Array = WelfareDataMannager.instance.getRecivableAward();
				if(arr.indexOf(index)==-1){
					_skin.lingquBtn.mouseEnabled = false;
					_skin.lingquBtn.filters = [filter];
//					filterUi.hide(_skin.lingquBtn);
                    _btnEffectContainer.visible = false;
				}else{
					_skin.lingquBtn.filters = [];
					_skin.lingquBtn.mouseEnabled = true;
					if(_skin.lingquBtn.hasOwnProperty("load"))
					{
//						filterUi.show(_skin,_skin.lingquBtn);
                        _btnEffectContainer.visible = true;
					}
				}
				for(var j:int=0;j<5;j++)
				{
					filterUi.hide(_skin["btn"+j]);
				}
				for(var i:int=0;i<arr.length;i++)
				{
					if(_skin["btn"+i].hasOwnProperty("load"))
					{
						filterUi.show(_skin,_skin["btn"+arr[i]]);
					}
				}
			}	
			
			handelNumCell();
		}
		
		private function handelNumCell():void
		{
			var data:Array = WelfareDataMannager.instance.signList;
			var len:int = data.length;
			
			var mcData:Array = _calendarMcs.slice(_calendar.lastMonthRemainNums,_calendar.currentMonthNums+_calendar.lastMonthRemainNums);
			var signLen:int = data.length;
			var today:int = _calendar.currentDate.date -1;
			for(var i:int = 0;i < len;i++)
			{
				if(mcData[i])
				{
					mcData[i].selected = data[i];
				}
				
				if(i == today)
				{
					//mcData[i].isToday = data[i];
					handleQuanDaoBtn(data[i]);
				}
			}
		}
		
		
		private function handleQuanDaoBtn(flag:int):void
		{
			if(flag == 1)
			{
				_skin.qiandaoBtn.mouseEnabled = false;
				_skin.qiandaoBtn.filters = [FilterUtil.getGrayfiltes()];
//				filterUi.hide(_skin.qiandaoBtn);
                _btnSignEffectContainer.visible = false;
			}
			else
			{
				_skin.qiandaoBtn.filters = [];
				_skin.qiandaoBtn.mouseEnabled = true;
				if(_skin.qiandaoBtn.hasOwnProperty("load"))
				{
//					filterUi.show(_skin,_skin.qiandaoBtn);
                    _btnSignEffectContainer.visible = true;
				}
			}
		}
		
		
		public function flyAward():void
		{
            if (_flyDatas)
            {
				
                FlyEffectMediator.instance.doFlyReceiveThings2(_flyDatas);
                destroyFlyDatas();
            }
		}

        public function storeFlyDatas():void
        {
            
			if( 5 > BagDataManager.instance.lastRemainCellNum)
				return;
			var cell:IconCellEx;
            var bitmap:Bitmap;
			_flyDatas.length = 0;
            for each(cell in _awardCells)
            {
                bitmap = cell.getBitmap();
                if (bitmap)
                {
                    bitmap.name = cell.id.toString();
                    bitmap.width = bitmap.height = 40;
                     cell.addChild(bitmap); 
                    _flyDatas.push(bitmap);
                }
            }
        }
		
		/*private function getAndFlyAwards(data:Vector.<ThingsData>,index:int):void
		{
			var iconcell:IconCellEx;
			var iconData:Array = [];
			for each(var td:ThingsData in data)
			{
				iconcell = new IconCellEx(_ui['progressPoint'+index].parent,_ui['progressPoint'+index].x,_ui['progressPoint'+index].y,_ui['progressPoint'+index].width,_ui['progressPoint'+index].height);
				iconcell.url = ResourcePathConstants.IMAGE_ICON_ITEM_FOLDER_LOAD+td.cfgData.icon+ResourcePathConstants.POSTFIX_PNG;
				iconData.push(iconcell);
			}
			var id:uint = setInterval(function():void
			{
				FlyEffectMediator.instance.doFlyReceiveThings2(iconData);
				clearInterval(id);
			},500);
			
		}*/
		
        private function destroyFlyDatas():void
        {
            if (_flyDatas)
            {
                _flyDatas.forEach(function (element:Bitmap, index:int, arr:Array):void
                {
                    if (element)
                    {
                        if (element.bitmapData)
                        {
                            element.bitmapData.dispose();
                        }
                        if (element.parent)
                        {
                            element.parent.removeChild(element);
                        }
                        element = null;
                    }
                });
                _flyDatas.length = 0;
            }
        }

		private function destroyCells():void
		{
			for each(var cell:IconCellEx in _awardCells)
			{
				if(cell)
				{
					cell.destroy();
				}
			}
			_awardCells.length = 0;
		}
		public function destroy():void
		{
            removeEffect();
            if (_flyDatas)
            {
                destroyFlyDatas();
                _flyDatas = null;
            }
			for(var j:int=0;j<5;j++)
			{
				filterUi.hide(_skin["btn"+j]);
			}
//			filterUi.hide(_skin.qiandaoBtn);
//			filterUi.hide(_skin.lingquBtn);
			filterUi=null;
			ToolTipManager.getInstance().detach(_skin.txt1);
			//_calendar.destroy();
			//_calendar = null;
			_calendarMcs.length = 0;
			_calendarMcs = null;
			destroyCells();
			_awardCells = null;
		}
	}
}