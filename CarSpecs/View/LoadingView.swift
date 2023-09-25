//
//  LoadingView.swift
//  CarSpecs
//
//  Created by Felipe Lima on 24/09/23.
//

import UIKit
import SnapKit

class LoadingView: UIView {

    var loadingindicator = UIActivityIndicatorView(style: .large)
    init() {
        super.init(frame: .zero)
        addSubview(loadingindicator)
        loadingindicator.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
        }
        loadingindicator.startAnimating()
        self.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        self.loadingindicator.color = UIColor.white
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
