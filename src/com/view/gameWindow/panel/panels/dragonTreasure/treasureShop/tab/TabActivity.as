package com.view.gameWindow.panel.panels.dragonTreasure.treasureShop.tab
{
    import com.model.business.gameService.constants.GameServiceConstants;
    import com.model.configData.cfgdata.TreasureShopCfgData;
    import com.view.gameWindow.panel.panels.dragonTreasure.constant.TreasureShopType;
    import com.view.gameWindow.panel.panels.dragonTreasure.treasureShop.TreasureShopManager;
    import com.view.gameWindow.panel.panels.mall.tab.*;
    import com.view.gameWindow.util.ObjectUtils;

    import flash.display.Sprite;
    import flash.utils.Dictionary;

    /**
	 * Created by Administrator on 2014/11/19.
	 * 寻宝商店 普通选项
	 */
	public class TabActivity extends MallTabBase
	{
		private var _treasureShopItems:Dictionary;
		private var _container:Sprite;
		private var _dataItems:Vector.<TreasureShopCfgData>;

		public function TabActivity()
		{
			addChild(_container = new Sprite());
            _container.mouseEnabled = false;
			_treasureShopItems = new Dictionary(true);
			TreasureShopManager.instance.attach(this);
			super();
		}

		override protected function initData():void
		{
			_dataItems = _dataItems || TreasureShopManager.instance.getVecCfgByShelf(TreasureShopType.SHELF_ACTIVITY);
			TreasureShopManager.totalPage = ObjectUtils.getTotalPage(_dataItems.length);
		}

		override public function refresh():void
		{
			if (_dataItems == null) return;
			ObjectUtils.forEach(_treasureShopItems, function (obj:TreasureShopItem):void
			{
				obj.visible = false;
			});

			var currentPage:int = TreasureShopManager.currentPage;
			for (var i:int = (currentPage - 1) * 9, len:int = _dataItems.length; i < len; i++)
			{
				if (i < currentPage * 9)
				{
					var item:TreasureShopItem;
					if (_treasureShopItems[i])
					{
						item = _treasureShopItems[i];
					} else
					{
						item = new TreasureShopItem();
					}
					item.data = _dataItems[i];

					_treasureShopItems[i] = item;
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

		override public function update(proc:int = 0):void
		{
			switch (proc)
			{
				case GameServiceConstants.SM_GET_FIND_TREASURE_LIMIT_NUM:
					refresh();
					break;
				default :
					break;
			}
		}

		override public function destroy():void
		{
			TreasureShopManager.instance.detach(this);
			if (_treasureShopItems)
			{
				for each(var item:TreasureShopItem in _treasureShopItems)
				{
					item.destroy();
					item = null;
				}
				_treasureShopItems = null;
			}
			if (_dataItems)
			{
				_dataItems = null;
			}
			if (_container)
			{
				ObjectUtils.clearAllChild(_container);
				_container = null;
			}
			super.destroy();
		}
	}
}
