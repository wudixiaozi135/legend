package com.view.gameWindow.panel.panels.dragonTreasure.data
{
	/**
	 * Created by Administrator on 2014/12/2.
	 * 服务端下发寻宝仓库信息
	 */
	public class StorageDataInfo
	{
		public var slot:int;//物品位置 从0开始
		public var id:int;//物品id
		public var born_sid:int;//物品born_sid
		public var type:int;//物品类型：1.物品2.装备
		public var count:int;//物品个数
		public var bind:int;//物品是否绑定
		public var extra:int;//物品额外属性

		public function StorageDataInfo()
		{
		}
	}
}
