//
//  AlbumListTableViewControllerExtensions.swift
//  MobiMusic
//
//  Created by Александр on 26.06.2021.
//

import Foundation
import UIKit

// MARK: AlbumListViewProtocol
extension AlbumListTableViewController: AlbumListViewProtocol {
  func reloadRows(at indexPath: IndexPath) {
    DispatchQueue.main.async {
      self.tableView.reloadRows(at: [indexPath], with: .fade)
    }
  }
  
  func hideSpinners() {
    header.hideLoader()
    footer.hideLoader()
  }
  
  func reloadData() {
    self.tableView.reloadData()
  }
}


extension AlbumListTableViewController {
  // MARK: - Scrollview delegate methods
  override func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
    presenter.suspendAllOperations()
  }
  
  override func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
    if !decelerate {
      let pathsArray = tableView.indexPathsForVisibleRows
      presenter.loadImagesForOnscreenCells(pathsArray: pathsArray)
      presenter.resumeAllOperations()
    }
    
    if scrollView.contentOffset.y > scrollView.contentSize.height / 1.1 {
      footer.showLoader()
      presenter.loadNextAlbums()
    }
  }
}

// MARK: Routing
extension AlbumListTableViewController {
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    presenter.router.prepare(for: segue, sender: sender)
}
}
