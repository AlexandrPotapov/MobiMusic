//
//  AlbomListConfigurator.swift
//  MobiMusic
//
//  Created by Александр on 24.06.2021.
//

import Foundation

class AlbumListConfigurator: AlbumListConfiguratorProtocol {
  func configure(with viewController: AlbumListTableViewController, dataFetcher: DataFetcher) {
    let presenter = AlbumListPresenter(view: viewController, dataFetcher: dataFetcher)
    let imageProvider = ImageProvider(presenter: presenter)
    presenter.imageProvider = imageProvider
    viewController.presenter = presenter
  }
  
  
}
