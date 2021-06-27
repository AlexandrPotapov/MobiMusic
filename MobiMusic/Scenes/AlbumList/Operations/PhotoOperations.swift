

import Foundation
import UIKit

// This enum contains all the possible states a photo record can be in
enum CoverRecordState {
  case new, downloaded, failed
}

class CoverRecord {
  let name: String
  let url: URL
  var state = CoverRecordState.new
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
  let coverRecord: CoverRecord
  
  //2
  init(_ photoRecord: CoverRecord) {
    self.coverRecord = photoRecord
  }
  
  //3
  override func main() {
    //4
    if isCancelled {
      return
    }
    
    //5
    guard let imageData = try? Data(contentsOf: coverRecord.url) else { return }
    
    //6
    if isCancelled {
      return
    }
    
    //7
    if !imageData.isEmpty {
      coverRecord.image = UIImage(data:imageData)
      coverRecord.state = .downloaded
    } else {
      coverRecord.state = .failed
      coverRecord.image = UIImage(named: "Failed")
    }
  }
}
