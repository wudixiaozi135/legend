package com.view.gameWindow.mainUi.subuis.bottombar.actBar
{
    import com.model.consts.StringConst;
    import com.view.gameWindow.panel.panels.roleProperty.RoleDataManager;
    import com.view.gameWindow.tips.rollTip.RollTipMediator;
    import com.view.gameWindow.tips.rollTip.RollTipType;

    import flash.display.MovieClip;
    import flash.events.MouseEvent;

    /**
	 * 动作条单元格点击处理类
	 * @author Administrator
	 */	
	public class ActionBarCellClickHandle
	{
		private var _layer:MovieClip;
		internal var dragHandle:ActionBarCellDragHandle;
		
		public function ActionBarCellClickHandle(layer:MovieClip)
		{
			_layer = layer;
			init();
		}
		
		private function init():void
		{
			_layer.addEventListener(MouseEvent.CLICK,onClick);
		}
		
		protected function onClick(event:MouseEvent):void
		{
            if (RoleDataManager.instance.stallStatue)
            {
                RollTipMediator.instance.showRollTip(RollTipType.ERROR, StringConst.STALL_PANEL_0037);
                return;
            }
			var isDraging:Boolean = dragHandle.isDraging;
			if(isDraging)
			{
				return;
			}
			var actionBarCell:ActionBarCell = event.target as ActionBarCell;
			if(!actionBarCell)
			{
				return;
			}
			ActionBarDataManager.instance.pressKey(actionBarCell.key);
		}
	}
}