import Foundation
struct List : Codable {
	let id : Int?
	let name : String?
	let coord : Coord?
	let main : Main?
	let dt : Int?
	let wind : Wind?
	let sys : Sys?
	let rain : [String: Double]?
    let snow : [String: Double]?
	let clouds : Clouds?
	let weather : [Weather]?
    let visibility: Int?
    
    lazy var date: Date? = {
        guard let interval = dt else { return nil }
        return Date.convertTimeIntervalToDate(TimeInterval(interval))
    }()

	enum CodingKeys: String, CodingKey {

		case id = "id"
		case name = "name"
		case coord = "coord"
		case main = "main"
		case dt = "dt"
		case wind = "wind"
		case sys = "sys"
		case rain = "rain"
		case snow = "snow"
		case clouds = "clouds"
		case weather = "weather"
        case visibility
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		id = try values.decodeIfPresent(Int.self, forKey: .id)
		name = try values.decodeIfPresent(String.self, forKey: .name)
		coord = try values.decodeIfPresent(Coord.self, forKey: .coord)
		main = try values.decodeIfPresent(Main.self, forKey: .main)
		dt = try values.decodeIfPresent(Int.self, forKey: .dt)
		wind = try values.decodeIfPresent(Wind.self, forKey: .wind)
		sys = try values.decodeIfPresent(Sys.self, forKey: .sys)
		rain = try values.decodeIfPresent([String: Double].self, forKey: .rain)
		snow = try values.decodeIfPresent([String: Double].self, forKey: .snow)
		clouds = try values.decodeIfPresent(Clouds.self, forKey: .clouds)
		weather = try values.decodeIfPresent([Weather].self, forKey: .weather)
        visibility = try values.decodeIfPresent(Int.self, forKey: .visibility)
	}

}
extension List {
    var visibilityString: String? {
        guard let value = visibility else { return nil }
        return "\(Int(value / 100)) MI"
    }
    var rainString: String? {
        guard let value = rain?.first?.value else { return nil }
        return "\(value) mm"
    }
    
    var snowString: String? {
        guard let value = snow?.first?.value else { return nil }
        return "\(value) mm"
    }
    var snowOrRain: (String, String) {
        if let r = rainString {
            return ("Rain", r)
        }
        if let s = snowString {
            return ("Snow", s)
        }
        return ("Rain","-")
    }
    
}
