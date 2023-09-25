//
//  File.swift
//  CarSpecs
//
//  Created by Felipe Lima on 24/09/23.
//

import Foundation
import UIKit
import SnapKit

extension UIViewController {
    func showLoader() {
        let subView = LoadingView()
        self.view.addSubview(subView)
        subView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
}
