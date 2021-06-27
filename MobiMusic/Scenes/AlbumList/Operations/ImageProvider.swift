//
//  ImageProvider.swift
//  MobiMusic
//
//  Created by Александр on 26.06.2021.
//

import Foundation

protocol ImageProvaiderProtocol {
  var covers: [CoverRecord] { get set }
  func suspendAllOperations()
  func resumeAllOperations()
  func loadImagesForOnscreenCells(pathsArray: [IndexPath]?)
  func startOperations(for photoRecord: CoverRecord, at indexPath: IndexPath)
  func startDownload(for photoRecord: CoverRecord, at indexPath: IndexPath)
}

class ImageProvider: ImageProvaiderProtocol {
  var covers: [CoverRecord] = []
  let pendingOperations = PendingOperations()
  
  weak var presenter: AlbumListPresenterProtocol!
  
  init(presenter: AlbumListPresenterProtocol) {
    self.presenter = presenter
  }
  
  func suspendAllOperations() {
    pendingOperations.downloadQueue.isSuspended = true
  }
  
  func resumeAllOperations() {
    pendingOperations.downloadQueue.isSuspended = false
  }
  
  func loadImagesForOnscreenCells(pathsArray: [IndexPath]?) {
    if let pathsArray = pathsArray {
      let allPendingOperations = Set(pendingOperations.downloadsInProgress.keys)
      
      var toBeCancelled = allPendingOperations
      let visiblePaths = Set(pathsArray)
      toBeCancelled.subtract(visiblePaths)
      
      var toBeStarted = visiblePaths
      toBeStarted.subtract(allPendingOperations)
      
      for indexPath in toBeCancelled {
        if let pendingDownload = pendingOperations.downloadsInProgress[indexPath] {
          pendingDownload.cancel()
        }
        pendingOperations.downloadsInProgress.removeValue(forKey: indexPath)
      }
      
      for indexPath in toBeStarted {
        let recordToProcess = covers[indexPath.section]
        startOperations(for: recordToProcess, at: indexPath)
      }
    }
  }
  
  func startOperations(for photoRecord: CoverRecord, at indexPath: IndexPath) {
    switch (photoRecord.state) {
    case .new:
      startDownload(for: photoRecord, at: indexPath)
    default:
      NSLog("do nothing")
    }
  }
  
  func startDownload(for photoRecord: CoverRecord, at indexPath: IndexPath) {
    guard pendingOperations.downloadsInProgress[indexPath] == nil else {
      return
    }
    
    let downloader = ImageDownloader(photoRecord)
    downloader.completionBlock = {
      if downloader.isCancelled {
        return
      }
      
      DispatchQueue.main.async {
        self.pendingOperations.downloadsInProgress.removeValue(forKey: indexPath)
      }
      self.presenter.reloadRows(at: indexPath)
    }
    pendingOperations.downloadsInProgress[indexPath] = downloader
    pendingOperations.downloadQueue.addOperation(downloader)
  }
}
