import Foundation
struct Main : Codable {
    let temp : Double?
    let feels_like : Double?
    let temp_min : Double?
    let temp_max : Double?
    let pressure : Int?
    let humidity : Int?
    
    enum CodingKeys: String, CodingKey {
        
        case temp = "temp"
        case feels_like = "feels_like"
        case temp_min = "temp_min"
        case temp_max = "temp_max"
        case pressure = "pressure"
        case humidity = "humidity"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        temp = try values.decodeIfPresent(Double.self, forKey: .temp)
        feels_like = try values.decodeIfPresent(Double.self, forKey: .feels_like)
        temp_min = try values.decodeIfPresent(Double.self, forKey: .temp_min)
        temp_max = try values.decodeIfPresent(Double.self, forKey: .temp_max)
        pressure = try values.decodeIfPresent(Int.self, forKey: .pressure)
        humidity = try values.decodeIfPresent(Int.self, forKey: .humidity)
    }
    
}

extension Main {
    var tempString: String? {
        guard let value = temp else { return nil }
        return "\(value)º"
    }
    var minTempString: String? {
        guard let value = temp_min else { return nil }
        return "\(value)º"
    }
    var maxTempString: String? {
        guard let value = temp_max else { return nil }
        return "\(value)º"
    }
    var feelsLikeString: String? {
        guard let value = feels_like else { return nil }
        return "\(value)º"
    }
    var humidityString: String? {
        guard let value = humidity else { return nil }
        return "\(value)%"
    }
}
