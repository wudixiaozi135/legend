package com.core
{
	import flash.utils.Dictionary;
	
	/**
	 * @author wqhk
	 * 2014-9-19
	 */
	public function getDictElement(dic:*):*
	{
		for each(var item:Object in dic)
		{
			return item;
		}
		
		return null;
	}
}