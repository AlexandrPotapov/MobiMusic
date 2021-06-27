//
//  TrackCardConfigurator.swift
//  MobiMusic
//
//  Created by Александр on 27.06.2021.
//

import Foundation
import MediaPlayer

protocol TrackCardConfiguratorProtocol {
  func configure(with viewController: TrackCardViewController)
}

class TrackCardConfigurator: TrackCardConfiguratorProtocol {
  
  let track: TrackCardViewModel
  
  init(track: TrackCardViewModel) {
    self.track = track
  }
  
  func configure(with viewController: TrackCardViewController) {
    let presenter = TrackCardPresenter(view: viewController, track: track)
    presenter.audioPlayer = AudioPlayer(filePath: track.filePath)
    viewController.presenter = presenter
  }
}
