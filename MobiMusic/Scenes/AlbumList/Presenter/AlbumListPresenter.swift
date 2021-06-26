//
//  AlbumListPresenter.swift
//  MobiMusic
//
//  Created by Александр on 24.06.2021.
//

import Foundation

class AlbumListPresenter: AlbumListPresenterProtocol {
  
  var photos = [PhotoRecord]()
  
  
  weak var view: AlbumListViewProtocol?
  
  var albums = [String: [Track]]()
  var albumsDictionary = [AlbumsDictionary]()
  var albumsName = [String]()
  var tracks = [Track]()
  
  var imageProvider: ImageProvaiderProtocol!

  private var page = 1
  private var albumsId = [String]()
  private let limit = 5
  
  private let dataFetcher: DataFetcher!
  
  
  required init(view: AlbumListViewProtocol, dataFetcher: DataFetcher) {
    self.view = view
    self.dataFetcher = dataFetcher
  }
  
  private func addPhotoRecord(coverUrl: String) {
    let url = URL(string: coverUrl)
    if let url = url {
      let photoRecord = PhotoRecord(name: coverUrl, url: url)
      imageProvider.photos.append(photoRecord)
      photos = imageProvider.photos
    }
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
        
        self?.addPhotoRecord(coverUrl: coverUrl)

        var tracks = [Track]()
        for (_, track) in response.collection.track {
          tracks.append(track)
        }
        self?.albumsDictionary.append(AlbumsDictionary(album: nameAlbum, tracks: tracks))
        self?.view?.hideSpinners()
        self?.view?.reloadData()
      }
  }
  
  func loadNextAlbums() {
    page += 1
    getAlbums()
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
  
  func reloadRows(at indexPath: IndexPath) {
    view?.reloadRows(at: indexPath)
  }
  
  // MARK: - operation management
  
  func startOperations(for photoDetails: PhotoRecord, at indexPath: IndexPath) {
    imageProvider.startOperations(for: photoDetails, at: indexPath)
  }
  
  func resumeAllOperations() {
    imageProvider.resumeAllOperations()
  }
  
  func loadImagesForOnscreenCells(pathsArray: [IndexPath]?) {
    imageProvider.loadImagesForOnscreenCells(pathsArray: pathsArray)
  }
  
  func startDownload(for photoRecord: PhotoRecord, at indexPath: IndexPath) {
    imageProvider.startDownload(for: photoRecord, at: indexPath)
  }
  
  func suspendAllOperations() {
    imageProvider.suspendAllOperations()
  }
}
