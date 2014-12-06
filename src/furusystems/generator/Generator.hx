package furusystems.generator;
import furusystems.macro.FileUtils;
import furusystems.utils.StringUtils;

/**
 * ...
 * @author Andreas Rønning
 */
enum Job {
	sales;
	law;
	it;
	developer;
	security;
	administration;
}
enum Rank {
	intern;
	employee;
	executive;
}
enum Gender {
	male;
	female;
}
enum ObjectiveType {
	destroy;
	acquire;
	plant;
}

typedef Location = { x:Int, y:Int, z:Int };
typedef Objective = { type:ObjectiveType, document:Document, location:Location };
typedef Mission = { employer:Company, target:Company, objectives:Array<Objective>, reward:Int };

typedef Document = { filename:String, value:Int };
typedef Person = { gender:Gender, firstName:String, lastName:String, fullName:String, age:Int, rank:Rank, job:Job, password:String};
typedef Company = { name:String, buildings:Array<Building> };
typedef Building = { employees:Array<Person>, floors:Int };

class Generator
{
	private static var maleFirstNames:Array<String> = null;
	private static var femaleFirstNames:Array<String> = null;
	private static var surNames:Array<String> = null;
	private static var nouns:Array<String> = null;
	private static var qualifiers:Array<String> = null;
	public static function genName(male:Bool = true, surname:Bool = true):String {
		var out:String;
		if (male) {
			out = genMaleFirstName();
		}else {
			out = genFemaleFirstName();
		}
		if (surname) {
			out += " " + genLastName();
		}
		return out;
	}
	public static inline function genMaleFirstName():String {
		if (maleFirstNames == null) {
			maleFirstNames = FileUtils.getFileContent("assets/names/male_first.txt").split("\r");
		}
		var out = maleFirstNames[Math.floor(Math.random() * maleFirstNames.length)];
		return StringUtils.capitalize(out);
	}
	public static inline function genFemaleFirstName():String {
		if (femaleFirstNames == null) {
			femaleFirstNames = FileUtils.getFileContent("assets/names/female_first.txt").split("\r");
		}
		var out = femaleFirstNames[Math.floor(Math.random() * femaleFirstNames.length)]; 
		return StringUtils.capitalize(out);
	}
	
	public static inline function randEnum(input:Dynamic):Dynamic {
		return Type.createEnumIndex(input, Math.floor(Math.random() * Type.allEnums(input).length));
	}
	
	public static inline function genLastName():String {
		if (surNames == null) {
			surNames = FileUtils.getFileContent("assets/names/sur.txt").split("\r");
		}
		var sn = surNames[Math.floor(Math.random() * surNames.length)];
		return StringUtils.capitalize(sn);
	}
	public static function genPerson(?job:Job, ?rank:Rank):Person {
		var male = Math.random() > 0.5;
		var name:String = genName(male);
		var s = name.split(" ");
		var age = Math.floor(20 + Math.random() * 30);
		var selectedJob = job;
		if(selectedJob==null){
			selectedJob = randEnum(Job);
		}
		if (rank == null) rank = randEnum(Rank);
		if (age == 20) rank = Rank.intern;
		var gender:Gender;
		if (male) {
			gender = Gender.male;
		}else {
			gender = Gender.female;
		}
		return { firstName:s[0], lastName:s[1], gender:gender, fullName:name, age:age, rank:rank, job:selectedJob, password:genPassword(rank)};
	}
	
	public static function genPassword(rank:Rank):String {
		var out = "";
		var length = 0;
		switch(rank) {
			case intern:
			case executive:
				out = genNoun();
				length = 6;
			case employee:
				out = genNoun();
				length = 3;
		}
		for (i in 0...length) out += Math.floor(Math.random()*9);
		return out;
	}
	
	public static inline function genQualifier():String {
		if (qualifiers == null) {
			qualifiers = FileUtils.getFileContent("assets/names/companyqualifiers.txt").split("\r");
		}
		return qualifiers[Math.floor(Math.random() * qualifiers.length)];
	}
	
	public static inline function genNoun():String {
		if (nouns == null) {
			nouns = FileUtils.getFileContent("assets/names/nouns.txt").split("\r");
		}
		return nouns[Math.floor(Math.random() * nouns.length)];
	}
	
	public static function genCompanyName():String {
		var out = "";
		if (Math.random() > 0.5) {
			out += genLastName();
			if (Math.random() > 0.5) {
				out += "-" + genLastName();
			}
			if (Math.random() > 0.9) {
				out += "-" + genLastName();
			}
			out += " ";
		}else {
			out += StringUtils.capitalize(genNoun())+" ";
		}
		if(Math.random()>0.1) out += StringUtils.capitalize(genQualifier());
		return out;
	}

	public static function genBuilding(company:Company, numEmployees:Int):Building {
		var employeeList:Array<Person> = new Array<Person>();
		var floors:Int = cast Math.max(1, Math.floor(numEmployees / 25));
		var numSecurity = floors * 3;
		for (i in 0...numSecurity) 
		{
			var p = genPerson(Job.security, Rank.employee);
			employeeList.push(p);
		}
		for (i in 0...(numEmployees-numSecurity)) 
		{
			employeeList.push(genPerson());
		}
		
		var b = { employees:employeeList, floors:floors };
		return b;
	}
	
	private static function genFloorEmployees(total:Int):Array<Person> {
		return new Array<Person>();
	}
	
	public static function genCompany(singleBuilding:Bool = true):Company {
		var buildingsList = new Array<Building>();
		var company = { name:genCompanyName(), buildings:buildingsList };
		var totalEmployees:Int = cast Math.max(15, Math.random() * 300);
		if(!singleBuilding){
			var numBuildings:Int = cast Math.max(1, Math.ceil(totalEmployees / 25));
			var employeesPerBuilding = totalEmployees / numBuildings;
			for (i in 0...numBuildings) 
			{
				buildingsList[i] = genBuilding(company, Math.floor(employeesPerBuilding));
			}
		}else {
			buildingsList[0] = genBuilding(company, totalEmployees);
		}
		return company;
	}
	
	public static var palette:Array<Company> = null;
	public static function genPalette(num:Int = 30):Array<Company> {
		palette = new Array<Company>();
		for (i in 0...num) 
		{
			palette[i] = genCompany(true);
		}
		return palette;
	}
	
	public static function genMission():Mission {
		if (palette == null) genPalette();
		var a:Company = palette[Math.floor(Math.random() * palette.length)];
		var b = a;
		while(a==b){
			b = palette[Math.floor(Math.random() * palette.length)];
		}
		
		return { employer:a, target:b, objectives:[genObjective()], reward:100 };
	}
	
	static private function genObjective():Objective 
	{
		return { type:randEnum(ObjectiveType), document:genDocument() , location: { x:0, y:0, z:0 }};
	}
	
	private static var extensions:Array<String> = null;
	static private function genDocument():Document {
		if (extensions == null) {
			extensions = FileUtils.getFileContent("assets/names/extensions.txt").split("\r");
		}
		var ext = extensions[Math.floor(Math.random() * extensions.length)];
		return { filename: "file." + ext, value: cast (1 + Math.random() * 1000) };
	}
	
	
}