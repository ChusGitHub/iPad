//
//  PreciosViewController.swift
//  LosBarkitosIpad
//
//  Created by chus on 9/12/14.
//  Copyright (c) 2014 Jesus Valladolid Rebollar. All rights reserved.
//

import UIKit


class PreciosViewController: UIViewController {

    

    var toPass : Int?

    @IBOutlet weak var cancelarUIButton: UIButton!
    @IBOutlet weak var aceptarUIButton: UIButton!
    @IBOutlet weak var precioUILabel: UILabel!
    @IBOutlet var preciosUIButton : [UIButton] = []
    
    @IBOutlet var coleccionBotonesPrecios: [UIButton]!
    @IBAction func btnPreciosUIButton(sender : UIButton) {
        self.precioUILabel.text = ""
        self.precioUILabel.text = "\(sender.tag)"
    }
    
 
    override func viewDidLoad() {
        super.viewDidLoad()
        
       // AQUI HAY QUE RECORRER LOS BOTONES DE LOS PRECIOS PARA PONERLES EL LABEL ADECUADO.
        
        self.ponerPrecios()

        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "seguePreciosVentaCancelar" {
            let siguienteVC : VentaViewController = segue.destinationViewController as VentaViewController
            siguienteVC.toPreciosViewController = nil
        } else if segue.identifier == "seguePreciosVentaAceptar" {
            let siguienteVC : VentaViewController = segue.destinationViewController as VentaViewController
            siguienteVC.toPreciosViewController = "Ok - Precio = \(self.precioUILabel.text)"
        }
        
    }
    
    func ponerPrecios() {

        for boton : UIButton in self.coleccionBotonesPrecios {
            
            
            
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
