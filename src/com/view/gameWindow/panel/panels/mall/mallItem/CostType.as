package com.view.gameWindow.panel.panels.mall.mallItem
{
	import com.model.business.fileService.constants.ResourcePathConstants;
	import com.model.consts.StringConst;
	import com.model.consts.ToolTipConst;
	import com.view.gameWindow.common.ResManager;
	import com.view.gameWindow.panel.panels.mall.constant.ResIconType;
	import com.view.gameWindow.tips.toolTip.ToolTipManager;
	import com.view.gameWindow.util.HtmlUtils;

	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.Event;

	/**
	 * Created by Administrator on 2014/11/23.
	 * 加载一个图片资源
	 */
	public class CostType extends Sprite
	{
		public function CostType(type:int)
		{
			_costType = type;
			addChild(_container = new Sprite());
			addEventListener(Event.REMOVED_FROM_STAGE, onRemove, false, 0, true);
			init();
		}

		private var _container:Sprite;
		private var _costType:int;

		public function destroy():void
		{
			if (_container)
			{
				while (_container.numChildren > 0)
				{
					_container.removeChildAt(0);
				}
				if (_container.parent)
				{
					_container.parent.removeChild(_container);
					_container = null;
				}
			}
		}

		private function init():void
		{
			var url:String;
			switch (_costType)
			{
				default :
					break;
				case ResIconType.TYPE_GOLD:
					url = ResourcePathConstants.IMAGE_PANEL_FOLDER_LOAD + "bagPanel/gold.png";
					break;
				case ResIconType.TYPE_TICKET:
					url = ResourcePathConstants.IMAGE_PANEL_FOLDER_LOAD + "bagPanel/boundGold.png";
					break;
				case ResIconType.TYPE_SCORE:
					url = ResourcePathConstants.IMAGE_PANEL_FOLDER_LOAD + "shop/icon.png";
					break;
				case ResIconType.TYPE_LIMIT:
					url = ResourcePathConstants.IMAGE_PANEL_FOLDER_LOAD + "shop/xiangou.png";
					break;
				case ResIconType.TYPE_MONEY:
					url = ResourcePathConstants.IMAGE_PANEL_FOLDER_LOAD + "bagPanel/money.png";
					break;
			}
			if (url)
			{
				ResManager.getInstance().loadBitmap(url, callBack);
			}
		}

		private function callBack(bmd:BitmapData,url:String):void
		{
			if (_container)
			{
				_container.addChild(new Bitmap(bmd));
                ToolTipManager.getInstance().attachByTipVO(this, ToolTipConst.TEXT_TIP, getCostLabel());
			}
		}

        private function getCostLabel():String
        {
            var costLabel:String = "";
            switch (_costType)
            {
                default :
                    break;
                case ResIconType.TYPE_GOLD:
                    costLabel = HtmlUtils.createHtmlStr(0xffcc00, StringConst.MALL_COST_TYPE_1);
                    break;
                case ResIconType.TYPE_TICKET:
                    costLabel = HtmlUtils.createHtmlStr(0xffcc00, StringConst.MALL_COST_TYPE_2);
                    break;
                case ResIconType.TYPE_SCORE:
                    costLabel = HtmlUtils.createHtmlStr(0xffcc00, StringConst.MALL_COST_TYPE_3);
                    break;
                case ResIconType.TYPE_LIMIT:
					costLabel = "";
                    break;
                case ResIconType.TYPE_MONEY:
					costLabel = HtmlUtils.createHtmlStr(0xffcc00, StringConst.MALL_COST_TYPE_4);
                    break;
            }
            return costLabel;
        }
		private function onRemove(event:Event):void
		{
			removeEventListener(Event.REMOVED_FROM_STAGE, onRemove);
            ToolTipManager.getInstance().detach(this);
			destroy();
		}
	}
}
