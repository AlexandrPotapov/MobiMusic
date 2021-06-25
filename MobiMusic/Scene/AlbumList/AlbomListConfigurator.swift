//
//  AlbomListConfigurator.swift
//  MobiMusic
//
//  Created by Александр on 24.06.2021.
//

import Foundation

protocol AlbumListConfiguratorProtocol {
  func configure(with viewController: AlbumListTableViewController, dataFetcher: DataFetcher)
}

class AlbumListConfigurator: AlbumListConfiguratorProtocol {
  func configure(with viewController: AlbumListTableViewController, dataFetcher: DataFetcher) {
    let presenter = AlbumListPresenter(view: viewController, dataFetcher: dataFetcher)
    viewController.presenter = presenter
  }
  
  
}
