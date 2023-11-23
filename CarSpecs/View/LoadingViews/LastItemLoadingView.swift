//
//  LastItemLoadingView.swift
//  CarSpecs
//
//  Created by Gabriel Carvalho on 23/11/23.
//

import UIKit
import SnapKit
import Lottie

class LastItemLoadingView: UIView {
    private let animationView = AnimationView(name: "spinnerLottieAnimationFile")

    override func layoutSubviews() {
        super.layoutSubviews()
        animationView.loopMode = .loop
        if subviews.isEmpty {
            addSubview(animationView)
            animationView.snp.makeConstraints { make in
                make.edges.equalToSuperview()
                make.height.equalTo(50)
            }
        }
    }

    func play() {
        animationView.play()
    }

    func stop() {
        animationView.stop()
    }
}
