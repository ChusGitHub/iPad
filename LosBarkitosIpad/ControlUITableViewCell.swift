//
//  ControlUITableViewCell.swift
//  LosBarkitosIpad
//
//  Created by Jesus Valladolid Rebollar on 8/3/15.
//  Copyright (c) 2015 Jesus Valladolid Rebollar. All rights reserved.
//

import UIKit

class ControlUITableViewCell: UITableViewCell {

    @IBOutlet weak var numeroUILabelUITableViewCell: UILabel!
    @IBOutlet weak var vendedorUILabelUITableViewCell: UILabel!
    @IBOutlet weak var barcaUILabelUITableViewCell: UILabel!
    @IBOutlet weak var baseUILabelUITableViewCell: UILabel!
    @IBOutlet weak var precioUILabelUITableViewCell: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
