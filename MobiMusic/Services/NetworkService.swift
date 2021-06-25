//
//  NetworkService.swift
//  MobiMusic
//
//  Created by Александр on 24.06.2021.
//

import Foundation

protocol NetworkingProtocol {
  func request(params: [String: String], completion: @escaping (Data?, Error?) -> Void)
}

class NetworkService: NetworkingProtocol {
    
  func request(params: [String : String], completion: @escaping (Data?, Error?) -> Void) {
    let allParams = params
    let url = url(with: allParams)
    let request = URLRequest(url: url)
    let task = createDataTask(from: request, completion: completion)
    print(url)
    task.resume()
  }
  
  private func url(with params: [String: String]) -> URL {
    var components = URLComponents()
    components.scheme = API.scheme
    components.host = API.host
    components.queryItems = params.map { URLQueryItem(name: $0, value: $1) }
    return components.url ?? URL(fileURLWithPath: "")
  }
  
  private func createDataTask(from request: URLRequest, completion: @escaping (Data?, Error?) -> Void) -> URLSessionDataTask {
    return URLSession.shared.dataTask(with: request) { data, response, error in
      DispatchQueue.main.async {
        completion(data, error)
      }
    }
  }
}

