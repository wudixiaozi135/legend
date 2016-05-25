/**
 * Created by Administrator on 2014/11/5.
 */
package com.view.gameWindow.panel.panels.team
{
	import com.model.gameWindow.rsr.RsrLoader;
	import com.view.gameWindow.mainUi.MainUiMediator;
	import com.view.gameWindow.mainUi.subclass.McMainUIBottom;
	import com.view.gameWindow.mainUi.subuis.bottombar.BottomBar;
	import com.view.gameWindow.panel.panelbase.PanelBase;

	import flash.geom.Point;
	import flash.geom.Rectangle;

	public class PanelTeam extends PanelBase
	{
		public function PanelTeam()
		{
			super();
		}

		private var _viewHandle:PanelTeamViewHandle;

		public function get viewHandle():PanelTeamViewHandle
		{
			return _viewHandle;
		}

		private var _mouseHandle:PanelTeamMouseHandle;

		public function get mouseHandle():PanelTeamMouseHandle
		{
			return _mouseHandle;

		}

		private var _callBack:PanelTeamLoadCallBack;

		public function get callBack():PanelTeamLoadCallBack
		{
			return _callBack;
		}

		override protected function initSkin():void
		{
			var skin:McTeam = new McTeam();
			_skin = skin;
			addChild(_skin);
			setTitleBar(skin.dragBox);
		}

		override protected function addCallBack(rsrLoader:RsrLoader):void
		{
			_callBack = new PanelTeamLoadCallBack(this, rsrLoader);
		}

		override protected function initData():void
		{
			_mouseHandle = new PanelTeamMouseHandle(this);
			_viewHandle = new PanelTeamViewHandle(this);
		}

		override public function setPostion():void
		{
            var mc:McMainUIBottom = (MainUiMediator.getInstance().bottomBar as BottomBar).skin as McMainUIBottom;
            if (mc)
            {
                var popPoint:Point = mc.localToGlobal(new Point(mc.teamBtn.x, mc.teamBtn.y));
                isMount(true, popPoint.x, popPoint.y);
            } else
            {
                isMount(true);
            }
		}

		override public function getPanelRect():Rectangle
		{
			return new Rectangle(0, 0, _skin.bg.width, _skin.bg.height);
		}

		override public function destroy():void
		{
			TeamDataManager.instance.selectIndex = 0;
			if (_mouseHandle) {
				_mouseHandle.destroy();
				_mouseHandle = null;
			}
			if (_viewHandle) {
				_viewHandle.destroy();
				_viewHandle = null;
			}
			if (_callBack) {
				_callBack.destroy();
				_callBack = null;
			}
			super.destroy();
		}
	}
}
