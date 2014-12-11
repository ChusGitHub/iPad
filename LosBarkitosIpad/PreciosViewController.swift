//
//  PreciosViewController.swift
//  LosBarkitosIpad
//
//  Created by chus on 9/12/14.
//  Copyright (c) 2014 Jesus Valladolid Rebollar. All rights reserved.
//

import UIKit


class PreciosViewController: UIViewController {
    
    class BotonPrecio : UIButton {
        let ANCHURA_BOTON = 160.0
        let ALTURA_BOTON  = 270.0
        let tamano = CGSizeMake(300,300)
        
    }
    
    var btnPrecio : BotonPrecio?
    var toPass : Int?

    @IBOutlet weak var labelPrueba: UILabel!
    
    @IBOutlet weak var numeroUIView: UIView!
 
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
     //   btnPrecio!.sizeThatFits(self.btnPrecio!.tamano)
       // numeroUIView.addSubview(btnPrecio!)
        self.labelPrueba.text = "\(self.toPass!)"
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
