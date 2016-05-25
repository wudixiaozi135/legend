package com.view.gameWindow.mainUi.subuis.bottombar.actBar
{
	import flash.display.Bitmap;
	import flash.display.MovieClip;
	import flash.events.MouseEvent;

	/**
	 * 动作条单元格拖动处理类
	 * @author Administrator
	 */	
	public class ActionBarCellDragHandle
	{
		private var _layer:MovieClip;
		private var _dragBitmap:Bitmap;
		private var _clickCell:ActionBarCell;
		private var _isDraging:Boolean;

		public function get isDraging():Boolean
		{
			var isDraging:Boolean = _isDraging;
			_isDraging = false;
			return isDraging;
		}
		
		public function ActionBarCellDragHandle(layer:MovieClip)
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
			_clickCell = event.target as ActionBarCell;
			if(!_clickCell)
			{
				return;
			}
			if(_clickCell.isEmpty)
			{
				return;
			}
			_layer.stage.addEventListener(MouseEvent.MOUSE_MOVE,onMove);
			_layer.stage.addEventListener(MouseEvent.MOUSE_UP,onUp);
		}
		
		protected function onMove(event:MouseEvent):void
		{
			if(_clickCell)
			{
				if(!_dragBitmap)
				{
					_dragBitmap = _clickCell.getBitmap();
					_layer.stage.addChild(_dragBitmap);
				}
				_dragBitmap.x = _layer.stage.mouseX - _dragBitmap.width/2;
				_dragBitmap.y = _layer.stage.mouseY - _dragBitmap.height/2;
				_isDraging = true;
			}
			else
			{
				_layer.stage.removeEventListener(MouseEvent.MOUSE_MOVE,onMove);
				_layer.stage.removeEventListener(MouseEvent.MOUSE_UP,onUp);
			}
		}
		
		protected function onUp(event:MouseEvent):void
		{
			if(_clickCell && _dragBitmap)
			{
				var actBarDatas:Vector.<ActionBarData> = ActionBarDataManager.instance.actBarDatas;
				if(!actBarDatas)
				{
					return;
				}
				var actionBarData:ActionBarData = actBarDatas[_clickCell.key];
				if(actionBarData.isPreinstall)
				{
					return;
				}
				var upCell:ActionBarCell = event.target as ActionBarCell;
				if(upCell)
				{
					if(actionBarData.key == upCell.key)
					{
						_clickCell.setBitmap(_dragBitmap,actionBarData.groupId,actionBarData.type);
					}
					sendData(actionBarData.key,upCell.key);
				}
				else
				{
					sendData(actionBarData.key);
				}
				if(_dragBitmap.parent == _layer.stage)
				{
					_layer.stage.removeChild(_dragBitmap);
				}
			}
			_clickCell = null;
			_dragBitmap = null;
			_layer.stage.removeEventListener(MouseEvent.MOUSE_MOVE,onMove);
			_layer.stage.removeEventListener(MouseEvent.MOUSE_UP,onUp);
		}
		
		private function sendData(key1:int = -1,key2:int = -1):void
		{
			ActionBarDataManager.instance.sendExchangeSkillData(key1,key2);
		}
	}
}