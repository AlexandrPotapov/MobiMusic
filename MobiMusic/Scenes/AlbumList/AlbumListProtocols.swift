//
//  AlbumListProtocols.swift
//  MobiMusic
//
//  Created by Александр on 26.06.2021.
//

import Foundation

protocol AlbumListViewProtocol: AnyObject {
  func reloadData()
  func hideSpinners()
  func reloadRows(at indexPath: IndexPath)
}

protocol AlbumListPresenterProtocol: AnyObject {
  var albums: [String: [Track]] { get }
  var tracks: [Track] { get }
  var albumsDictionary: [AlbumsDictionary] { get }
  var photos: [PhotoRecord] { get set }
  
  func getAlbums()
  func getTracks(with id: String)
  func album(atSection section: Int) -> String?
  func track(atIndex indexPath: IndexPath) -> Track?
  func loadNextAlbums()
  func reloadRows(at indexPath: IndexPath)

  
  func suspendAllOperations()
  func resumeAllOperations()
  func loadImagesForOnscreenCells(pathsArray: [IndexPath]?)
  func startOperations(for photoRecord: PhotoRecord, at indexPath: IndexPath)
  func startDownload(for photoRecord: PhotoRecord, at indexPath: IndexPath)
}

protocol AlbumListConfiguratorProtocol {
  func configure(with viewController: AlbumListTableViewController, dataFetcher: DataFetcher)
}

protocol ImageProvaiderProtocol {
  var photos: [PhotoRecord] { get set }
  func suspendAllOperations()
  func resumeAllOperations()
  func loadImagesForOnscreenCells(pathsArray: [IndexPath]?)
  func startOperations(for photoRecord: PhotoRecord, at indexPath: IndexPath)
  func startDownload(for photoRecord: PhotoRecord, at indexPath: IndexPath)
}
