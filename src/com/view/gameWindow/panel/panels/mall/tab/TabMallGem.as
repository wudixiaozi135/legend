package com.view.gameWindow.panel.panels.mall.tab
{
    import com.model.configData.cfgdata.GameShopCfgData;
    import com.view.gameWindow.panel.panels.mall.MallDataManager;
    import com.view.gameWindow.panel.panels.mall.constant.ShopShelfType;
    import com.view.gameWindow.panel.panels.mall.mallItem.MallItem;
    import com.view.gameWindow.util.ObjectUtils;

    import flash.display.Sprite;
    import flash.utils.Dictionary;

    /**
	 * Created by Administrator on 2014/11/19.
	 */
	public class TabMallGem extends MallTabBase
	{
		public function TabMallGem()
		{
			_container = new Sprite();
			addChild(_container);
			_mallItems = new Dictionary(true);
			super();
		}

		private var _mallItems:Dictionary;
		private var _container:Sprite;
		private var _dataItems:Vector.<GameShopCfgData>;

		override protected function initData():void
		{
			_dataItems = _dataItems || MallDataManager.instance.getVecCfgByShelf(ShopShelfType.TYPE_GEM);
		}

		override public function refresh():void
		{
			if (_dataItems == null) return;
            MallDataManager.totalPage = ObjectUtils.getTotalPage(_dataItems.length);
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

		override public function destroy():void
		{
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
                if (contains(_container))
                {
                    removeChild(_container);
                }
				ObjectUtils.clearAllChild(_container);
				_container = null;
			}
			super.destroy();
		}

	}
}
