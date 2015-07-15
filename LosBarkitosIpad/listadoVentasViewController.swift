//
//  listadoVentasViewController.swift
//  LosBarkitosIpad
//
//  Created by Jesus Valladolid Rebollar on 15/7/15.
//  Copyright (c) 2015 Jesus Valladolid Rebollar. All rights reserved.
//

import UIKit

class listadoVentasViewController: UIViewController, WebServiceListado, UITableViewDataSource, UITableViewDelegate {
    
    var webService : webServiceCallAPI = webServiceCallAPI()
    var listadoBarcas = 
    
    @IBOutlet weak var listadoVentas: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        webService.delegateListado = self
        
        webService.obtenerVentas()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    func didReceiveResponse_listadoVentas(diccionario : [String : AnyObject]) {
        
        // println("diccionario : \(diccionario)")
        self.listaBarcas = []
        var registro : [String : AnyObject] = [:]
        print("diccionario : \(diccionario)")
        for (k,v) in diccionario {
            if k == "numero_viajes" {
                self.numeroBarcas = v as! Int
            } else if (k == "error" && v as! String == "si") {
                print("FALLO")
            } else {
                registro["numero"] = v["numero"] as! Int
                registro["punto_venta"] = v["punto_venta"] as! String
                registro["fecha"] = v["hora_prevista"] as! String
                registro["precio"] = v["precio"] as! Int
                registro["tipo"] = v["tipo"]
                self.listaBarcas.append(registro)
            }
        }
        // ordenacion de las reservas por el numero
        
        self.listaBarcas.sort({(primero : [String:AnyObject], segundo : [String:AnyObject]) -> Bool in
            return   segundo["numero"] as! Int > primero["numero"] as! Int
        })
        
        self.listaUITableView.clearsContextBeforeDrawing = true
        self.listaUITableView.reloadData()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return self.numeroBarcas
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return 0
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell : listadoTableViewCell = self.listaUITableView.dequeueReusableCellWithIdentifier("CellListadoBarcas") as! listadoTableViewCell
        
        let numero : Int = self.listaBarcas[indexPath.row]["numero"] as! Int
        cell.numeroUILabel.text = String(numero)
        cell.puntoVentaUILabel.text = self.listaBarcas[indexPath.row]["punto_venta"] as? String
        cell.horaSalidaUILabel.text = self.listaBarcas[indexPath.row]["fecha"] as? String
        cell.tipoBarcaUILabel.text = self.listaBarcas[indexPath.row]["tipo_barca"] as? String
        let p : Int = self.listaBarcas[indexPath.row]["precio"] as! Int
        cell.precioUILabel.text = String(p)
        
        return cell    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
