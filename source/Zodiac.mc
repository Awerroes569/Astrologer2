module Zodiac{

    var ARCS=   {
                "Capricorn"=>[71.0,100.0],
                "Aquarius"=>[41.0,71.0],
                "Pisces"=>[11.0,42.0],
                "Aries"=>[-18.0,12.0],
                "Taurus"=>[-50.0,-19.0],
                "Gemini"=>[-79.0,-48.0],
                "Cancer"=>[-110.0,-78.0],
                "Leo"=>[-141.0,-110.0],
                "Virgo"=>[-172.0,-141.0],
                "Libra"=>[159.0,-172.0],
                "Scorpio"=>[130.0,160.0],
                "Sagittarius"=>[100.0,129.0],
                };

	
	function whichSign(day as Number,month as Number) as String {
		
		var combined=day+month*100;
		
		if(combined<=119)
		{
			return "Capricorn";
		}
		else if(combined>=120 and combined<=218)
		{
			return "Aquarius";
		}
		else if(combined>=219 and combined<=320)
		{
			return "Pisces";
		}
		else if(combined>=321 and combined<=419)
		{
			return "Aries";
		}
		else if(combined>=420 and combined<=520)
		{
			return "Taurus";
		}
		else if(combined>=521 and combined<=620)
		{
			return "Gemini";
		}
		else if(combined>=621 and combined<=722)
		{
			return "Cancer";
		}
		else if(combined>=723 and combined<=822)
		{
			return "Leo";
		}
		else if(combined>=823 and combined<=922)
		{
			return "Virgo";
		}
		else if(combined>=923 and combined<=1022)
		{
			return "Libra";
		}
		else if(combined>=1023 and combined<=1121)
		{
			return "Scorpio";
		}
		else if(combined>=1122 and combined<=1221)
		{
			return "Sagittarius";
		}
		else
		{
			return "Capricorn";
		}
		

	}

}