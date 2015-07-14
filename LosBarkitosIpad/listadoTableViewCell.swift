//
//  listadoTableViewCell.swift
//  LosBarkitosIpad
//
//  Created by chus on 14/7/15.
//  Copyright (c) 2015 Jesus Valladolid Rebollar. All rights reserved.
//

import UIKit

class listadoTableViewCell: UITableViewCell {

    @IBOutlet weak var numeroUILabel: UILabel!
    @IBOutlet weak var puntoVentaUILabel: UILabel!
    @IBOutlet weak var tipoBarcaUILabel: UILabel!
    @IBOutlet weak var horaSalidaUILabel: UILabel!
    @IBOutlet weak var precioUILabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
