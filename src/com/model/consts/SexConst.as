package com.model.consts
{
	public class SexConst
	{
		public static const TYPE_MALE:int = 1;
		public static const TYPE_FEMALE:int = 2;
		public static const TYPE_NO:int = 0;
		
		public static function sexName(sex:int):String
		{
			var sexName:String = "";
			switch(sex)
			{
				case TYPE_MALE:
					sexName = StringConst.SEX_BOY;
					break;
				case TYPE_FEMALE:
					sexName = StringConst.SEX_GIRL;
					break;
				default:
					break;
			}
			return sexName;
		}
			
		public function SexConst()
		{
			
		}
	}
}