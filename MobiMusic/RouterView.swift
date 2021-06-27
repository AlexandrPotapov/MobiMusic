//
//  RouterView.swift
//  MobiMusic
//
//  Created by Александр on 27.06.2021.
//

import UIKit

protocol ViewRouter {
  func prepare(for segue: UIStoryboardSegue, sender: Any?)
}

extension ViewRouter {
  func prepare(for segue: UIStoryboardSegue, sender: Any?) { }
}
