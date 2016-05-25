package com.view.gameWindow.panel.panels.prompt
{
	import com.model.gameWindow.rsr.RsrLoader;
	import com.view.gameWindow.panel.PanelMediator;
	import com.view.gameWindow.panel.panelbase.PanelBase;
	
	import flash.display.MovieClip;
	import flash.events.MouseEvent;

	/**
	 * 一键提示框面板类
	 * @author Administrator
	 */	
	public class Panel1BtnPrompt extends PanelBase implements IPanel1BtnPrompt
	{
		public function Panel1BtnPrompt(panelType:String)
		{
			_panelType = panelType;
			super();
		}

		private var _panelType:String;
		private var _contentH:Number;
		
		override protected function initSkin():void
		{
			_skin = new McPanel1BtnPrompt();
			addChild(_skin);
			setTitleBar((_skin as McPanel1BtnPrompt).mcTitleBar);
		}
		
		override protected function addCallBack(rsrLoader:RsrLoader):void
		{
			var skin:McPanel1BtnPrompt = _skin as McPanel1BtnPrompt;
			rsrLoader.addCallBack(skin.btnSelect,function (mc:MovieClip):void
			{
				refreshSelect();
			});
		}
		
		override protected function initData():void
		{
			var skin:McPanel1BtnPrompt = _skin as McPanel1BtnPrompt;
			skin.txtBtn.mouseEnabled = false;
			skin.txtContent.mouseEnabled = false;
			_contentH = skin.txtContent.height;
			skin.txtName.mouseEnabled = false;
			addEventListener(MouseEvent.CLICK,onClick);
		}

		override public function update(proc:int = 0):void
		{
			var skin:McPanel1BtnPrompt = _skin as McPanel1BtnPrompt;
			skin.txtName.text = Panel1BtnPromptData.strName;
			skin.txtContent.htmlText = Panel1BtnPromptData.strContent;
			skin.txtContent.height = skin.txtContent.textHeight + 5;
			var addHeight:Number = skin.txtContent.height - _contentH;
			if (addHeight > 0)
			{
				skin.mcBg.height += addHeight;
				skin.btnOne.y += addHeight;
				skin.txtBtn.y += addHeight;
			}
			skin.txtContent.y = (skin.height-100-skin.txtContent.height)*0.5+32;
			skin.txtBtn.text = Panel1BtnPromptData.strBtn;
			refreshSelect();
		}

		override public function destroy():void
		{
			Panel1BtnPromptData.funcBtnParam = null;
			Panel1BtnPromptData.funcSelect = null;
			Panel1BtnPromptData.funcBtnParam = null;
			Panel1BtnPromptData.funcBtn = null;
			Panel1BtnPromptData.strBtn = "";
			Panel1BtnPromptData.strContent = "";
			Panel1BtnPromptData.strName = "";
			Panel1BtnPromptData.strSelect = "";
			Panel1BtnPromptData.funcCloseBtn = null;
			Panel1BtnPromptData.funcCloseParam = null;
			removeEventListener(MouseEvent.CLICK, onClick);
			super.destroy();
		}
		
		protected function refreshSelect():void
		{
			var skin:McPanel1BtnPrompt = _skin as McPanel1BtnPrompt;
			var selectFunc:Function = Panel1BtnPromptData.funcSelect;
			skin.btnSelect.visible = selectFunc != null;
			skin.txtSelect.text = Panel1BtnPromptData.strSelect;
		}

		protected function onClick(event:MouseEvent):void
		{
			var skin:McPanel1BtnPrompt = _skin as McPanel1BtnPrompt;
			switch (event.target)
			{
				case skin.btnClose:
					var closeFunc:Function = Panel1BtnPromptData.funcCloseBtn;
					var closeFuncParam:* = Panel1BtnPromptData.funcCloseParam;
					if (closeFunc != null)
					{
						if (closeFuncParam)
						{
							closeFunc(closeFuncParam);
						} else
						{
							closeFunc()
						}
					}
					PanelMediator.instance.closePanel(_panelType);
					break;
				case skin.btnOne:
					var btnFun:Function = Panel1BtnPromptData.funcBtn;
					if (btnFun != null)
					{
						var funcBtnParam:* = Panel1BtnPromptData.funcBtnParam;
						if (btnFun.length)
						{
							btnFun(Panel1BtnPromptData.funcBtnParam);
						}
						else
						{
							btnFun();
						}
					}
					PanelMediator.instance.switchPanel(_panelType);
					break;
				case skin.btnSelect:
					var funcSelect:Function = Panel1BtnPromptData.funcSelect;
					if (funcSelect != null)
					{
						var funcSelectParam:* = Panel1BtnPromptData.funcSelectParam;
						if (funcSelectParam)
						{
							funcSelect(funcSelectParam);
						}
						else
						{
							if(funcSelect.length==1){//说明传入参数个数
								funcSelect(skin.btnSelect.selected);
							}else{
								funcSelect();
							}
						}
					}
					break;
			}
		}
	}
}