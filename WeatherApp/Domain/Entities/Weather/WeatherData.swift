import Foundation
struct WeatherData : Codable {
    var message : String?
    let cod : String?
    var count : Int?
    let list : [List]?
    let cnt : Int?
    let city : City?
    
    enum CodingKeys: String, CodingKey {
        case message = "message"
        case cod = "cod"
        case count = "count"
        case cnt = "cnt"
        case list = "list"
        case city = "city"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        cod = try values.decodeIfPresent(String.self, forKey: .cod)
        count = try values.decodeIfPresent(Int.self, forKey: .count)
        list = try values.decodeIfPresent([List].self, forKey: .list)
        cnt = try values.decodeIfPresent(Int.self, forKey: .cnt)
        city = try values.decodeIfPresent(City.self, forKey: .city)
        
        if count == nil {
            count = cnt
        }
        if let mm = try? values.decodeIfPresent(Int.self, forKey: .message) {
            message = String(mm)
            return
        }
        message = try values.decodeIfPresent(String.self, forKey: .message)
    }
    

    
    
}
