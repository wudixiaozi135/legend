package com.core
{
	
	/**
	 * @author wqhk
	 * 2014-9-24
	 */
	public function toArray(dict:*,output:*,filter:Function = null):void
	{
		for each(var item:* in dict)
		{
			if(filter != null)
			{
				if(!filter(item))
				{
					continue;
				}
			}
			output.push(item);
		}
	}
}