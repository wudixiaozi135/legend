package com.view.gameWindow.mainUi.subuis.lasting
{
	import com.model.business.fileService.constants.ResourcePathConstants;
	import com.model.consts.ToolTipConst;
	import com.model.gameWindow.mem.MemEquipDataManager;
	import com.pattern.Observer.IObserver;
	import com.view.gameWindow.common.ResManager;
	import com.view.gameWindow.panel.panels.hero.HeroDataManager;
	import com.view.gameWindow.panel.panels.roleProperty.RoleDataManager;
	import com.view.gameWindow.tips.toolTip.ToolTipManager;
	import com.view.gameWindow.tips.toolTip.interfaces.IToolTipClient;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	
	/**
	 * 这个类永远不会释放，所以没有释放函数
	 */
	public class LastingIcon extends Sprite implements IObserver,IToolTipClient
	{
		
		private var _icon:MovieClip;
		private var _lastingHandler:LastingHandler;
		public function LastingIcon()
		{
			super();
			init();
			MemEquipDataManager.instance.attach(this);
			HeroDataManager.instance.attach(this);
			RoleDataManager.instance.attach(this);
		}
		
		private function init():void
		{
			var url:String=ResourcePathConstants.IMAGE_MAINUI_FOLDER_LOAD + "mainUiBottom/medicineBtnR.swf";
			ResManager.getInstance().loadSwf(url,loadSwfcompleFunc);
			_lastingHandler=new LastingHandler(this);
			ToolTipManager.getInstance().attach(this);
//			addEventListener(MouseEvent.CLICK,onClickFunc);
			this.visible=false;
		}
		
//		private function onClickFunc(e:MouseEvent):void
//		{
//			Panel1ImgPrompt.strContent=StringConst.PROMPT_PANEL_0028;
//			Panel1ImgPrompt.strSureBtn=StringConst.PROMPT_PANEL_0029;
//			Panel1ImgPrompt.strCancelBtn=StringConst.PROMPT_PANEL_0030;
//			Panel1ImgPrompt.sureFunc=repairFunc;
//		}
		
		private function repairFunc():void
		{
	
		}
		
		private function loadSwfcompleFunc(mc:MovieClip):void
		{
			_icon=mc;
			addChild(_icon);
		}
		
		public function update(proc:int=0):void
		{
			// TODO Auto Generated method stub
			_lastingHandler.refreshData();
		}
		
		public function getTipData():Object
		{
			// TODO Auto Generated method stub
			return _lastingHandler.lastingArr;
		}
		
		public function getTipType():int
		{
			// TODO Auto Generated method stub
			return ToolTipConst.LASTING_TIP;
		}
		
	}
}