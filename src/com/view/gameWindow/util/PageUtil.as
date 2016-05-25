package com.view.gameWindow.util
{
	public class PageUtil
	{

		private var totalCount:int;
		private var _currentPageIndex:int=1;
		private var everyCount:int;

		private var totalPageCount:Number;
		public function PageUtil(everyCount:int,totalCount:int=0,currentIndex:int=1)
		{
			this.everyCount = everyCount;
			this.totalCount = totalCount;
			getPageCount();
			
		}
		
		public function setTotalCount(totalCount:int):void
		{
			this.totalCount=totalCount;
		}
		
		public function getPageCount():int
		{
			totalPageCount = totalCount%everyCount==0?totalCount/everyCount:totalCount/everyCount+1;
			return totalPageCount;
		}

		public function get currentPageIndex():int
		{
			return _currentPageIndex;
		}

		public function set currentPageIndex(value:int):void
		{
			_currentPageIndex = value;
		}
		
		public function setNextPage():Boolean
		{
			if(_currentPageIndex+1>totalPageCount)
			{
				_currentPageIndex=totalPageCount;
				return false;
			}
			_currentPageIndex++;
			return true;
		}
		
		public function getPageStar():int
		{
			return (_currentPageIndex-1)*everyCount;
		}
		
		public function getPageEnd():int
		{
			 var end:Number = _currentPageIndex*everyCount;
			 if(end>totalCount)
				 end=totalCount;
			 return end;
		}
		
		public function setPrevPage():Boolean
		{
			if(_currentPageIndex-1<1)
			{
				_currentPageIndex=1;
				return false;
			}
			_currentPageIndex--;
			return true;
		}
	}
}