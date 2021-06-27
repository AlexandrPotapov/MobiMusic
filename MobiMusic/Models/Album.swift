//
//  Album.swift
//  MobiMusic
//
//  Created by Александр on 24.06.2021.
//

import Foundation

struct ResponseGetNews: Decodable {
  let error: ErrorRespone
  let response: AlbumsId
}

struct AlbumsId: Decodable {
  let albums: [String]
}

struct Response: Decodable {
  let error: ErrorRespone
  let collection: Albums
}

struct ErrorRespone: Decodable {
  let code: Int
  let message: String
}

struct Albums: Decodable {
  let album: [String : Album]
  let track: [String : Track]
  let people: [String : People]
}

struct Album: Decodable {
//  let id: String
  let name: String
  let coverUrl: String?
  let trackCount: Int
}

struct Track: Decodable {
//  let id: String
  let name: String
  let coverUrl: String?
}

struct People: Decodable {
//  let id: String
  let name: String
}
