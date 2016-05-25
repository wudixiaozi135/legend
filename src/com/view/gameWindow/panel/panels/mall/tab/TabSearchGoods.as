package com.view.gameWindow.panel.panels.mall.tab
{
    import com.model.configData.cfgdata.GameShopCfgData;
    import com.view.gameWindow.panel.panels.mall.MallDataManager;
    import com.view.gameWindow.panel.panels.mall.event.MallEvent;
    import com.view.gameWindow.panel.panels.mall.mallItem.MallItem;
    import com.view.gameWindow.util.ObjectUtils;

    import flash.display.Sprite;
    import flash.utils.Dictionary;

    /**
	 * Created by Administrator on 2014/11/24.
	 */
	public class TabSearchGoods extends Sprite
	{
		public function TabSearchGoods()
		{
			MallEvent.addEventListener(MallEvent.SEARCH_GOODS, searchGoods, false, 0, true);
			_container = new Sprite();
			addChild(_container);
			_mallItems = new Dictionary(true);
		}

		private var _mallItems:Dictionary;
		private var _container:Sprite;
		private var _dataItems:Vector.<GameShopCfgData>;

		public function refresh():void
		{
			if (_dataItems == null) return;
			ObjectUtils.forEach(_mallItems, function (obj:MallItem):void
			{
				obj.visible = false;
			});
			var currentPage:int = MallDataManager.currentPage;
			for (var i:int = (currentPage - 1) * 9, len:int = _dataItems.length; i < len; i++)
			{
				if (i < currentPage * 9)
				{
					var item:MallItem;
					if (_mallItems[i])
					{
						item = _mallItems[i];
					} else
					{
						item = new MallItem();
					}
					_mallItems[i] = item;
					item.data = _dataItems[i];
					if (_container.contains(item) == false)
					{
						_container.addChild(item);
					}
					item.x = (i % 3) * item.width;
					item.y = int((i % 9) / 3) * item.height;
					item.visible = true;
				}
			}
		}

		public function destroy():void
		{
			MallEvent.removeEventListener(MallEvent.SEARCH_GOODS, searchGoods);
			if (_mallItems)
			{
				for each(var item:MallItem in _mallItems)
				{
					item.destroy();
					item = null;
				}
				_mallItems = null;
			}
			if (_dataItems)
			{
				_dataItems = null;
			}
			if (_container)
			{
                if (_container.parent)
                {
                    removeChild(_container);
                }
				ObjectUtils.clearAllChild(_container);
				_container = null;
			}
		}

		private function searchGoods(event:MallEvent):void
		{
			_dataItems = null;
			_dataItems = event._param.data;
			MallDataManager.totalPage = ObjectUtils.getTotalPage(_dataItems.length);
			refresh();
		}
	}
}
