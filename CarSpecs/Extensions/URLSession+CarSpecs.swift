//
//  URLSession+CarSpecs.swift
//  CarSpecs
//
//  Created by Gabriel Carvalho on 24/09/23.
//

import Backend
import Foundation

typealias BackendTask = (URLRequest, (Data?, URLResponse?, Error?) -> Void) -> Void

class DataTask {
    let task: BackendTask
    let request: URLRequest
    let completionHandler: (Data?, URLResponse?, Error?) -> Void

    init(_ task: @escaping BackendTask, _ url: URL, _ completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) {
        self.task = task
        self.request = URLRequest(url: url)
        self.completionHandler = completionHandler
    }

    func resume() {
        task(request, completionHandler)
    }
}

extension URLSession {
    /// Simulate the same behavior as the original dataTask method, but uses our local database instead
    func dataTaskLocal(with url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> DataTask {
        return DataTask(API.shared.get, url, completionHandler)
    }
}
