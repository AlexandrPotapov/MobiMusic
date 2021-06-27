//
//  AlbumListRouter.swift
//  MobiMusic
//
//  Created by Александр on 24.06.2021.
//

import UIKit



protocol AlbumListRouterProtocol: ViewRouter {
  func openTrackCardViewController(with track: TrackCardViewModel)
  
}

class AlbumListRouter: NSObject {
  
  weak var viewController: AlbumListTableViewController!
  var track: TrackCardViewModel!
  
  init(viewController: AlbumListTableViewController) {
    self.viewController = viewController
  }
  
  func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if let trackCardViewController = segue.destination as? TrackCardViewController {
      trackCardViewController.configurator = TrackCardConfigurator(track: track)
    }
  }
}


extension AlbumListRouter: AlbumListRouterProtocol {
  func openTrackCardViewController(with track: TrackCardViewModel) {
    self.track = track
    viewController.performSegue(
      withIdentifier: viewController.selfToTrackCardSegueName,
      sender: (track)
    )
  }
}
