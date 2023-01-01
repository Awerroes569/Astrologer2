import Toybox.Time.Gregorian;
import Toybox.Time;
import Toybox.System;
import Toybox.Math;


module Planets{

	var planets=
    {	"Mercury" => { "initialLongtitude"=>250.2f, "dayAngle"=>4.09235f,"perihelionLongtitude"=>77.5,"e"=>0.2056f,"order"=>1,"arch"=>15,"title"=>[Rez.Drawables.mercuriusU,Rez.Drawables.mercuriusD],"whereTitle"=>[[-52,-56],[-51,13]]},
    	"Venus" => { "initialLongtitude"=>181.2, "dayAngle"=>1.60213,"perihelionLongtitude"=>131.6,"e"=>0.0068,"order"=>2,"arch"=>47,"title"=>[Rez.Drawables.venusU,Rez.Drawables.venusD],"whereTitle"=>[[-36,-55],[-33,32]]},
    	"Earth" => { "initialLongtitude"=>100.0, "dayAngle"=>0.98561,"perihelionLongtitude"=>102.9,"e"=>0.0167,"order"=>3,"arch"=>47,"title"=>[Rez.Drawables.terraU,Rez.Drawables.terraD],"whereTitle"=>[[-36,-55],[-33,33]]},//[-52,-56],[-102,34] arch 47
    	"Mars" => { "initialLongtitude"=>355.2, "dayAngle"=>0.52403,"perihelionLongtitude"=>336.1,"e"=>0.0934,"order"=>4,"arch"=>71,"title"=>[Rez.Drawables.marsU,Rez.Drawables.marsD],"whereTitle"=>[[-28,-100],[-27,86]]}, ///   -28,100 best down -27,86
    	"Jupiter" => { "initialLongtitude"=>34.3, "dayAngle"=>0.08309,"perihelionLongtitude"=>14.3,"e"=>0.0485,"order"=>5,"arch"=>60,"title"=>[Rez.Drawables.iuppiterU,Rez.Drawables.iuppiterD],"whereTitle"=>[[-47,-100],[-47,79]]}, // down-47,79
    	"Saturn" => { "initialLongtitude"=>50.1, "dayAngle"=>0.03346,"perihelionLongtitude"=>93.1,"e"=>0.0555,"order"=>6,"arch"=>55,"title"=>[Rez.Drawables.saturnusU,Rez.Drawables.saturnusD],"whereTitle"=>[[-52,-100],[-53,76]]}, // down-47,79	
		"Earth2" => { "initialLongtitude"=>100.0, "dayAngle"=>0.98561,"perihelionLongtitude"=>102.9,"e"=>0.0167,"order"=>3,"arch"=>67,"title"=>[Rez.Drawables.terraU2,Rez.Drawables.terraD2],"whereTitle"=>[[-33,-100],[-32,84]]}//[-52,-56],[-102,34] arch 47	
	};

	var PUPI=[

		[1,2,3],
		[4,5,6]

	];
	
	var START_MOMENT = Gregorian.moment({
		:year => 2000,
		:month => 1,
		:day => 1,
		:hour =>0,
		:minute => 0,
		:second => 0
		});
		
	var DAY_IN_SECONDS=86400;
	
	function daysFromStart()
	{
		var current=Time.now();
		var days=current.subtract(START_MOMENT);

		return 1.0f*days.value()/DAY_IN_SECONDS;
	}

	function daysFromStartOnMoment(moment)
	{
		var current=moment;
		var days=current.subtract(START_MOMENT);

		return 1.0f*days.value()/DAY_IN_SECONDS;
	}
	
	function xyPlanet(centerX,centerY,angle,radius)
	{
		return [centerX+radius*Math.cos(Math.toRadians(angle)),centerY+radius*Math.sin(Math.toRadians(angle))]; 
	}
	
	function daysFromStart2()
	{
		var currentMidnight=Time.today().value();
		var beginning=START_MOMENT.value();
		var days=currentMidnight-beginning;

		return 1.0f*days/DAY_IN_SECONDS;
	}
	
	function currentAngle(angle as Float)
	{		
		var floor=Math.floor(angle);
		var belowFloor=angle-floor;
		var newFloor=floor.toLong()%360;

		return 1.0f*newFloor+belowFloor;
	}
	
	function convertToPlus(angle as Float)
	{
		if(angle<0)
		{
			return 360.0+angle;
		}
		
		return angle;
	}
	
	function convertToMidnight(angle as Float)
	{
		if(angle<100)
		{
			return angle+260;
		}
		
		return angle-100;
	}
	
	function currentPosition(planet as String)
	{
		//LOADING PLANET
		var currentPlanet=Planets.planets.get(planet);
		//LOADING VARIABLES
		var initialLongtitude=currentPlanet.get("initialLongtitude");
		var dayAngle=currentPlanet.get("dayAngle");
		var perihelionLongtitude=currentPlanet.get("perihelionLongtitude");
		var e=currentPlanet.get("e");
		//LETS CALCULATE
		var totalAngle=daysFromStart()*dayAngle+initialLongtitude;
		var totalAngleNormalized=currentAngle(totalAngle);
		var meanAnomaly=convertToPlus(totalAngleNormalized-perihelionLongtitude);
		//STOPNIE(2*W5*SIN(RADIANY(V5)))
		var firstCorrection=Math.toDegrees(2*e*Math.sin(Math.toRadians(meanAnomaly)));
		//STOPNIE(1,25*(W5^2)*SIN(RADIANY(2*V5)))
		var secondCorrection= Math.toDegrees(1.25*e*e*Math.sin(Math.toRadians(2*meanAnomaly)));
		var totalCorrection=firstCorrection+secondCorrection;
		var precession=1.0f*daysFromStart()/25800;
		var afterCorrections=totalAngleNormalized+totalCorrection+precession;
		
		return convertToMidnight(afterCorrections);
		
	}

	function currentPositionForMoment(planet as String,moment)
	{
		//LOADING PLANET
		var currentPlanet=Planets.planets.get(planet);
		//LOADING VARIABLES
		var initialLongtitude=currentPlanet.get("initialLongtitude");
		var dayAngle=currentPlanet.get("dayAngle");
		var perihelionLongtitude=currentPlanet.get("perihelionLongtitude");
		var e=currentPlanet.get("e");
		//LETS CALCULATE
		var totalAngle=daysFromStartOnMoment(moment)*dayAngle+initialLongtitude;
		var totalAngleNormalized=currentAngle(totalAngle);
		var meanAnomaly=convertToPlus(totalAngleNormalized-perihelionLongtitude);
		//STOPNIE(2*W5*SIN(RADIANY(V5)))
		var firstCorrection=Math.toDegrees(2*e*Math.sin(Math.toRadians(meanAnomaly)));
		//STOPNIE(1,25*(W5^2)*SIN(RADIANY(2*V5)))
		var secondCorrection= Math.toDegrees(1.25*e*e*Math.sin(Math.toRadians(2*meanAnomaly)));
		var totalCorrection=firstCorrection+secondCorrection;
		var precession=1.0f*daysFromStart()/25800;
		var afterCorrections=totalAngleNormalized+totalCorrection+precession;
		
		return convertToMidnight(afterCorrections);
		
	}

}