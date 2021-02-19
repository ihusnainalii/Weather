import Foundation
struct Sys : Codable {
	let country : String?

	enum CodingKeys: String, CodingKey {

		case country = "country"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		country = try values.decodeIfPresent(String.self, forKey: .country)
	}

}
