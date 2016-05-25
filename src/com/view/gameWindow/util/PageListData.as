package  com.view.gameWindow.util
{
	/**
	 * 分页数据  
	 * @author xiaoyu
	 * 
	 */
	public class PageListData
	{
		/** 数据 */
		private var _dataList:Array;
		/** 当前页 */
		private var _curPage:uint;
		/** 一页多少个数据 */
		private var _pageNum:uint;
		
		/**
		 * 
		 * @param pageNum 一页中有几个选项
		 */		
		public function PageListData(pageNum:uint)
		{
			_pageNum = pageNum;
		}
		
		public function get list():Array
		{
			return _dataList;
		}
		
		public function set list(dataList:Array):void
		{
			_dataList = dataList;
			updateListData();
		}
		/**
		 * 一页多少个数据
		 * @return 
		 */		
		public function get pageNum():uint
		{
			return _pageNum;
		}

		/**
		 *更新分页数据 
		 * @param list
		 * @param pageNum
		 * @return 
		 */		
		public function updateListData():void
		{
			changeList(_dataList); 
		}
		
		/** 当前页数据 */
		public function getCurrentPageData():Array
		{
			var curData:Array = new Array();
			
			var startPage:uint = _pageNum * _curPage;
			for (var i:uint = 0; i < _pageNum; i++)
			{
				if (startPage + i < _dataList.length)
				{
					curData.push(_dataList[startPage + i]);
				} 
				else
				{
					break;
				}
			}
			
			return curData;
		}
		
		/**  下一页 */
		public function next():Boolean
		{
			if (_curPage + 1 < totalPage)
			{
				_curPage++;
				return true;
			}
			return false;
		}
		
		public function hasNext():Boolean
		{
			var flag:Boolean = (_curPage + 1) < totalPage;
			return flag;
		}
		/** 上一页 */
		public function prev():Boolean
		{
			if (_curPage - 1 >= 0)
			{
				_curPage--;
				return true;
			}
			return false;
		}
		public function hasPre():Boolean
		{
			var flag:Boolean = (_curPage - 1) >= 0;
			return flag;
		}
		/** 当前页 */
		public function get curPage():uint
		{
			return _curPage + 1;
		}
		/**
		 * 切换到某页,start from 1
		 * @param page
		 * @return 
		 */		
		public function changeToPage(page:uint):Boolean
		{
			page--;
			if (page < totalPage)
			{
				_curPage = page;
				return true;
			}
			return false;
		}
		
		public function changeList(list:Array):void
		{
			if (list == null)
			{
				list = new Array();
			}
			_dataList = list;
			
			if (curPage > totalPage)
			{
				_curPage = 0;
			}
		}
		
		/** 总页数 */
		public function get totalPage():uint
		{
			var total:uint = Math.ceil(_dataList.length / _pageNum);
			total = total == 0 ? 1 : total;
			return total;
		}
		
		public function destroy():void
		{
			_dataList = null;
		}
	}
}