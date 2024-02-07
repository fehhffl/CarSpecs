//
//  BaseViewController.swift
//  CarSpecs
//
//  Created by Felipe Lima on 23/11/23.
//

import UIKit
import SnapKit

class BaseViewController: BaseViewController {
    
    let loadingView = FullScreenLoadingView()

    func showLoader() {
        self.view.addSubview(loadingView)
        loadingView.snp.makeConstraints { maker in
            maker.edges.equalToSuperview()
        }
    }

    func hideLoader() {
        loadingView.removeFromSuperview()
    }
}
