package com.view.gameWindow.panel.panels.skill
{
	import com.view.gameWindow.mainUi.subuis.bottombar.actBar.ActionBarCell;
	import com.view.gameWindow.mainUi.subuis.bottombar.actBar.ActionBarDataManager;
	import com.view.gameWindow.scene.entity.constants.EntityTypes;
	
	import flash.display.Bitmap;
	import flash.display.MovieClip;
	import flash.events.MouseEvent;

	/**
	 * 技能项技能图标拖动处理类
	 * @author Administrator
	 */	
	public class PanelSkillItemDragHandle
	{
		private var _layer:MovieClip;
		private var _dragBitmap:Bitmap;
		private var _clickCellParents:PanelSkillItem;
		
		public function PanelSkillItemDragHandle(layer:MovieClip)
		{
			_layer = layer;
			init();
		}
		
		private function init():void
		{
			_layer.addEventListener(MouseEvent.MOUSE_DOWN,onDown);
		}
		
		protected function onDown(event:MouseEvent):void
		{
			var entity_type:int = SkillDataManager.instance.entity_type;
			if(entity_type == EntityTypes.ET_HERO)
			{
				return;
			}
			var clickCell:MovieClip = event.target as MovieClip;
			if(!clickCell)
				return;
			_clickCellParents = clickCell.parent as PanelSkillItem;
			if(_clickCellParents && _clickCellParents.isBD)
			{
				_clickCellParents = null;
			}
			if(!_clickCellParents)
			{
				return;
			}
			if(_clickCellParents.isUnactivated)
			{
				return;
			}
			/*if(_clickCellParents.isInCd)
			{
				RollTipMediator.instance.showRollTip(RollTipType.ERROR,StringConst.PROMPT_PANEL_0026);
				return;
			}*/
			if(clickCell != _clickCellParents.mcIcon)
				return;
			_layer.stage.addEventListener(MouseEvent.MOUSE_MOVE,onMove);
			_layer.stage.addEventListener(MouseEvent.MOUSE_UP,onUp);
		}
		
		protected function onMove(event:MouseEvent):void
		{
			if(_clickCellParents)
			{
				if(!_dragBitmap)
				{
					_dragBitmap = _clickCellParents.getBitmap();
					_layer.stage.addChild(_dragBitmap);
				}
				_dragBitmap.x = _layer.stage.mouseX - _dragBitmap.width/2;
				_dragBitmap.y = _layer.stage.mouseY - _dragBitmap.height/2;
			}
			else
			{
				_layer.stage.removeEventListener(MouseEvent.MOUSE_MOVE,onMove);
				_layer.stage.removeEventListener(MouseEvent.MOUSE_UP,onUp);
			}
		}
		
		protected function onUp(event:MouseEvent):void
		{
			if(_clickCellParents && _dragBitmap)
			{
				var upCell:ActionBarCell = event.target as ActionBarCell;
				if(upCell)
				{
					/*if(!upCell.isInCd)
					{*/
						ActionBarDataManager.instance.sendSetSkillData(upCell.key,_clickCellParents.groupId);
					/*}
					else
					{
						RollTipMediator.instance.showRollTip(RollTipType.ERROR,StringConst.PROMPT_PANEL_0026);
					}*/
				}
				if(_dragBitmap.parent)
				{
					_layer.stage.removeChild(_dragBitmap);
				}
			}
			_clickCellParents = null;
			_dragBitmap = null;
			_layer.stage.removeEventListener(MouseEvent.MOUSE_MOVE,onMove);
			_layer.stage.removeEventListener(MouseEvent.MOUSE_UP,onUp);
		}
		
		public function destory():void
		{
			_clickCellParents = null;
			if(_dragBitmap && _dragBitmap.parent)
				_layer.stage.removeChild(_dragBitmap);
			_dragBitmap = null;
			if(_layer)
			{
				_layer.removeEventListener(MouseEvent.MOUSE_DOWN,onDown);
				_layer.stage.removeEventListener(MouseEvent.MOUSE_MOVE,onMove);
				_layer.stage.removeEventListener(MouseEvent.MOUSE_UP,onUp);
			}
			_layer = null;
		}
	}
}