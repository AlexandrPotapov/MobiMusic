//
//  TrackCardPresenter.swift
//  MobiMusic
//
//  Created by Александр on 27.06.2021.
//

import Foundation

protocol TrackCardViewProtocol: AnyObject {
  func displayTheCard(with track: TrackCardViewModel)
  func setDurationLabel(with text: String)
  func setSlider(with value: Float)
  func changeButtonLabelText(isPlaying: Bool)
  func setSliderMaximumValue(with value: Float)
}

protocol TrackCardPresenterProtocol {
  var track: TrackCardViewModel! { get }
  func viewDidLoad()
  func playOrPauseTrack()
  func rewind(to sliderValue: Float)
}

class TrackCardPresenter: TrackCardPresenterProtocol {
  func viewDidLoad() {
    view.setSliderMaximumValue(with: Float(audioPlayer.player.currentItem?.asset.duration.seconds ?? 0))
    view.displayTheCard(with: track)
    addPeriodicTimeObserver()
  }
  
  
  var track: TrackCardViewModel!
  
  var audioPlayer = AudioPlayer()
  
  weak var view: TrackCardViewProtocol!
  
  
  required init(view: TrackCardViewProtocol, track: TrackCardViewModel) {
    self.view = view
    self.track = track
  }
  
  func addPeriodicTimeObserver() {
    audioPlayer.addPeriodicTimeObserver { [weak self] seconds in
      let secondsText = String(format: "%02d", Int(seconds) % 60)
      let minutesText = String(format: "%02d", Int(seconds) / 60)
      self?.view.setDurationLabel(with: "\(minutesText):\(secondsText)")
      self?.view.setSlider(with: Float(seconds))
    }
  }
  func playOrPauseTrack() {
    if audioPlayer.player.timeControlStatus == .playing {
      audioPlayer.player.pause()
      view.changeButtonLabelText(isPlaying: false)
    } else {
      audioPlayer.player.play()
      view.changeButtonLabelText(isPlaying: true)
    }
    
  }
  func rewind(to sliderValue: Float) {
    audioPlayer.seek(seconds: Double(sliderValue), preferredTimescale: 1000)
    
  }
  
  
}
