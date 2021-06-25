//
//  AlbumListTableViewController.swift
//  MobiMusic
//
//  Created by Александр on 24.06.2021.
//
class MobileBrand {
    var brandName: String?
    var modelName: [String]?
    
    init(brandName: String, modelName: [String]) {
        self.brandName = brandName
        self.modelName = modelName
    }
}

import UIKit

class AlbumListTableViewController: UITableViewController {
//  var mobileBrand = [MobileBrand]()
  
  var presenter: AlbumListPresenterProtocol!
  
  private var albumsImage: [UIImage]!
  var photos: [PhotoRecord] = []
  let pendingOperations = PendingOperations()
  
  private let dataFetcher = NetworkDataFetcher()
  private let configurator = AlbumListConfigurator()

    override func viewDidLoad() {
        super.viewDidLoad()
      
      let stockCell = UINib(nibName: "TrackTableViewCell", bundle: nil)
      tableView.register(stockCell , forCellReuseIdentifier: TrackTableViewCell.reuseId)

//      mobileBrand.append(MobileBrand.init(brandName: "Apple", modelName: ["iPhone 5s","iPhone 6","iPhone 6s", "iPhone 7+", "iPhone 8", "iPhone 8+", "iPhone 11", "iPhone 11 Pro"]))
//      mobileBrand.append(MobileBrand.init(brandName: "Samsung", modelName: ["Samsung M Series", "Samsung Galaxy Note 9", "Samsung Galaxy Note 9+", "Samsung Galaxy Note 10", "Samsung Galaxy Note 10 +"]))
//      mobileBrand.append(MobileBrand.init(brandName: "Mi", modelName: ["Mi Note 7", "Mi Note 7 Pro", "Mi K20"]))
//      mobileBrand.append(MobileBrand.init(brandName: "Huawei", modelName: ["Huawei Mate 20", "Huawei P30 Pro", "Huawei P10 Plus", "Huawei P20"]))
      
      configurator.configure(with: self, dataFetcher: dataFetcher)
      presenter.getAlbums()

    }
  
  // MARK: - scrollview delegate methods
  
  override func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
    //1
    suspendAllOperations()
  }
  
  override func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
    // 2
    if !decelerate {
      loadImagesForOnscreenCells()
      resumeAllOperations()
    }
  }
  
  override func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
    // 3
    loadImagesForOnscreenCells()
    resumeAllOperations()
  }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
      return presenter.albumsDictionary.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
      return presenter.albumsDictionary[section].tracks.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TrackTableViewCell.reuseId, for: indexPath) as! TrackTableViewCell

      guard let track = presenter.track(atIndex: indexPath) else { return UITableViewCell() }
//      cell.set(track: track)
      
      //1
      if cell.accessoryView == nil {
        let indicator = UIActivityIndicatorView(style: .medium)
        cell.accessoryView = indicator
      }
      let indicator = cell.accessoryView as! UIActivityIndicatorView
      
      //2 ПЕРЕДЛАТЬ
      var photoRec = PhotoRecord(name: "", url: URL(fileURLWithPath: ""))
      for photo in photos {
        if photo.name == track.coverUrl {
          photoRec = photo
        }
      }
      let photoDetails = photoRec
//      print(photos[indexPath.row].url, indexPath.row, track.name)
      //3
      cell.trackName?.text = track.name
      cell.albumImage?.image = photoDetails.image
      
      //4
      switch (photoDetails.state) {
      case .downloaded:
        indicator.stopAnimating()
      case .failed:
        indicator.stopAnimating()
        cell.textLabel?.text = "Failed to load"
      case .new:
        indicator.startAnimating()
        if !tableView.isDragging && !tableView.isDecelerating {
          startOperations(for: photoDetails, at: indexPath)
        }
      }
      
        return cell
    }

  override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
      let view = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 40))
      view.backgroundColor = #colorLiteral(red: 1, green: 0.3653766513, blue: 0.1507387459, alpha: 1)
      
      let lbl = UILabel(frame: CGRect(x: 15, y: 0, width: view.frame.width - 15, height: 40))
      lbl.font = UIFont.systemFont(ofSize: 20)
    guard let album = presenter.album(atSection: section) else { return nil }
      lbl.text = album
      view.addSubview(lbl)
      return view
  }
  
  override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
      return 40
  }
  
  override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
      return 200
  }
  // MARK: - operation management
  
  func suspendAllOperations() {
    pendingOperations.downloadQueue.isSuspended = true
  }
  
  func resumeAllOperations() {
    pendingOperations.downloadQueue.isSuspended = false
  }
  
  func loadImagesForOnscreenCells() {
    //1
    if let pathsArray = tableView.indexPathsForVisibleRows {
      //2
      let allPendingOperations = Set(pendingOperations.downloadsInProgress.keys)
      
      //3
      var toBeCancelled = allPendingOperations
      let visiblePaths = Set(pathsArray)
      toBeCancelled.subtract(visiblePaths)
      
      //4
      var toBeStarted = visiblePaths
      toBeStarted.subtract(allPendingOperations)
      
      // 5
      for indexPath in toBeCancelled {
        if let pendingDownload = pendingOperations.downloadsInProgress[indexPath] {
          pendingDownload.cancel()
        }
        
        pendingOperations.downloadsInProgress.removeValue(forKey: indexPath)
      }
      
      // 6
      for indexPath in toBeStarted {
        let recordToProcess = photos[indexPath.row]
        startOperations(for: recordToProcess, at: indexPath)
      }
    }
  }
  
  func startOperations(for photoRecord: PhotoRecord, at indexPath: IndexPath) {
    switch (photoRecord.state) {
    case .new:
      startDownload(for: photoRecord, at: indexPath)
    case .downloaded:
      print("downloaded")
    default:
      NSLog("do nothing")
    }
  }
  
  func startDownload(for photoRecord: PhotoRecord, at indexPath: IndexPath) {
    //1
    guard pendingOperations.downloadsInProgress[indexPath] == nil else {
      return
    }
    
    //2
    let downloader = ImageDownloader(photoRecord)
    //3
    downloader.completionBlock = {
      if downloader.isCancelled {
        return
      }
      
      DispatchQueue.main.async {
        self.pendingOperations.downloadsInProgress.removeValue(forKey: indexPath)
        self.tableView.reloadRows(at: [indexPath], with: .fade)
      }
    }
    //4
    pendingOperations.downloadsInProgress[indexPath] = downloader
    //5
    pendingOperations.downloadQueue.addOperation(downloader)
  }
}




extension AlbumListTableViewController: AlbumListViewProtocol {
  func loadAlbumImage(withUrl imageUrl: String, name: String) {
//    print(imageUrl)
    let url = URL(string: imageUrl)
    if let url = url {
      let photoRecord = PhotoRecord(name: name, url: url)
      self.photos.append(photoRecord)
    }
//    guard let url = URL(string: imageUrl) else { return }
//    let dataTask = URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
//      DispatchQueue.main.async {
//        if let data = data, let response = response {
//                      let image = UIImage(data: data)
//                    guard let image = image else { return }
//                    self?.albumsImage.append(image)
//        }
//      }
//    }
//    dataTask.resume()
//    let task = URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
//        guard let data = data else { return }
//        print("Done!")
//            let image = UIImage(data: data)
//          guard let image = image else { return }
//          self?.albumsImage.append(image)
//    }
//    task.resume()
  }
  
  func reloadData() {
//    DispatchQueue.main.async {
      self.tableView.reloadData()
//    }
  }
  
  
}
