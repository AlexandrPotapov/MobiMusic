//
//  NetworkDataFetcher.swift
//  MobiMusic
//
//  Created by Александр on 24.06.2021.
//

import Foundation

protocol DataFetcher {
  func getNewsResponse(page: Int, limit: Int, response: @escaping (ResponseGetNews?) -> Void)
  func getCardResponse(id: String, response: @escaping (Response?) -> Void)
}

class NetworkDataFetcher: DataFetcher {

  private let networking : NetworkingProtocol
  
  
  init(networking: NetworkingProtocol = NetworkService()) {
      self.networking = networking
  }
  
  func getNewsResponse(page: Int, limit: Int, response: @escaping (ResponseGetNews?) -> Void) {
    let params = ["method" : "product.getNews", "page" : "\(page)", "limit": "\(limit)"]
    networking.request(params: params) { (data, error) in
      if let error = error {
        print("Error received requesting data: \(error.localizedDescription)")
        response(nil)
      }
      guard let data = data else { return }
      
      let decoded = self.decodeJSON(type: ResponseGetNews.self, from: data)
      response(decoded)
    }
  }
  
  func getCardResponse(id: String, response: @escaping (Response?) -> Void) {
    let params = ["method" : "product.getCard", "productId" : id]
    networking.request(params: params) { (data, error) in
      if let error = error {
        print("Error received requesting data: \(error.localizedDescription)")
        response(nil)
      }
      guard let data = data else { return }
      
      let decoded = self.decodeJSON(type: Response.self, from: data)
      response(decoded)
    }
  }
  private func decodeJSON<T: Decodable>(type: T.Type, from: Data?) -> T? {
    let decoder = JSONDecoder()
    decoder.keyDecodingStrategy = .convertFromSnakeCase
    guard let data = from, let response = try? decoder.decode(type.self, from: data) else { return nil }
    return response
  }
  
}
