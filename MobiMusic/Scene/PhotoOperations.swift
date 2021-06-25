

import Foundation
import UIKit

// This enum contains all the possible states a photo record can be in
enum PhotoRecordState {
  case new, downloaded, failed
}

class PhotoRecord {
  let name: String
  let url: URL
  var state = PhotoRecordState.new
  var image = UIImage(named: "Placeholder")
  
  init(name:String, url:URL) {
    self.name = name
    self.url = url
  }
}

class PendingOperations {
  lazy var downloadsInProgress: [IndexPath: Operation] = [:]
  lazy var downloadQueue: OperationQueue = {
    var queue = OperationQueue()
    queue.name = "Download queue"
    queue.maxConcurrentOperationCount = 1
    return queue
  }()
}

class ImageDownloader: Operation {
  //1
  let photoRecord: PhotoRecord
  
  //2
  init(_ photoRecord: PhotoRecord) {
    self.photoRecord = photoRecord
  }
  
  //3
  override func main() {
    //4
    if isCancelled {
      return
    }
    
    //5
    guard let imageData = try? Data(contentsOf: photoRecord.url) else { return }
    
    //6
    if isCancelled {
      return
    }
    
    //7
    if !imageData.isEmpty {
      photoRecord.image = UIImage(data:imageData)
      photoRecord.state = .downloaded
    } else {
      photoRecord.state = .failed
      photoRecord.image = UIImage(named: "Failed")
    }
  }
}
