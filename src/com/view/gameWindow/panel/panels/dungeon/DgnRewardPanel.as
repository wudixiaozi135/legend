package com.view.gameWindow.panel.panels.dungeon
{
	import com.greensock.TweenLite;
	import com.model.configData.cfgdata.DgnRewardEvaluateCfgData;
	import com.model.configData.cfgdata.DgnRewardMultipleCfgData;
	import com.model.gameWindow.rsr.RsrLoader;
	import com.view.gameWindow.common.CountCallback;
	import com.view.gameWindow.common.PropertyOrganizer;
	import com.view.gameWindow.flyEffect.FlyEffectMediator;
	import com.view.gameWindow.panel.PanelConst;
	import com.view.gameWindow.panel.PanelMediator;
	import com.view.gameWindow.panel.panelbase.PanelBase;
	import com.view.gameWindow.panel.panels.bag.BagDataManager;
	import com.view.gameWindow.tips.rollTip.RollTipMediator;
	import com.view.gameWindow.tips.rollTip.RollTipType;
	import com.view.gameWindow.tips.toolTip.ToolTipManager;
	import com.view.gameWindow.util.HtmlUtils;
	import com.view.gameWindow.util.cell.IconCellEx;
	
	import flash.display.Bitmap;
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.utils.clearInterval;
	import flash.utils.setInterval;
	
	
	/**
	 * @author wqhk
	 * 2014-9-6
	 */
	public class DgnRewardPanel extends PanelBase
	{
		private var _ui:McDungeonRewardPanel;
		private var _p:PropertyOrganizer;
		private var _dataMgr:DgnGoalsDataManager;
		private var _star:int;
		private var _countCallback:CountCallback;
		private var _arrowAnim:TweenLite;
		private var _arrowIndex:int = -1;
		private var _itemList:Vector.<IconCellEx>;
		private var _over:Boolean = false;
		
		public function DgnRewardPanel()
		{
			super();
		}
		
		override protected function initSkin():void
		{
			_ui = new McDungeonRewardPanel();
			_skin = _ui;
			
			addChild(_skin);
			
			_dataMgr = DgnGoalsDataManager.instance;
			
			_p = new PropertyOrganizer(this);
			
			_p.register("starNum","skin",null,updateStarFlag);
			
			
			_countCallback = new CountCallback(starInit,5+4);
			
			_itemList = new Vector.<IconCellEx>;
			
			for(var i:int = 0; i < 5; ++i)
			{
				var icon:IconCellEx = new IconCellEx(_ui.arrowGroup["item"+i],0,0,50,50);
				_itemList.push(icon);
				ToolTipManager.getInstance().attach(icon);
			}
			
			addEventListener(MouseEvent.CLICK,clickHandler);
			
			_p.update("starNum");
		}
		
		private function clickHandler(e:MouseEvent):void
		{
			switch(e.target)
			{
				case _ui.btnClose:
					_dataMgr.requestReward(0);
					PanelMediator.instance.closePanel(PanelConst.TYPE_DUNGEON_REWARD);
					break;
				case _ui.btn0:
					if(_dataMgr.requestReward(0) && hasBagCell())
					{
						afterFly(0);
					}
					break;
				case _ui.btn1:
					if(_dataMgr.requestReward(1) && hasBagCell())
					{
						afterFly(1);
					}
					break;
				case _ui.btn2:
					if(_dataMgr.requestReward(2) && hasBagCell())
					{
						afterFly(2); 
					}
					break;
				case _ui.btn3:
					if(_dataMgr.requestReward(3) && hasBagCell())
					{
						afterFly(3);
					}
					break;
				case _ui.autoBtn:
					var autoResult:Object = _dataMgr.getAutoTip(_ui.autoBtn.selected);
					
					if(autoResult.result == 0)
					{
						_ui.autoBtn.selected = !_ui.autoBtn.selected;
					}
					
					_dataMgr.isFullStar = _ui.autoBtn.selected;
					_p.update("starNum");
					
					/*Alert.show(autoResult.tip);*/
					RollTipMediator.instance.showRollTip(RollTipType.SYSTEM,HtmlUtils.createHtmlStr(0xffc000,autoResult.tip));
					break;
			}
			
			function hasBagCell():Boolean
			{
				return BagDataManager.instance.remainCellNum == 0?false:true;
			}
			
			function afterFly(index:int):void
			{
				FlyEffectMediator.instance.doFlyReceiveThings2(getCellsBitmap());
				var id:uint = setInterval(function():void
				{
					PanelMediator.instance.closePanel(PanelConst.TYPE_DUNGEON_REWARD);
					clearInterval(id);
				},500);
			}
		}
		
		override protected function addCallBack(rsrLoader:RsrLoader):void
		{
			rsrLoader.addCallBack(_ui.arrowGroup.star0,starLoadCompleteHandler);
			rsrLoader.addCallBack(_ui.arrowGroup.star1,starLoadCompleteHandler);
			rsrLoader.addCallBack(_ui.arrowGroup.star2,starLoadCompleteHandler);
			rsrLoader.addCallBack(_ui.arrowGroup.star3,starLoadCompleteHandler);
			rsrLoader.addCallBack(_ui.arrowGroup.star4,starLoadCompleteHandler);
			
			rsrLoader.addCallBack(_ui.btn0,starLoadCompleteHandler);
			rsrLoader.addCallBack(_ui.btn1,starLoadCompleteHandler);
			rsrLoader.addCallBack(_ui.btn2,starLoadCompleteHandler);
			rsrLoader.addCallBack(_ui.btn3,starLoadCompleteHandler);
		}
		
		override public function destroy():void
		{
			destroyItems();
			removeEventListener(MouseEvent.CLICK,clickHandler);
			
			if(_ui.arrowGroup)
			{
				_ui.arrowGroup.star0.removeEventListener(MouseEvent.ROLL_OVER,starOverHandler0);
				_ui.arrowGroup.star1.removeEventListener(MouseEvent.ROLL_OVER,starOverHandler1);
				_ui.arrowGroup.star2.removeEventListener(MouseEvent.ROLL_OVER,starOverHandler2);
				_ui.arrowGroup.star3.removeEventListener(MouseEvent.ROLL_OVER,starOverHandler3);
				_ui.arrowGroup.star4.removeEventListener(MouseEvent.ROLL_OVER,starOverHandler4);
				
				_ui.arrowGroup.removeEventListener(MouseEvent.ROLL_OUT,arrowOutHandler);
				_ui.arrowGroup.removeEventListener(MouseEvent.ROLL_OVER,arrowOverHandler);
			}
			
			if(_arrowAnim)
			{
				_arrowAnim.kill();
				_arrowAnim = null;
			}
			
			super.destroy();
		}
		
		private function starLoadCompleteHandler(mc:MovieClip):void
		{
			_countCallback.call();
		}
		
		private function starInit():void
		{
			_ui.arrowGroup.star0.addEventListener(MouseEvent.ROLL_OVER,starOverHandler0);
			_ui.arrowGroup.star1.addEventListener(MouseEvent.ROLL_OVER,starOverHandler1);
			_ui.arrowGroup.star2.addEventListener(MouseEvent.ROLL_OVER,starOverHandler2);
			_ui.arrowGroup.star3.addEventListener(MouseEvent.ROLL_OVER,starOverHandler3);
			_ui.arrowGroup.star4.addEventListener(MouseEvent.ROLL_OVER,starOverHandler4);
			
			_ui.arrowGroup.addEventListener(MouseEvent.ROLL_OUT,arrowOutHandler);
			_ui.arrowGroup.addEventListener(MouseEvent.ROLL_OVER,arrowOverHandler);
			

			_ui.btn0.addEventListener(MouseEvent.ROLL_OVER,btnOverHandler0);
			_ui.btn1.addEventListener(MouseEvent.ROLL_OVER,btnOverHandler1);
			_ui.btn2.addEventListener(MouseEvent.ROLL_OVER,btnOverHandler2);
			_ui.btn3.addEventListener(MouseEvent.ROLL_OVER,btnOverHandler3);
			
			_ui.btn0.addEventListener(MouseEvent.ROLL_OUT,btnOutHandler);
			_ui.btn1.addEventListener(MouseEvent.ROLL_OUT,btnOutHandler);
			_ui.btn2.addEventListener(MouseEvent.ROLL_OUT,btnOutHandler);
			_ui.btn3.addEventListener(MouseEvent.ROLL_OUT,btnOutHandler);
			
			_p.update("starNum");
		}
		
		private var _btnCenterPos:int = 424;
		private var _btnGap:int = 22;
		private var _btnWidth:int = 81;
		
		private function resetBtnPos(btnWidth:int,center:int,gap:int):void
		{
			var showBtns:Array = [];
			var showTips:Array = [];
			
			var btnWidth:int = 0
			for(var i:int = 0; i < 4; ++i)
			{
				var btn:* = _ui["btn"+i];
				var tip:* = _ui["btnTip"+i];
				if(btn.visible)
				{
					btnWidth = btn.width;
					showBtns.push(btn);
					showTips.push(tip);
				}
			}
			
			if(showBtns.length > 0)
			{
				var width:int = showBtns.length > 1 ? (showBtns.length - 1)*gap+showBtns.length*btnWidth : btnWidth;
				
				var startX:int = center - width/2;
				
				for(var index:int = 0; index < showBtns.length; ++index)
				{
					showBtns[index].x = startX + index*(btnWidth+gap);
					
					showTips[index].x = showBtns[index].x + (showBtns[index].width - showTips[index].width)/2;
				}
			}
			
		}
		
		private var _btnOverIndex:int = 0;
		
		private function btnOverHandler0(e:MouseEvent):void
		{
			_btnOverIndex = 0;
			setItemDetail(_arrowIndex,_btnOverIndex);
		}
		
		private function btnOverHandler1(e:MouseEvent):void
		{
			_btnOverIndex = 1;
			setItemDetail(_arrowIndex,_btnOverIndex);
		}
		
		private function btnOverHandler2(e:MouseEvent):void
		{
			_btnOverIndex = 2;
			setItemDetail(_arrowIndex,_btnOverIndex);
		}
		
		private function btnOverHandler3(e:MouseEvent):void
		{
			_btnOverIndex = 3;
			setItemDetail(_arrowIndex,_btnOverIndex);
		}
		
		private function btnOverHandler4(e:MouseEvent):void
		{
			_btnOverIndex = 4;
			setItemDetail(_arrowIndex,_btnOverIndex);
		}
		
		private function btnOutHandler(e:MouseEvent):void
		{
			trace("btnOutHandler");
			_btnOverIndex = 0;
			setItemDetail(_arrowIndex,_btnOverIndex);
		}
		
		private function arrowOverHandler(e:MouseEvent):void
		{
			_over = true;
		}
		
		private function arrowOutHandler(e:MouseEvent):void
		{
			_over = false;
			setArrow(_star-1);
		}
		
		private function starOverHandler0(e:MouseEvent):void
		{
			setArrow(0);
		}
		private function starOverHandler1(e:MouseEvent):void
		{
			setArrow(1);
		}
		private function starOverHandler2(e:MouseEvent):void
		{
			setArrow(2);
		}
		private function starOverHandler3(e:MouseEvent):void
		{
			setArrow(3);
		}
		private function starOverHandler4(e:MouseEvent):void
		{
			setArrow(4);
		}
	
		private function setArrow(index:int):void
		{
			if(_arrowIndex == index)
			{
				return;
			}
			var starMc:MovieClip = _ui.arrowGroup["star"+index];
			var x:int = starMc.x + starMc.width/2 - _ui.arrowGroup.arrow.width/2;
			
			if(_arrowAnim)
			{
				_arrowAnim.kill();
				_arrowAnim = null;
			}
			
			_arrowIndex = index;
			_arrowAnim = TweenLite.to(_ui.arrowGroup.arrow,0.5,{x:x,onComplete:arrowComplete});
			
			for(var i:int = 0; i < 5; ++i)
			{
				if(i>_arrowIndex)
				{
					_ui.arrowGroup["star"+i].gotoAndStop(1);
				}
				else
				{
					_ui.arrowGroup["star"+i].gotoAndStop(2);
				}
			}
		}
		
		private function arrowComplete():void
		{
			setItemDetail(_arrowIndex,_btnOverIndex);
		}
		
		public function getCellsBitmap():Array
		{
			var cell:IconCellEx;
			var data:Array = [];
			var bitmap:Bitmap;
			for each(cell in _itemList) 
			{
				if(cell && cell.numChildren>1)
				{
					//trace(cell.numChildren," ",cell.getChildAt(0)," ",cell.getChildAt(1) );
					if(cell.getChildByName('iconCellBmp'))
					{
						bitmap =Bitmap(cell.getChildByName('iconCellBmp'));
						bitmap.name = cell.id.toString();
						data.push(bitmap);
					}
				}
			}
			return data;
		}
		
		private function destroyItems():void
		{
			for each(var item:IconCellEx in _itemList)
			{
				item.destroy();
				ToolTipManager.getInstance().detach(item);
			}
		}
		
		private function clearItems():void
		{
			for each(var item:IconCellEx in _itemList)
			{
				item.destroy();
			}
		}
		
		private function setItemDetail(index:int,btnIndex:int):void
		{
			var multi:DgnRewardMultipleCfgData = _dataMgr.findMultiple(btnIndex);
			
			//不好 要是有list就好了
			var data:DgnRewardEvaluateCfgData = _dataMgr.findRewardDataByStar(index+1);
			if(data)
			{
				var items:Array = [];
				if(data.exp > 0)
				{
					items.push("1:1:"+data.exp);
				}
				
				if(data.bind_coin > 0)
				{
					items.push("3:1:"+data.bind_coin);
				}
				
				if(data.item)
				{
					items = items.concat(data.item.split("|"));
				}
				
				for(var i:int = 0; i < 5; ++i)
				{
					var icon:IconCellEx = _itemList[i];
					
					if(i<items.length)
					{
						var it:String = items[i];
						var parsed:Array = it.split(":");
						
						var id:int = parsed[0];
						var type:int = parsed[1];
						var num:int = parsed[2]*multi.multiple;
						
						IconCellEx.setItem(icon,type,id,num,true);
					}
					else
					{
						icon.url = null;
					}
				}
			}
			else
			{
				clearItems();
			}
		}
		
		private function updateStarFlag(mc:MovieClip):void
		{
			//
			_star = _dataMgr.getStar();
			
			mc.starFlag.gotoAndStop(_star);
			//
			for(var i:int = 0;i<5;++i)
			{
				if(i+1>_star)
				{
					mc.arrowGroup["star"+i].gotoAndStop(1);
				}
				else
				{
					mc.arrowGroup["star"+i].gotoAndStop(2);
				}
			}
			
			if(!_over)
			{
				setArrow(_star-1);
			}
			
			if(mc.btn0.txt)
			{
				mc.btn0.txt.text = _dataMgr.getBtnTxt(0);
				mc.btnTip0.text = _dataMgr.getBtnTip(0);
				
				mc.btn0.visible = _dataMgr.findMultiple(0) ? true : false;
				mc.btnTip0.visible = _dataMgr.findMultiple(0) ? true : false;
			}
			
			if(mc.btn1.txt)
			{
				mc.btn1.txt.text = _dataMgr.getBtnTxt(1);
				mc.btnTip1.text = _dataMgr.getBtnTip(1);
				
				mc.btn1.visible = _dataMgr.findMultiple(1) ? true : false;
				mc.btnTip1.visible = _dataMgr.findMultiple(1) ? true : false;
			}
			
			if(mc.btn2.txt)
			{
				mc.btn2.txt.text = _dataMgr.getBtnTxt(2);
				mc.btnTip2.text = _dataMgr.getBtnTip(2);
				
				mc.btn2.visible = _dataMgr.findMultiple(2) ? true : false;
				mc.btnTip2.visible = _dataMgr.findMultiple(2) ? true : false;
			}
			
			if(mc.btn3.txt)
			{
				mc.btn3.txt.text = _dataMgr.getBtnTxt(3);
				mc.btnTip3.text = _dataMgr.getBtnTip(3);
				
				mc.btn3.visible = _dataMgr.findMultiple(3) ? true : false;
				mc.btnTip3.visible = _dataMgr.findMultiple(3) ? true : false;
			}
			
			mc.autoTxt.text = _dataMgr.getAutoTxt();
			
			if(mc.autoTxt.text == "")
			{
				mc.autoBtn.visible = false;
			}
			else
			{
				mc.autoBtn.visible = true;
			}
			
			resetBtnPos(_btnWidth,_btnCenterPos,_btnGap);
		}
	}
}