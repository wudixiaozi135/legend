package com.view.gameWindow.util
{
	import com.model.consts.StringConst;

	/**
	 * 数字转换类
	 * @author Administrator
	 */	
	public class UtilNumChange
	{
		public function UtilNumChange()
		{
		}
		
		/**
		 * 转成xxxx万，x.x万格式
		 * @param num
		 * @return 
		 */		
		public function changeNum(num:Number):String
		{
			var number:Number,number2:Number;
			number = num/100000000;
			if(number >= 1)//亿位存在
			{
				if(number > 9)//2位数
				{
					return number.toFixed(0)+StringConst.NUM_0100;
				}
				else
				{
					number2 = (num%100000000)/10000000;
					if(number2 >= 1)//小数点后一位不为0
					{
						return number.toFixed(1)+StringConst.NUM_0100;
					}
					else
					{
						return number.toFixed(0)+StringConst.NUM_0100;
					}
				}
			}
			number = num/10000;
			if(number >=  1)//万位存在
			{
				if(number > 9)//2位数
				{
					return number.toFixed(0)+StringConst.NUM_0102;
				}
				else
				{
					number2 = (num%10000)/1000;
					if(number2 >= 2)//有小数
					{
						return number.toFixed(1)+StringConst.NUM_0102;
					}
					else
					{
						return number.toFixed(0)+StringConst.NUM_0102;
					}
				}
			}
			return num+"";
		}
		
		/**
		 * 货币格式数字 
		 * @param num
		 * @return 
		 */		
		public function formatMoney(num:Number):String
		{
			var str:String = num.toString();
			
			var reg:RegExp=/\.\d+/;
			var xiaosu:String=reg.exec(str);
			if(xiaosu == null)
			   xiaosu = "";
		
			str=uint(num).toString();
			
			reg=/(\d{3})+\b/g;
			var arr:Array = str.match(reg)
			
			var eachStr:String = "";
			if(arr.length > 0)
			{
				eachStr=arr[0];
				reg=/\d{3}/g;
				arr=eachStr.match(reg);
				str = str.replace(eachStr,"");
				str = (str.length < 1)? "" : str+",";
				eachStr=arr.join(",");
			}
			
			var strResult:String = str +arr+ xiaosu;
			return strResult
		}
	}
}