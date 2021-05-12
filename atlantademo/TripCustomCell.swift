//
//  TripCustomCell.swift
//  atlantademo
//
//  Created by Dean Andreakis on 9/9/17.
//  Copyright © 2017 gisi. All rights reserved.
//

import UIKit

class TripCustomCell : UITableViewCell {
    @IBAction func VerticalMoreButtonAction(_ sender: Any) {
        delegate?.moreButtonSelected()
    }
    
    @IBOutlet weak var GrayGreenDotImageView: UIImageView!
    @IBOutlet weak var DepartArriveCityLabel: UILabel!
    @IBOutlet weak var GateBoardDescriptioLabel: UILabel!
    @IBOutlet weak var VerticalMoreButton: UIButton!
    @IBOutlet weak var DepartArriveCityLabelYConstraint: NSLayoutConstraint!
    @IBOutlet weak var AssistanceImageView: UIImageView!
    
    weak var delegate: TripCustomCellDelegate?
}

protocol TripCustomCellDelegate: class {
    func moreButtonSelected()
}
