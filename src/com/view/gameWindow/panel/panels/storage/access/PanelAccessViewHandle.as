package com.view.gameWindow.panel.panels.storage.access
{
	import com.model.consts.StringConst;
	import com.view.gameWindow.panel.PanelConst;
	import com.view.gameWindow.panel.PanelMediator;
	import com.view.gameWindow.panel.panels.bag.BagDataManager;
	import com.view.gameWindow.panel.panels.storage.McAccess;
	import com.view.gameWindow.panel.panels.storage.StorageDataMannager;
	import com.view.gameWindow.tips.rollTip.RollTipMediator;
	import com.view.gameWindow.tips.rollTip.RollTipType;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TextEvent;
	import flash.text.TextFieldType;

	public class PanelAccessViewHandle
	{
		private var _skin:McAccess;
		private var _inOrOut:int = 2;//1：取出 2：存入
		private var _goldNum:int = 500;
		public function PanelAccessViewHandle(panel:PanelAccess)
		{
			_skin = panel.skin as McAccess;
			init();
		}
		
		private function init():void
		{
		
			_skin.addEventListener(MouseEvent.CLICK,onClick);
			_skin.otherTxt.type = TextFieldType.INPUT;
			_skin.otherTxt.restrict = '0-9';
			_skin.otherTxt.addEventListener(Event.CHANGE,onChange);
			_skin.otherTxt.addEventListener(TextEvent.TEXT_INPUT,onChange);
			_skin.txtBtn.mouseEnabled = false;
			changeTilte();
		}
		
		public function changeTilte():void
		{
			if(StorageDataMannager.instance.goldOrCoin == 1)
			{
				_skin.otherTxt.text = _skin.txtName.text = "请输入元宝数量"; 
			}
			else
			{
				_skin.otherTxt.text = _skin.txtName.text = "请输入金币数量";
			}
				
		}
		private function onClick(event:MouseEvent):void
		{
			switch(event.target)
			{
				case _skin.depositBtn:
				{
					_skin.txtBtn.text = "确定存入";
					_skin.extractBtn.selected = false;
					_inOrOut = 2;
					break;
				}
				case _skin.extractBtn:
				{
					_skin.txtBtn.text = "确定取出";
					_skin.depositBtn.selected = false;
					_inOrOut = 1;
					break;
				}
				case _skin.btn500:
				{
					_skin.btnother.selected = false;
					_skin.btn1000.selected = false;
					_skin.btn2000.selected = false;
					_skin.btn5000.selected = false;
					changeTilte();
					_goldNum = 500;
					break;
				}
				case _skin.btn1000:
				{
					_skin.btnother.selected = false;
					_skin.btn500.selected = false;
					_skin.btn2000.selected = false;
					_skin.btn5000.selected = false;
					changeTilte();
					_goldNum = 1000;
					break;
				}
				case _skin.btn2000:
				{
					_skin.btnother.selected = false;
					_skin.btn500.selected = false;
					_skin.btn1000.selected = false;
					_skin.btn5000.selected = false;
					changeTilte();
					_goldNum = 2000;
					break;
				}
				case _skin.btn5000:
				{
					_skin.btnother.selected = false;
					_skin.btn500.selected = false;
					_skin.btn1000.selected = false;
					_skin.btn2000.selected = false;
					changeTilte();
					_goldNum = 5000;
					break;
				}
				case _skin.btnother:
				{
					
					_skin.btn500.selected = false;
					_skin.btn1000.selected = false;
					_skin.btn2000.selected = false;
					_skin.btn5000.selected = false;
					changeTilte();
					_goldNum = 0;
					break;
				}
				case _skin.otherTxt:
				{
					_skin.btn500.selected = false;
					_skin.btn1000.selected = false;
					_skin.btn2000.selected = false;
					_skin.btn5000.selected = false;
					_skin.btnother.selected = true;
					_skin.otherTxt.text = '';
					break;
				} 
				case _skin.btnOne:
				{
					var goldOrCoin:int = StorageDataMannager.instance.goldOrCoin;
					var num:int
					if(_skin.btnother.selected)
					{
						num = int(_skin.otherTxt.text);	
					}
					else
					{
						num = _goldNum;
					}
					
					if(_inOrOut == 1 &&  goldOrCoin ==1 && num > StorageDataMannager.instance.goldUnbind)
					{
						//"元宝库存不足,无法提取!"
						RollTipMediator.instance.showRollTip(RollTipType.ERROR,StringConst.STORAGE_057);
						return;
					}
					else if(_inOrOut == 1 &&  goldOrCoin ==2 && num > StorageDataMannager.instance.coinUnbind)
					{
						//"金币库存不足,无法提取!"
						RollTipMediator.instance.showRollTip(RollTipType.ERROR,StringConst.STORAGE_056);
						return;
					}
					StorageDataMannager.instance.accessGoldCoin(goldOrCoin,_inOrOut,num);
					break;
				}
				case _skin.btnClose:
				{
					PanelMediator.instance.switchPanel(PanelConst.TYPE_STORAGE_ACCESS);	
					break;
				}				 
			}
		}
		
		private function onChange(e:Object):void
		{
			if(_skin.btnother.selected && StorageDataMannager.instance.goldOrCoin == 1)
			{
				if(_inOrOut == 1)
				{
					if(int(_skin.otherTxt.text) >= StorageDataMannager.instance.goldUnbind)
						_skin.otherTxt.text = String(StorageDataMannager.instance.goldUnbind);
				}
				else
				{
					if(int(_skin.otherTxt.text) >= BagDataManager.instance.goldUnBind)
						_skin.otherTxt.text = String(BagDataManager.instance.goldUnBind);
				}
				
				
			}
			else if(_skin.btnother.selected && StorageDataMannager.instance.goldOrCoin == 2)
			{
				
				if(_inOrOut == 1)
				{
					if(int(_skin.otherTxt.text) >= StorageDataMannager.instance.coinUnbind)
						_skin.otherTxt.text = String(StorageDataMannager.instance.coinUnbind);
				}
				else
				{
					if(int(_skin.otherTxt.text) >= BagDataManager.instance.coinUnBind)
						_skin.otherTxt.text = String(BagDataManager.instance.coinUnBind);
				}
			} 	
		}
		 
		internal function destroy():void
		{
			_skin.otherTxt.removeEventListener(Event.CHANGE,onChange);
			_skin.removeEventListener(MouseEvent.CLICK,onClick);
			_skin = null;
		}
	}
}