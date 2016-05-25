package com.view.gameWindow.mainUi.subuis.actvEnter
{
	import com.model.consts.StringConst;
	import com.model.consts.ToolTipConst;
	import com.model.gameWindow.rsr.RsrLoader;
	import com.view.gameWindow.mainUi.MainUi;
	import com.view.gameWindow.panel.panelbase.IPanelTab;
	import com.view.gameWindow.tips.toolTip.ToolTipManager;

	import flash.display.MovieClip;

	public class ActvEnter extends MainUi implements IPanelTab
	{
		internal var mouseHandle:ActvEnterMouseHandle;
		internal var viewHandle:ActvEnterViewHandle;
		
		public function ActvEnter()
		{
		}
		
		override public function initView():void
		{
			_skin = new McActvEnter();
			addChild(_skin);
			super.initView();
			initData();
		}
		
		override protected function addCallBack(rsrLoader:RsrLoader):void
		{
            var skin:McActvEnter = _skin as McActvEnter;
			rsrLoader.addCallBack(_skin.mcBtns.mcLayer.btnBoss,function():void
			{
				_skin.mcBtns.mcLayer.btnBoss.buttonMode = true;
				ToolTipManager.getInstance().attachByTipVO(_skin.mcBtns.mcLayer.btnBoss,ToolTipConst.TEXT_TIP,StringConst.BTNTIPS_0017);
			});
			rsrLoader.addCallBack(_skin.mcBtns.mcLayer.btnDragon,function():void
			{
				_skin.mcBtns.mcLayer.btnDragon.buttonMode = true;
				ToolTipManager.getInstance().attachByTipVO(_skin.mcBtns.mcLayer.btnDragon,ToolTipConst.TEXT_TIP,StringConst.BTNTIPS_0018);
			});
			rsrLoader.addCallBack(_skin.mcBtns.mcLayer.btnDaily,function():void
			{
				_skin.mcBtns.mcLayer.btnDaily.buttonMode = true;
				ToolTipManager.getInstance().attachByTipVO(_skin.mcBtns.mcLayer.btnDaily,ToolTipConst.TEXT_TIP,StringConst.BTNTIPS_0019);
			});
			rsrLoader.addCallBack(_skin.mcBtns.mcLayer.btnWelfare,function():void
			{
				_skin.mcBtns.mcLayer.btnWelfare.buttonMode = true;
				ToolTipManager.getInstance().attachByTipVO(_skin.mcBtns.mcLayer.btnWelfare,ToolTipConst.TEXT_TIP,StringConst.BTNTIPS_0020);
			});
			rsrLoader.addCallBack(_skin.mcBtns.mcLayer.btnStronger,function():void
			{
                _skin.mcBtns.mcLayer.btnStronger.visible = false;//屏蔽我要变强
				_skin.mcBtns.mcLayer.btnStronger.buttonMode = true;
				ToolTipManager.getInstance().attachByTipVO(_skin.mcBtns.mcLayer.btnStronger,ToolTipConst.TEXT_TIP,StringConst.BTNTIPS_0021);
			});
			rsrLoader.addCallBack(_skin.mcBtns.mcLayer.btnArtifact,function():void
			{
				_skin.mcBtns.mcLayer.btnArtifact.buttonMode = true;
				ToolTipManager.getInstance().attachByTipVO(_skin.mcBtns.mcLayer.btnArtifact,ToolTipConst.TEXT_TIP,StringConst.BTNTIPS_0022);
			});
			rsrLoader.addCallBack(_skin.mcBtns.mcLayer.btnPray,function():void
			{
				_skin.mcBtns.mcLayer.btnPray.buttonMode = true;
				ToolTipManager.getInstance().attachByTipVO(_skin.mcBtns.mcLayer.btnPray,ToolTipConst.TEXT_TIP,StringConst.BTNTIPS_0023);
			});
			rsrLoader.addCallBack(_skin.mcBtns.mcLayer.btnLoongWar,function():void
			{
				_skin.mcBtns.mcLayer.btnLoongWar.buttonMode = true;
				ToolTipManager.getInstance().attachByTipVO(_skin.mcBtns.mcLayer.btnLoongWar,ToolTipConst.TEXT_TIP,StringConst.BTNTIPS_0026);
			});
			rsrLoader.addCallBack(_skin.mcBtns.mcLayer.btnPickUp,function():void
			{
				_skin.mcBtns.mcLayer.btnPickUp.buttonMode = true;
			});
            rsrLoader.addCallBack(skin.mcBtns.mcLayer.btnKeepGame, function (mc:MovieClip):void
            {
                mc.buttonMode = true;
                ToolTipManager.getInstance().attachByTipVO(mc, ToolTipConst.TEXT_TIP, StringConst.BTNTIPS_0027);
            });
            rsrLoader.addCallBack(skin.mcBtns.mcLayer.btnCharge, function (mc:MovieClip):void
            {
                mc.buttonMode = true;
                ToolTipManager.getInstance().attachByTipVO(mc, ToolTipConst.TEXT_TIP, StringConst.BTNTIPS_0029);
            });
            rsrLoader.addCallBack(skin.mcBtns.mcLayer.btnLogin, function (mc:MovieClip):void
            {
                mc.buttonMode = true;
                ToolTipManager.getInstance().attachByTipVO(mc, ToolTipConst.TEXT_TIP, StringConst.BTNTIPS_0030);
            });

            rsrLoader.addCallBack(skin.mcBtns.mcLayer.btnEveryDay, function (mc:MovieClip):void
            {
                mc.buttonMode = true;
                ToolTipManager.getInstance().attachByTipVO(mc, ToolTipConst.TEXT_TIP, StringConst.BTNTIPS_0031);
            });
			rsrLoader.addCallBack(skin.mcBtns.mcLayer.btnOpenActivity, function (mc:MovieClip):void
			{
				mc.buttonMode = true;
				ToolTipManager.getInstance().attachByTipVO(mc, ToolTipConst.TEXT_TIP, StringConst.BTNTIPS_0032);
			});
			rsrLoader.addCallBack(skin.mcBtns.mcLayer.btnSmart, function (mc:MovieClip):void
			{
				mc.buttonMode = true;
				ToolTipManager.getInstance().attachByTipVO(mc, ToolTipConst.TEXT_TIP, StringConst.BTNTIPS_0033);
			});
            rsrLoader.addCallBack(skin.mcBtns.mcLayer.btnBug, function (mc:MovieClip):void
            {
                mc.buttonMode = true;
                ToolTipManager.getInstance().attachByTipVO(mc, ToolTipConst.TEXT_TIP, StringConst.BTNTIPS_0034);
            });
			rsrLoader.addCallBack(skin.mcBtns.mcLayer.btnEverydayReward, function (mc:MovieClip):void
			{
				mc.buttonMode = true;
				ToolTipManager.getInstance().attachByTipVO(mc, ToolTipConst.TEXT_TIP, StringConst.BTNTIPS_0035);
			});
		}
		
		
		private function initData():void
		{
			mouseHandle = new ActvEnterMouseHandle(this);
			mouseHandle.initialize();
			viewHandle = new ActvEnterViewHandle(this);
			viewHandle.initialize();
		}
		
		public function getTabIndex():int
		{
			return mouseHandle.isSelect ? 0 : 1;
		}
		
		public function setTabIndex(index:int):void
		{
			
		}
	}
}