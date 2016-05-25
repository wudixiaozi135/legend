package com.view.gameWindow.panel.panels.guideSystem.action
{
	import com.view.gameWindow.scene.movie.MovieManager;
	
	/**
	 * @author wqhk
	 * 2014-12-8
	 */
	public class PlayMovieAction extends GuideAction
	{
		private var _movieId:int;
		public function PlayMovieAction(movieId:int)
		{
			_movieId = movieId;
			super();
		}
		
		override public function act():void
		{
			super.act();
			
			if(_movieId > 0)
			{
				MovieManager.instance.startMovie(_movieId);
			}
			else
			{
				_isComplete = true;
			}
		}
		
		override public function check():void
		{
			var isOver:Boolean = MovieManager.instance.isOver(_movieId);
			
			_isComplete = isOver;
		}
	}
}