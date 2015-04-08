//
//  tipoReservaUIViewController.swift
//  LosBarkitosIpad
//
//  Created by Jesus Valladolid Rebollar on 7/4/15.
//  Copyright (c) 2015 Jesus Valladolid Rebollar. All rights reserved.
//

import UIKit

class tipoReservaUIViewController: UIViewController {

    @IBOutlet weak var btnRioReservaUIButton: UIButton!
    @IBOutlet weak var btnElectricaReservaUIButton: UIButton!
    @IBOutlet weak var btnWhalyReservaUIButton: UIButton!
    @IBOutlet weak var btnGoldWhalyUIButton: UIButton!
   
    @IBAction func cancelarReservaUIButton(sender: UIButton) {
        
        dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func   prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "segueReservaRio" {
            let siguienteVC : VentaViewController = segue.destinationViewController as VentaViewController
            siguienteVC.totipoReservaViewControllerTipo = siguienteVC.RIO
            siguienteVC.totipoReservaViewControllerPV = siguienteVC.PUNTO_VENTA
            siguienteVC.tovueltaReservaViewController = true
            
        } else if segue.identifier == "segueReservaElectrica" {
            let siguienteVC : VentaViewController = segue.destinationViewController as VentaViewController
            siguienteVC.totipoReservaViewControllerTipo = siguienteVC.ELECTRICA
            siguienteVC.totipoReservaViewControllerPV = siguienteVC.PUNTO_VENTA
            siguienteVC.tovueltaReservaViewController = true

            
        } else if segue.identifier == "segueReservaWhaly" {
            let siguienteVC : VentaViewController = segue.destinationViewController as VentaViewController
            siguienteVC.totipoReservaViewControllerTipo = siguienteVC.WHALY
            siguienteVC.totipoReservaViewControllerPV = siguienteVC.PUNTO_VENTA
            siguienteVC.tovueltaReservaViewController = true


        } else if segue.identifier == "segueReservaGold" {
            let siguienteVC : VentaViewController = segue.destinationViewController as VentaViewController
            siguienteVC.totipoReservaViewControllerTipo = siguienteVC.GOLD
            siguienteVC.totipoReservaViewControllerPV = siguienteVC.PUNTO_VENTA
            siguienteVC.tovueltaReservaViewController = true

        }
        
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