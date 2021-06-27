//
//  TrackCardViewController.swift
//  MobiMusic
//
//  Created by Александр on 27.06.2021.
//

import UIKit
import MediaPlayer

class TrackCardViewController: UIViewController {
  
  @IBOutlet weak var coverImageView: UIImageView!
  @IBOutlet weak var slider: UISlider!
  @IBOutlet weak var durationLabel: UILabel!
  @IBOutlet weak var playOrPauseButton: UIButton!
  @IBOutlet weak var singerLabel: UILabel!
  @IBOutlet weak var trackNameLabel: UILabel!
  
  //  var player: AVPlayer!
  var presenter: TrackCardPresenter!
  var configurator: TrackCardConfigurator!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    configurator.configure(with: self)
    presenter.viewDidLoad()
  }
  
  @IBAction func sliderAction(_ sender: UISlider) {
    presenter.rewind(to: slider.value)
  }
  @IBAction func PlayOrPauseAction(_ sender: UIButton) {
    presenter.playOrPauseTrack()
  }
  
}

extension TrackCardViewController: TrackCardViewProtocol {
  func setSliderMaximumValue(with value: Float) {
    slider.maximumValue = value
    
  }
  
  func setDurationLabel(with text: String) {
    durationLabel.text = text
  }
  
  func setSlider(with value: Float) {
    slider.value = value
  }
  
  
  func displayTheCard(with track: TrackCardViewModel) {
    coverImageView.image = track.coverImage
    singerLabel.text = track.singer
    trackNameLabel.text = track.trackName
    
    
  }
  
  func changeButtonLabelText(isPlaying: Bool) {
    if isPlaying {
      playOrPauseButton.setTitle("Pause", for: .normal)
    } else {
      playOrPauseButton.setTitle("Play", for: .normal)
    }
  }
  
}
