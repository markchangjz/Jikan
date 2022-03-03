import Foundation

@objc(MKCTopEntityModel)
class TopEntityModel: NSObject, Decodable {
    @objc let id: String?
    @objc let image: String?
    @objc let title: String?
    @objc let rank: Int
    @objc let startDate: String?
    @objc let endDate: String?
    @objc let type: String?
    
    enum CodingKeys: String, CodingKey  {
        case id = "mal_id"
        case image = "image_url"
        case title = "title"
        case rank = "rank"
        case startDate = "start_date"
        case endDate = "end_date"
        case type = "type"
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try? container.decode(String.self, forKey: .id)
        image = try? container.decode(String.self, forKey: .image)
        title = try? container.decode(String.self, forKey: .title)
        rank = try container.decode(Int.self, forKey: .rank)
        startDate = try? container.decode(String.self, forKey: .startDate)
        endDate = try? container.decode(String.self, forKey: .endDate)
        type = try? container.decode(String.self, forKey: .type)
    }
}

@objc(MKCTopModel)
class TopModel: NSObject, Decodable {
    @objc let entities: [TopEntityModel]?

    enum CodingKeys: String, CodingKey {
        case entities = "top"
    }
    
    @objc class func create(from responseObject: Any) -> TopModel? {
        let responseData = try? JSONSerialization.data(withJSONObject: responseObject, options: .prettyPrinted)
        if let responseData = responseData {
            let model = try? JSONDecoder().decode(TopModel.self, from: responseData)
            return model
        } else {
            return nil
        }
    }

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        entities = try? container.decode([TopEntityModel].self, forKey: .entities)
    }
}
