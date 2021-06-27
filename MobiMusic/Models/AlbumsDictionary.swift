//
//  AlbumsDictionary.swift
//  MobiMusic
//
//  Created by Александр on 26.06.2021.
//

import Foundation

class AlbumsDictionary {
  var album: String
  var tracks: [Track]
  var people: String
  
  init(album: String, tracks: [Track], people: String) {
    self.album = album
    self.tracks = tracks
    self.people = people
  }
}
