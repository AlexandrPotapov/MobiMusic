//
//  AlbumListTableViewController.swift
//  MobiMusic
//
//  Created by Александр on 24.06.2021.
//

import UIKit

protocol AlbumListViewProtocol: AnyObject {
  func reloadData()
  func hideSpinners()
  func reloadRows(at indexPath: IndexPath)
  var selfToTrackCardSegueName: String { get }
}

class AlbumListTableViewController: UITableViewController {
  
  var presenter: AlbumListPresenterProtocol!
  var header = SpinnerView()
  var footer = SpinnerView()
  let selfToTrackCardSegueName = "TrackCard"
  
  private let dataFetcher = NetworkDataFetcher()
  private let configurator = AlbumListConfigurator()

    override func viewDidLoad() {
        super.viewDidLoad()
      let stockCell = UINib(nibName: "TrackTableViewCell", bundle: nil)
      tableView.register(stockCell , forCellReuseIdentifier: TrackTableViewCell.reuseId)

      
      configurator.configure(with: self, dataFetcher: dataFetcher)
      presenter.getAlbums()

      header.showLoader()
      tableView.tableHeaderView = header
      tableView.tableFooterView = footer
      
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
      return presenter.albumsDictionary.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      return presenter.albumsDictionary[section].tracks.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TrackTableViewCell.reuseId, for: indexPath) as! TrackTableViewCell

      guard let track = presenter.track(atIndex: indexPath) else { return UITableViewCell() }
      
      if cell.accessoryView == nil {
        let indicator = UIActivityIndicatorView(style: .medium)
        cell.accessoryView = indicator
      }
      let indicator = cell.accessoryView as! UIActivityIndicatorView
      
      var photoRecord = CoverRecord(name: "", url: URL(fileURLWithPath: ""))
      for photo in presenter.covers {
        if photo.name == track.coverUrl {
          photoRecord = photo
        }
      }
      let photoDetails = photoRecord
      cell.trackName?.text = track.name
      cell.albumImage?.image = photoDetails.image
      
      switch (photoDetails.state) {
      case .downloaded:
        indicator.stopAnimating()
      case .failed:
        indicator.stopAnimating()
        cell.textLabel?.text = "Failed to load"
      case .new:
        indicator.startAnimating()
        if !tableView.isDragging && !tableView.isDecelerating {
          presenter.startOperations(for: photoDetails, at: indexPath)
        }
      }
        return cell
    }
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    presenter.didSelect(at: indexPath)
  }

  
  // MARK: Setup rows and sections
  override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
      let view = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 60))
    view.backgroundColor = .systemTeal
      
      let lbl = UILabel(frame: CGRect(x: 15, y: 0, width: view.frame.width - 15, height: 60))
      lbl.font = UIFont.systemFont(ofSize: 20)
    lbl.numberOfLines = 0
    guard let album = presenter.album(atSection: section) else { return nil }
      lbl.text = album
      view.addSubview(lbl)
      return view
  }
  
  override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
      return 60
  }
  
  override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
      return 200
  }
}
