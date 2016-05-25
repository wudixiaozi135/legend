package com.view.gameWindow.panel.panels.hejiSkill.replace
{
	import com.view.gameWindow.panel.panels.bag.BagData;
	import com.view.gameWindow.panel.panels.bag.BagDataManager;
	import com.view.gameWindow.panel.panels.hejiSkill.HejiSkillDataManager;
	import com.view.gameWindow.util.scrollBar.ScrollContent;
	
	public class ReplaceBag extends ScrollContent
	{
		private const scrollRectH:int=184;
		public function ReplaceBag()
		{
			super();
			initBag();
		}
		
		private function initBag():void
		{
			for(var i:int=0;i<64;i++)
			{
				var cell:ReplaceBagCell=new ReplaceBagCell();
				additem(cell);
				cell.x = 46*(i%5);
				cell.y = 46*int(i/5);
			}
		}
		
		public function updateBag():void
		{
			var starId:int=0;
			var ID1:int=HejiSkillDataManager.instance.cellID1;
			var ID2:int=HejiSkillDataManager.instance.cellID2;
			for (var i:int=0;i<items.length;i++)
			{
				var cell:ReplaceBagCell=items[i] as ReplaceBagCell;
				cell.iconCell.setNull();

				for(var id:int=161+starId;id<=200;id++)//道具的id 161 到200为符文的类型
				{
					starId++;
					var bag:BagData= BagDataManager.instance.getBagCellDataById(id);
					if(bag==null)continue;
					var num:int=BagDataManager.instance.getItemNumById(id);
					if(ID1!=0)
					{
						if(ID1==id)
						{
							num-=1;
						}else
						{
							continue;
						}
					}
					if(ID2!=0&&id==ID2)
					{
						num-=1;
					}
					if(num<=0)continue;
					if(num>99)
					{
						var count:int=Math.ceil(num/99);
						while(count>0)
						{
							var newN:int=count==1?num%99:99;
							(items[i] as ReplaceBagCell).setItem(id,newN);
							i++;
							count--;
						}
						i--;
					}else
					{
						(items[i] as ReplaceBagCell).setItem(id,num);
					}
					break;
				}
			}
		}
		
		override public function get scrollRectHeight():int
		{
			return scrollRectH;
		}
	}
}