import Foundation
struct Weather : Codable {
	let id : Int?
	let main : String?
	let desc : String?
	let icon : String?

	enum CodingKeys: String, CodingKey {

		case id = "id"
		case main = "main"
		case desc = "description"
		case icon = "icon"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		id = try values.decodeIfPresent(Int.self, forKey: .id)
		main = try values.decodeIfPresent(String.self, forKey: .main)
		desc = try values.decodeIfPresent(String.self, forKey: .desc)
		icon = try values.decodeIfPresent(String.self, forKey: .icon)
	}

}
