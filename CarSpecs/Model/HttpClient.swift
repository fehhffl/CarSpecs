//
//  HttpClient.swift
//  CarSpecs
//
//  Created by Gabriel Carvalho on 24/09/23.
//

import Backend
import Foundation

class HttpClient {
    private let baseUrl = "https://www.cars-data.com/"

    func get<T>(path: String, rootKey: String, completion: ([T]) -> Void) {

        guard let url = URL(string: baseUrl + path) else {
            print("Invalid URL")
            completion([])
            return
        }

        API.shared.get(request: URLRequest(url: url)) { data, response, error in
            if let data = data {
                do {
                    let dict = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
                    if let result = dict?[rootKey] as? [T] {
                        completion(result)
                    } else {
                        print("Wrong rootKey: \(rootKey):\n \(dict ?? [:])")
                        completion([])
                        return
                    }
                } catch {
                    print(error.localizedDescription)
                    completion([])
                    return
                }
            } else {
                if let data = data {
                    print(data)
                }
                if let response = response {
                    print(response)
                }
                if let error = error {
                    print(error)
                }
                completion([])
                return
            }
        }
    }
}
