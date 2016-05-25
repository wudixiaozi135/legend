package com.view.gameWindow.panel.panels.prompt
{
	import com.model.gameWindow.rsr.RsrLoader;
	import com.view.gameWindow.panel.PanelConst;
	import com.view.gameWindow.panel.PanelMediator;
	import com.view.gameWindow.panel.panelbase.PanelBase;
	import com.view.gameWindow.panel.panels.guideSystem.InterObjCollector;
	
	import flash.events.MouseEvent;
	
	public class Panel2BtnPrompt extends PanelBase
	{
		private var _mcPanel2BtnPrompt:*; 
		private var _contentH:Number;
		public function Panel2BtnPrompt()
		{
			super();
		}
		
		override protected function initSkin():void
		{
			if(Panel2BtnPromptData.haveSelected)
			{
				_skin = new McPanel2BtnPromptHaveSelected();
			}
			else
			{
				_skin = new McPanel2BtnPrompt();
			}
			addChild(_skin);
			
			if(Panel2BtnPromptData.haveSelected)
			{
				_mcPanel2BtnPrompt = _skin as McPanel2BtnPromptHaveSelected;
				_mcPanel2BtnPrompt.txtSelect.text = Panel2BtnPromptData.strSelect;
			}
			else
			{
				_mcPanel2BtnPrompt = _skin as McPanel2BtnPrompt;
			}
			_mcPanel2BtnPrompt.txt.mouseEnabled = false;
			_mcPanel2BtnPrompt.sureTxt.mouseEnabled = false;
			_mcPanel2BtnPrompt.cancelTxt.mouseEnabled = false;
			_mcPanel2BtnPrompt.txt.htmlText = Panel2BtnPromptData.strContent;
			_contentH = _mcPanel2BtnPrompt.txt.height;
			_mcPanel2BtnPrompt.sureTxt.text = Panel2BtnPromptData.strSureBtn;
			_mcPanel2BtnPrompt.cancelTxt.text = Panel2BtnPromptData.strCancelBtn;
			addEventListener(MouseEvent.CLICK,onClick);
		}
		
//		override protected function initData():void
//		{
//			
//		}
		
		override public function update(proc:int = 0):void
		{
			_mcPanel2BtnPrompt.txt.htmlText = Panel2BtnPromptData.strContent;
			_mcPanel2BtnPrompt.txt.height = _mcPanel2BtnPrompt.txt.textHeight + 5;
			var addHeight:Number = _mcPanel2BtnPrompt.txt.height - _contentH;
			if (addHeight > 0)
			{
				_mcPanel2BtnPrompt.mcBg.height += addHeight;
				_mcPanel2BtnPrompt.btnSure.y += addHeight;
				_mcPanel2BtnPrompt.btnCancel.y += addHeight;
				_mcPanel2BtnPrompt.sureTxt.y += addHeight;
				_mcPanel2BtnPrompt.cancelTxt.y += addHeight;
				_mcPanel2BtnPrompt.delimt.y += addHeight;
				if(Panel2BtnPromptData.haveSelected)
				{
					_mcPanel2BtnPrompt.txtSelect.y += addHeight;
					_mcPanel2BtnPrompt.btnSelect.y += addHeight;
				}
				
			}
//			_mcPanel2BtnPrompt.txt.y = (_mcPanel2BtnPrompt.height-100-_mcPanel2BtnPrompt.txt.height)*0.5+32;
		}
		
		override protected function addCallBack(rsrLoader:RsrLoader):void
		{
			super.addCallBack(rsrLoader);
			rsrLoader.addCallBack(_mcPanel2BtnPrompt.btnSure,function():void
			{
				InterObjCollector.instance.add(_mcPanel2BtnPrompt.btnSure);
				InterObjCollector.autoCollector.add(_mcPanel2BtnPrompt.btnSure);
			});
		}
		
		protected function onClick(event:MouseEvent):void
		{
			switch(event.target)
			{
				case _mcPanel2BtnPrompt.btnSure:
					var btnFun:Function = Panel2BtnPromptData.funcBtn;
					if(btnFun != null)
					{
						var funcBtnParam:* = Panel2BtnPromptData.funcBtnParam;
						if(funcBtnParam != null)
						{
							btnFun(Panel2BtnPromptData.funcBtnParam);
						}
						else
						{
							btnFun();
						}
					}
					PanelMediator.instance.closePanel(PanelConst.TYPE_2BTN_PROMPT);
					break;
				case _mcPanel2BtnPrompt.btnCancel:
					var cancelFunc:Function = Panel2BtnPromptData.cancelFunc;
					if(cancelFunc!=null)
					{
						cancelFunc();
					}
					PanelMediator.instance.closePanel(PanelConst.TYPE_2BTN_PROMPT);
					break;
			}
			if(Panel2BtnPromptData.haveSelected)
			{
				if(event.target == _mcPanel2BtnPrompt.btnSelect)
				{
					var funcSelect:Function = Panel2BtnPromptData.funcSelect;
					if (funcSelect != null)
					{
						var funcSelectParam:* = Panel2BtnPromptData.funcSelectParam;
						if (funcSelectParam)
						{
							funcSelect(funcSelectParam);
						}
						else
						{
							if(funcSelect.length==1){//说明传入参数个数
								funcSelect(skin.btnSelect.selected);
							}
							else
							{
								funcSelect();
							}
						}
					}
				}
			}
		}
		
		override public function destroy():void
		{
			if(_mcPanel2BtnPrompt.btnSure)
			{
				InterObjCollector.instance.remove(_mcPanel2BtnPrompt.btnSure);
				InterObjCollector.autoCollector.remove(_mcPanel2BtnPrompt.btnSure);
			}
			Panel2BtnPromptData.strContent = "";
			Panel2BtnPromptData.strSureBtn = "";
			Panel2BtnPromptData.strCancelBtn = "";
			Panel2BtnPromptData.strSelect = "";
			Panel2BtnPromptData.haveSelected = false;
			Panel2BtnPromptData.funcBtn = null;
			Panel2BtnPromptData.funcBtnParam = null;
			Panel2BtnPromptData.funcSelect = null;
			Panel2BtnPromptData.funcSelectParam = null;
			Panel2BtnPromptData.cancelFunc = null;
			removeEventListener(MouseEvent.CLICK,onClick);
			_mcPanel2BtnPrompt = null;
			super.destroy();
		}
	}
}