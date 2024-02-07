//
//  FullScreenLoadingView.swift
//  CarSpecs
//
//  Created by Felipe Lima on 24/09/23.
//

import UIKit
import SnapKit

class FullScreenLoadingView: UIView {
    static var shared = FullScreenLoadingView()

    let darkOverlay = UIView(frame: .zero)

    var loadingindicator = UIActivityIndicatorView(style: .large)
    init() {
        super.init(frame: .zero)
        darkOverlay.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        addSubview(darkOverlay)
        darkOverlay.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }

        addSubview(loadingindicator)
        loadingindicator.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
        }
        loadingindicator.startAnimating()
        self.backgroundColor = .white
        self.loadingindicator.color = .white
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
