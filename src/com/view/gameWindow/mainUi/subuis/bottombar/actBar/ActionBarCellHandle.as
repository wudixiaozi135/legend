package com.view.gameWindow.mainUi.subuis.bottombar.actBar
{
	import com.view.gameWindow.mainUi.subclass.McMainUIBottom;
	import com.view.gameWindow.panel.panels.roleProperty.RoleDataManager;

	/**
	 * 动作条单元格处理类
	 * @author Administrator
	 */	
	public class ActionBarCellHandle
	{
		private var _layer:McMainUIBottom;
		private var _vector:Vector.<ActionBarCell>;

		private var _clickHandle:ActionBarCellClickHandle;
		
		public function ActionBarCellHandle(layer:McMainUIBottom)
		{
			_layer = layer;
			init();
		}
		
		private function init():void
		{
			/*var postions:Vector.<Point> = Vector.<Point>([new Point(145,151),new Point(200,151),new Point(254,151),new Point(309,151),new Point(363,151),new Point(418,151),
				new Point(255,93),new Point(309,93),new Point(363,93),new Point(418,93)]);*/
			var i:int,l:int,actionBarCell:ActionBarCell;
			l = 10;
			_vector = new Vector.<ActionBarCell>(l,true);
			for(i=0;i<l;i++)
			{
				actionBarCell = new ActionBarCell(_layer["btnKey"+i]);
				actionBarCell.key = i;
				_layer.addChild(actionBarCell);
				_vector[i] = actionBarCell;
			}
			_clickHandle = new ActionBarCellClickHandle(_layer);
			var dragHandle:ActionBarCellDragHandle = new ActionBarCellDragHandle(_layer);
			_clickHandle.dragHandle = dragHandle;
		}
		
		public function refreshActionBar():void
		{
			var actBarDatas:Vector.<ActionBarData>,dt:ActionBarData,i:int;
			actBarDatas = ActionBarDataManager.instance.actBarDatas;
			if(!actBarDatas)
			{
				return;
			}
			for each(dt in actBarDatas)
			{
				if(dt && !dt.isPreinstall)
				{
					_vector[i].refreshData(dt.groupId,dt.type);
				}
				else
				{
					_vector[i].setNull();
				}
				i++;
			}
		}
		
		public function playCoolDownEffect(groupId:int):void
		{
			var actionBarData:ActionBarData = ActionBarDataManager.instance.actionBarData(groupId);
			if(!actionBarData || actionBarData.isPreinstall)
			{
				return;
			}
			var actionBarCell:ActionBarCell = _vector[actionBarData.key];
			if(!actionBarCell)
			{
				return;
			}
			actionBarCell.playCoolDownEffect();
		}
		
		public function palyPublicCollDownEffect():void
		{
			var actionBarCell:ActionBarCell,pulbicCoolDown:int;
			pulbicCoolDown = RoleDataManager.instance.pulbicCoolDown;
			for each(actionBarCell in _vector)
			{
				actionBarCell.playCoolDownEffect(pulbicCoolDown);
			}
		}
		
		public function destroy():void
		{
			if(_clickHandle)
			{
				_clickHandle.dragHandle = null;
			}
			_clickHandle = null;
			while(_layer && _layer.numChildren)
			{
				_layer.removeChildAt(0);
			}
			_layer = null;
		}
	}
}