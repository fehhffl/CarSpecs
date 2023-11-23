//
//  UserIconButton.swift
//  CarSpecs
//
//  Created by Felipe Lima on 14/11/23.
//

import UIKit

class UserIconButton: UIView {
    @IBOutlet weak var profileIconButton: UIButton!
    @IBOutlet var view: UIView!
    
    var delegate: UserIconButtonDelegate?

    override init(frame: CGRect) {
        super.init(frame: frame)
        loadNibContent()
        setupViewButton()
    }

    func setupViewButton() {
        view.styleAsPillView()
    }

    @IBAction func onUserButtonTapped(_ sender: Any) {
        delegate?.navigateToUserPage()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        loadNibContent()
    }
}
