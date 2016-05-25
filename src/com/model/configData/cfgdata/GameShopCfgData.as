package com.model.configData.cfgdata
{
/**
 * Created by Administrator on 2014/11/19.
 */
public class GameShopCfgData
{
    public function GameShopCfgData()
    {
    }

    public var id:int;
    public var shelf:int;
    public var item_id:int;
    public var item_type:int;
    public var is_bind:int;
    public var cost_type:int;
    public var original_cost:int;
    public var cost_value:int;
    public var preferential_price:int;
    public var is_limit:int;
    public var limit_num:int;
    public var order:int;
	public var is_give:int;
	public var hight_light:Boolean = false;//写这里最方便
}
}
