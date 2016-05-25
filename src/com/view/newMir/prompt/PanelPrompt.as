package com.view.newMir.prompt
{
	import com.model.business.fileService.constants.ResourcePathConstants;
	import com.model.gameWindow.rsr.RsrLoader;
	import com.view.gameWindow.panel.panels.prompt.McPanel1BtnPrompt;
	import com.view.gameWindow.util.Cover;
	import com.view.newMir.NewMirMediator;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.geom.Rectangle;
	
	public class PanelPrompt extends Sprite
	{
		private var _mcPanelBtnPrompt:McPanel1BtnPrompt;
		private var rect:Rectangle;
		
		public function PanelPrompt()
		{
			
		}

		public function init(stage:Stage):void
		{
			var cover:Cover = new Cover(0xff0000,0);
			_mcPanelBtnPrompt = new McPanel1BtnPrompt();
			var rsrLoad:RsrLoader = new RsrLoader();
			rsrLoad.addCallBack(_mcPanelBtnPrompt.btnSelect,function (mc:MovieClip):void
			{
				_mcPanelBtnPrompt.btnSelect.visible = false;
			});
			_mcPanelBtnPrompt.btnSelect.visible = false;
			var mouseEvent:PanelBtnPromptMouseHandle = new PanelBtnPromptMouseHandle();
			stage.addChild(cover);
			rsrLoad.load(_mcPanelBtnPrompt,ResourcePathConstants.IMAGE_PANEL_FOLDER_LOAD);
			_mcPanelBtnPrompt.txtName.text = PanelPromptData.txtName;
			_mcPanelBtnPrompt.txtContent.text = PanelPromptData.txtContent;
			_mcPanelBtnPrompt.txtBtn.text = PanelPromptData.txtBtn;
			_mcPanelBtnPrompt.txtBtn.mouseEnabled = false;
			stage.addChild(_mcPanelBtnPrompt);
			rect = new Rectangle(0,0,_mcPanelBtnPrompt.width,_mcPanelBtnPrompt.height);
			var newMirMediator:NewMirMediator = NewMirMediator.getInstance();
			_mcPanelBtnPrompt.x = int((newMirMediator.width - rect.width)*.5);
			_mcPanelBtnPrompt.y = int((newMirMediator.height - rect.height)*.5);
			mouseEvent.addEvent(_mcPanelBtnPrompt,cover);
		}
		
		public function refreshXY(width:int,height:int):void
		{
			_mcPanelBtnPrompt.x = int((width - rect.width)*.5);
			_mcPanelBtnPrompt.y = int((height - rect.height)*.5);
		}
	}
}