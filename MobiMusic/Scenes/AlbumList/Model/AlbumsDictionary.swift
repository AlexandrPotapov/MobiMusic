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
    
    init(album: String, tracks: [Track]) {
        self.album = album
        self.tracks = tracks
    }
}
