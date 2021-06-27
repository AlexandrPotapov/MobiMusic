//
//  AlbumListPresenter.swift
//  MobiMusic
//
//  Created by Александр on 24.06.2021.
//

import Foundation

protocol AlbumListPresenterProtocol: AnyObject {
  var albums: [String: [Track]] { get }
  var tracks: [Track] { get }
  var albumsDictionary: [AlbumsDictionary] { get }
  var covers: [CoverRecord] { get set }
  var router: AlbumListRouterProtocol { get }
  
  func getAlbums()
  func getTracks(with id: String)
  func album(atSection section: Int) -> String?
  func track(atIndex indexPath: IndexPath) -> Track?
  func loadNextAlbums()
  func reloadRows(at indexPath: IndexPath)
  func didSelect(at indexPath: IndexPath)

  
  func suspendAllOperations()
  func resumeAllOperations()
  func loadImagesForOnscreenCells(pathsArray: [IndexPath]?)
  func startOperations(for photoRecord: CoverRecord, at indexPath: IndexPath)
  func startDownload(for photoRecord: CoverRecord, at indexPath: IndexPath)
}

class AlbumListPresenter: AlbumListPresenterProtocol {
  
  var covers = [CoverRecord]()
  
  
  weak var view: AlbumListViewProtocol?
  let router: AlbumListRouterProtocol

  
  var albums = [String: [Track]]()
  var albumsDictionary = [AlbumsDictionary]()
  var albumsName = [String]()
  var tracks = [Track]()
  
  var imageProvider: ImageProvaiderProtocol!
  
  private var page = 1
  private var albumsId = [String]()
  private let limit = 5
  
  private let dataFetcher: DataFetcher!
  
  
  required init(view: AlbumListViewProtocol, router: AlbumListRouterProtocol, dataFetcher: DataFetcher) {
    self.view = view
    self.dataFetcher = dataFetcher
    self.router = router
  }
  
  private func addPhotoRecord(coverUrl: String) {
    let url = URL(string: coverUrl)
    if let url = url {
      let photoRecord = CoverRecord(name: coverUrl, url: url)
      imageProvider.covers.append(photoRecord)
      covers = imageProvider.covers
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
      guard let peopleName = response.collection.people.first?.value.name else { return }
      
      self?.addPhotoRecord(coverUrl: coverUrl)
      
      var tracks = [Track]()
      for (_, track) in response.collection.track {
        tracks.append(track)
      }
      self?.albumsDictionary.append(AlbumsDictionary(album: nameAlbum, tracks: tracks, people: peopleName))
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
  
  func didSelect(at indexPath: IndexPath) {
    
    let track = albumsDictionary[indexPath.section].tracks[indexPath.row]
    let people = albumsDictionary[indexPath.section].people
    guard let cover = covers[indexPath.section].image else { return }
    var audioPath: String!
    if indexPath.row.isMultiple(of: 2) {
      audioPath = "A Kiss MS-B"
    } else {
      audioPath = "A Kiss MS-A"
    }
    let audioFile = URL(fileURLWithPath: Bundle.main.path(forResource: audioPath, ofType: "mp3")! )
    router.openTrackCardViewController(with: TrackCardViewModel(trackName: track.name, singer: people, coverImage: cover, filePath: audioFile))
  }
  
  // MARK: - operation management
  
  func startOperations(for photoDetails: CoverRecord, at indexPath: IndexPath) {
    imageProvider.startOperations(for: photoDetails, at: indexPath)
  }
  
  func resumeAllOperations() {
    imageProvider.resumeAllOperations()
  }
  
  func loadImagesForOnscreenCells(pathsArray: [IndexPath]?) {
    imageProvider.loadImagesForOnscreenCells(pathsArray: pathsArray)
  }
  
  func startDownload(for photoRecord: CoverRecord, at indexPath: IndexPath) {
    imageProvider.startDownload(for: photoRecord, at: indexPath)
  }
  
  func suspendAllOperations() {
    imageProvider.suspendAllOperations()
  }
}
