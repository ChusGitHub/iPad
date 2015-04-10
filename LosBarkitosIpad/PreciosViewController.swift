//
//  PreciosViewController.swift
//  LosBarkitosIpad
//
//  Created by chus on 9/12/14.
//  Copyright (c) 2014 Jesus Valladolid Rebollar. All rights reserved.
//

import UIKit


class PreciosViewController: UIViewController {

    
    let listaPrecio : String = DataManager().getValueForKey("lista_precio", inFile: "appstate") as! String
    var toTipo : Int?
    var toTipoString : String?

    @IBOutlet weak var cancelarUIButton: UIButton!
    @IBOutlet weak var aceptarUIButton: UIButton!
    @IBOutlet weak var precioUILabel: UILabel!
    @IBOutlet var preciosUIButton : [UIButton] = []
    
    @IBOutlet var coleccionBotonesPrecios: [UIButton]!
    @IBAction func btnPreciosUIButton(sender : UIButton) {
        self.precioUILabel.text = ""
        switch listaPrecio {
        case "1":
            self.precioUILabel.text = "\(sender.tag)"
        case "2":
            self.precioUILabel.text = "\(sender.tag + 5)"
        case "3":
           self.precioUILabel.text = "\(sender.tag + 10)"
        case "4":
           self.precioUILabel.text = "\(sender.tag + 15)"
        case "5":
           self.precioUILabel.text = "\(sender.tag + 20)"
        default:
            self.precioUILabel.text = "\(sender.tag)"
        }
        self.aceptarUIButton.enabled = true
    }
    
 
    override func viewDidLoad() {
        super.viewDidLoad()
        
       // AQUI HAY QUE RECORRER LOS BOTONES DE LOS PRECIOS PARA PONERLES EL LABEL ADECUADO.
        
        self.ponerPrecios()
        self.aceptarUIButton.enabled = false

        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "seguePreciosVentaCancelar" {
            let siguienteVC : VentaViewController = segue.destinationViewController as! VentaViewController
            siguienteVC.toPreciosViewController = 0
        } else if segue.identifier == "seguePreciosVentaAceptar" {
            let siguienteVC : VentaViewController = segue.destinationViewController as! VentaViewController
            siguienteVC.toPreciosViewController = "\(self.precioUILabel.text!)".toInt()!
            siguienteVC.barcaActual = self.toTipo!
            siguienteVC.barcaActualString = self.toTipoString!
        }
        
    }
    
    func ponerPrecios() {
        
        
        println("listaPrecio : \(listaPrecio)")

        var boton : UIButton
        for boton in self.preciosUIButton {
            switch listaPrecio {
            case "1":
                boton.setTitle("\(boton.tag)", forState: UIControlState.Normal)
            case "2":
                boton.setTitle("\(boton.tag + 5)", forState: UIControlState.Normal)
            case "3":
                boton.setTitle("\(boton.tag + 10)", forState: UIControlState.Normal)
            case "4":
                boton.setTitle("\(boton.tag + 15)", forState: UIControlState.Normal)
            case "5":
                boton.setTitle("\(boton.tag + 20)", forState: UIControlState.Normal)
            default:
                continue
            }
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
