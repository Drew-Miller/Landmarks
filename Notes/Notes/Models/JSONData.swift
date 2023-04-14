//
//  JSON.swift
//  Notes
//
//  Created by Drew Miller on 4/14/23.
//

import Foundation

struct JSONData {
    static func decode<T: Decodable>(data: Data?, class to: T.Type) -> T? {
        if let data = data,
           let obj = try? JSONDecoder().decode(T.self, from: data) {
            return obj
        }
        return nil
    }
    
    static func decodeArray<T: Decodable>(data: Data?, class to: T.Type) -> [T] {
        if let data = data,
           let obj = try? JSONDecoder().decode([T].self, from: data) {
            return obj
        }
        return []
    }
    
    static func encode<T: Codable>(encode: T, completion: (_: Data?) -> Void) {
        if let encoded = try? JSONEncoder().encode(encode) {
            return completion(encoded)
        }
        completion(nil)
    }
}
