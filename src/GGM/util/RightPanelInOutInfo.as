package GGM.util
{
	
	/**
	 * 移动的二次函数算法类
	 * @author LionelZhang
	 * 
	 */
	public class RightPanelInOutInfo
	{
		///////////////////////////////////////////////////
		// Static Variable
		///////////////////////////////////////////////////
		/**
		 * 操作面板的时间 
		 */		
		public static const CLOSE_PANEL_TIME:Number = 300;
		/**
		 *礼物面板的时间 
		 */		
		public static const CLOSE_PANEL_TIME_BY_GIFT:Number = 150;
		/**
		 * 参数a 
		 */		
		private static var argA:Number;
		
		///////////////////////////////////////////////////
		// Constructor
		///////////////////////////////////////////////////
		/**
		 * 算出参数a 
		 * @param argT 总时间
		 * @param argS 总距离
		 * 
		 */		
		public function RightPanelInOutInfo(argT:Number,argS:Number)
		{
			argA = argS / (argT * argT);
		}
		
		/**
		 * 计算距离 
		 * @param t
		 * @return 
		 * 
		 */		
		public static function calcuDis(t:Number):Number
		{
			return (t * t * argA);
		}
	}
}