//
//  AudioPlayer.swift
//  MobiMusic
//
//  Created by Александр on 27.06.2021.
//

import UIKit
import MediaPlayer

class AudioPlayer {
  
  var player: AVPlayer!
  
  init() {
    self.player = AVPlayer()
  }
  
  init(filePath: URL) {
    self.player = AVPlayer(url: filePath)
  }
  
  func seek(seconds: Double, preferredTimescale: Int) {
    player.seek(to: CMTime(seconds: seconds, preferredTimescale: CMTimeScale(preferredTimescale)))
  }
  
  func addPeriodicTimeObserver(complition: @escaping (Double) -> Void) {
    player.addPeriodicTimeObserver(forInterval: CMTime(seconds: 1, preferredTimescale: 1000), queue: DispatchQueue.main) { time in
      complition(time.seconds)
    }
  }
  
}
