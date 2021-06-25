//
//  AlbumListPresenter.swift
//  MobiMusic
//
//  Created by Александр on 24.06.2021.
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

protocol AlbumListViewProtocol: AnyObject {
  func reloadData()
  func loadAlbumImage(withUrl imageUrl: String, name: String)
}

protocol AlbumListPresenterProtocol {
  var albums: [String: [Track]] { get }
  var tracks: [Track] { get }
  var albumsDictionary: [AlbumsDictionary] { get }
  func getAlbums()
  func getTracks(with id: String)
  func album(atSection section: Int) -> String?
  func track(atIndex indexPath: IndexPath) -> Track?
}

class AlbumListPresenter: AlbumListPresenterProtocol {
  
  weak var view: AlbumListViewProtocol?
  
  var albums = [String: [Track]]()
  var albumsDictionary = [AlbumsDictionary]()
  var albumsName = [String]()
  
  var tracks = [Track]()
  
  private var page = 1
  private var albumsId = [String]()
  private let limit = 5
  
  private let dataFetcher: DataFetcher!
  
  
  required init(view: AlbumListViewProtocol, dataFetcher: DataFetcher) {
    self.view = view
    self.dataFetcher = dataFetcher
  }
  
  func getAlbums() {
    dataFetcher.getNewsResponse(page: page, limit: limit) { [weak self] response in
      guard let response = response else { return }
      if response.error.code != 0 {
        print("Eror code: \(response.error.code). Error message: \(response.error.message)")
        return
      }
      for id in response.response.albums {
        self?.getTracks(with: id)
      }
    }
  }
  
  func getTracks(with id: String) {
      dataFetcher.getCardResponse(id: id) { [weak self] response in
        guard let response = response else { return }
        if response.error.code != 0 {
          print("Eror code: \(response.error.code). Error message: \(response.error.message)")
          return
        }
        guard let nameAlbum = response.collection.album.first?.value.name else { return }
        guard let coverUrl = response.collection.track.first?.value.coverUrl else { return }
        self?.view?.loadAlbumImage(withUrl: coverUrl, name: coverUrl)

        var tracks = [Track]()
        for (_, track) in response.collection.track {

          tracks.append(track)
        }
        self?.albumsDictionary.append(AlbumsDictionary(album: nameAlbum, tracks: tracks))
        self?.view?.reloadData()
      }
  }
  
  func album(atSection section: Int) -> String? {
    
    if albumsDictionary.indices.contains(section) {
      return albumsDictionary[section].album
    } else {
      return nil
    }
  }
  
  func track(atIndex indexPath: IndexPath) -> Track? {
      if albumsDictionary[indexPath.section].tracks.indices.contains(indexPath.row) {
        return albumsDictionary[indexPath.section].tracks[indexPath.row]
    } else {
      return nil
    }
  }
}
