//
//  TrackTableViewCell.swift
//  MobiMusic
//
//  Created by Александр on 24.06.2021.
//

import UIKit

class TrackTableViewCell: UITableViewCell {

  @IBOutlet weak var albumImage: UIImageView!
  @IBOutlet weak var trackName: UILabel!
  
  static let reuseId = "TrackCell"

  override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
  func set(with track: Track, photos: [PhotoRecord]) {
    
    var photoRecord = PhotoRecord(name: "", url: URL(fileURLWithPath: ""))
    for photo in photos {
      if photo.name == track.coverUrl {
        photoRecord = photo
      }
    }
    let photoDetails = photoRecord
    self.trackName?.text = track.name
    self.albumImage?.image = photoDetails.image
  }
}


