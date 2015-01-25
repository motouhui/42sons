package GGM.util
{
	/**
	 * 
	 * @author SZ
	 * 
	 */
	public class GetLengthLimitString
	{
		/**
		 *对一段文字设置最大显示长度并返回整理好的字符串,中文算2个字符,英文算一个 
		 * @param str 原字符串
		 * @param maxLength 最大文字长度(超过maxLength的话后面的字将显示成"...")
		 * @param omitNum 超过maxLength的话将会使原始文字从maxLength-omitNum开始显示成"..."(中文算两个字符),
		 * 当omit<1的时候将自动变成1 
		 * @return 整理好的文字
		 * 
		 */		
		public static function getLengthLimitString(str:String,maxLength:int,omitNum:int):String
		{
			if(omitNum < 1) omitNum = 1;
			var userName:String = "";
			var strLength:int = 0;
			for(var i:int = 0 ; i < str.length ; i++)
			{
				if(str.charCodeAt(i) > 1000)
				{
					strLength += 2;
				}else
				{
					strLength += 1;
				}
				if(strLength > maxLength)
				{
					strLength = 0;
					for(i = 0 ; i < str.length ; i++)
					{
						userName = userName.concat(str.charAt(i));
						if(str.charCodeAt(i) > 1000)
						{
							strLength += 2;
						}else
						{
							strLength += 1;
						}
						if(strLength == (maxLength - omitNum))
						{
							userName += "...";
							break;
						}else if(strLength == (maxLength - omitNum + 1))
						{
							userName += "..";
							break;
						}
					}
					strLength = maxLength + 1;
					break;
				}
			}
			if(strLength < maxLength + 1)
			{
				userName = str;
			}
			return userName;
		}
		/**
		 * 对一段文字设置最大显示长度并返回整理好的html字符串,中文算2个字符,英文算一个 ,并且对每一段字加上对应的颜色
		 * @param strList 文字列表
		 * @param colorList 与文字列表相应的颜色列表
		 * @param maxLength 最大文字长度(超过maxLength的话后面的字将显示成"...")
		 * @param omitNum 超过maxLength的话将会使原始文字从maxLength-omitNum开始显示成"..."(中文算两个字符),
		 * @return 整理好的html文字
		 * 
		 */		
		public static function getLengthLimitStringWithDifferentColor(
			strList:Vector.<String>,
			colorList:Vector.<String>,
			maxLength:int,
			omitNum:int
		):String
		{
			if(strList.length != colorList.length)
			{
				throw new Error("需要变换的参数源有误");
			}
			if(omitNum < 1) omitNum = 1;
			var userName:String = "";
			var strLength:int = 0;
			var i:int = 0;
			var j:int = 0;
			for(i = 0 ; i < strList.length ; i++)
			{
				for(j = 0 ; j < strList[i].length ; j++)
				{
					if(strList[i].charCodeAt(j) > 1000)
					{
						strLength += 2;
					}else
					{
						strLength += 1;
					}
				}
				if(strLength > maxLength)
				{
					strLength = 0;
					for(i = 0 ; i < strList.length ; i++)
					{
						userName += "<font color = '#"+colorList[i]+"'>";
						for(j = 0 ; j < strList[i].length ; j++)
						{
							userName += strList[i].charAt(j);
							if(strList[i].charCodeAt(j) > 1000)
							{
								strLength += 2;
							}else
							{
								strLength += 1;
							}
							if(strLength == (maxLength - omitNum))
							{
								userName += "...</font>";
								strLength = maxLength + 1;
								break;
							}else if(strLength == (maxLength - omitNum + 1))
							{
								userName += "..</font>";
								strLength = maxLength + 1;
								break;
							}
						}
						userName += "</font>";
						if(strLength > maxLength)
							break;
					}
					break;
				}
			}
			if(strLength < maxLength + 1)
			{
				for(i = 0 ; i < strList.length ; i++)
				{
					userName += "<font color='#"+colorList[i]+"'>"+strList[i]+"</font>";
				}
			}
			return userName;
		}
	}
}