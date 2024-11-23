//
//  ImageListAssembly.swift
//  ImageCacher
//
//  Created by Александр Федоткин on 23.11.2024.
//

import UIKit

final class ImageListAssembly {
    
    static func build() -> UIViewController {
        let viewModel = ImageListViewModel(data: CollectionModel(data: [
            "https://upload.wikimedia.org/wikipedia/commons/6/66/Mt-St-Greg-RueEcureuils-3.jpg",
            "https://upload.wikimedia.org/wikipedia/commons/a/af/Tatra_Gebirge%2C_Wald_bei_Schnee.jpg",
            "https://moya-planeta.ru/upload/images/xl/dd/75/dd7517a07597e867f71d31fc47b19e192340b4cd.jpg",
            "https://i.pinimg.com/736x/15/2f/08/152f08ae907bac5d4459990821b4d4c8.jpg",
            "https://ic.pics.livejournal.com/helen_i_rebyata/69641658/256815/256815_original.jpg",
            "https://mgazeta.com/attachments/5038d916aed6361224fdc3609f0c932d42416598/store/crop/0/0/1200/750/1600/0/0/cc69271782ef859a3f549d162c66196fcd2c2b3e3b1dffba40b6928af75d/9047978bebce89cc84514a53b26ed672.jpg",
            "https://img.desktopwallpapers.ru/nature/pics/wide/1920x1080/f403f1d9961eaf6205e778f4b52ca570.jpg",
            "https://topoboi.vip/wallpaper/thumb1000/main1000_spring_3840x2400_p48fn.jpg"
        ]))
        let viewController = ImageListViewController(viewModel: viewModel)
        return viewController
    }
}
