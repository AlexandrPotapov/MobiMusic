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
    let router = AlbumListRouter(viewController: viewController)
    let presenter = AlbumListPresenter(view: viewController, router: router, dataFetcher: dataFetcher)
    let imageProvider = ImageProvider(presenter: presenter)
    presenter.imageProvider = imageProvider
    viewController.presenter = presenter
  }
  
  
}
