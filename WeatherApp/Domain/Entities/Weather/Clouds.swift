import Foundation
struct Clouds : Codable {
	let all : Int?

	enum CodingKeys: String, CodingKey {

		case all = "all"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		all = try values.decodeIfPresent(Int.self, forKey: .all)
	}

}
extension Clouds {
    var cloudCoverString: String? {
        guard let value = all else { return nil }
        return "\(value)%"
    }
}
