//
//  FirstViewController.swift CLARO
//  LosBarkitosIpad
//
//  Created by Jesus Valladolid Rebollar on 14/11/14.
//  Copyright (c) 2014 Jesus Valladolid Rebollar. All rights reserved.
//
//import "VendedorUITableViewCell"
import UIKit

class VentaViewController: UIViewController, UITableViewDelegate, UITableViewDataSource , WebServiceProtocolo{

    @IBOutlet weak var estadoVentaUITextField: UITextField!
    
    
    // LLamo a obtenerVendedores cuando se pulsa el boton del uitableview
    @IBAction func btnViewVendedoresIBAction(sender: AnyObject) {
        webService.obtenerVendedores()
        self.vendedorUITableView.hidden = false
    }
    
    @IBOutlet weak var vendedorUITextField: UITextField!
    
    @IBOutlet  weak var vendedorUITableView: UITableView!

    
    // Items de vendedorUITableView
    var item : NSMutableDictionary = [:]
    var items : NSMutableArray = []
    var respuesta = [String : String]()
    
    
    var webService : webServiceCallAPI = webServiceCallAPI()
    var vendedores : NSArray = NSArray()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // Compruebo si ya se ha abierto el dia
    
        cargarValoresCon_appstate(inFile: "appstate")
        
        // Registro el cell class vendedorViewController
        //self.vendedorUITableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
        self.vendedorUITableView.hidden = true
               
       // self.vendedorUITableViewIBOutlet.hidden = true
        
        // creo enlace a webService y digo que el protocolo soy yo mismo
        webService.delegate = self
       
    }
    
    override func viewWillAppear(animated: Bool) {

        var estadoActual = DataManager().getValueForKey("estado_venta", inFile: "appstate") as Int
        
        estadoVentaUITextField.text = "\(estadoActual)"
        estadoActual += 1
        // guardamos el valor actual del estado
        DataManager().setValueForKey("estado_venta", value: estadoActual, inFile: "appstate")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    // Respuesta del webService
    func didReceiveResponse(respuesta : NSDictionary) {
        println("Respuesta del servidor : \(respuesta)")
        for (k,v) in respuesta {
            if k as NSString == "error" && v as NSString == "si" {
                println("ERROR EN EL DICCIONARIO DEVUELTO")
                EXIT_FAILURE
            }
            println("valor de \(k as NSString): \(v as NSDictionary)")
            let cod : NSInteger = v["codigo"] as NSInteger
            let nombre : NSString = v["nombre"] as NSString
            self.item[cod] = nombre
           // self.item.setValue(nombre, forKey: cod)
            
        }
        self.items.addObject(item)
        self.vendedorUITableView.reloadData()
    }
    
    
    func cargarValoresCon_appstate(inFile file: String) {
        
        self.vendedorUITextField.text = DataManager().getValueForKey("vendedor", inFile: file) as String?
        
    }

    
    // IMPLEMENTO LOS METODOS DELEGADOS DE vendedorUITableView
    func tableView(vendedorUITableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.items.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        var cell: VendedorUITableViewCell = self.vendedorUITableView.dequeueReusableCellWithIdentifier("cell") as VendedorUITableViewCell
        
        cell.nombreVendedorUILabelCell.textColor = UIColor.whiteColor()
        cell.codigoVendedorUILabelCell.textColor = UIColor.whiteColor()
        if indexPath.row % 2 == 0 {
            cell.backgroundColor = UIColor.purpleColor()
        } else {
            cell.backgroundColor = UIColor.blueColor()
        }
        
        let vendedor : NSDictionary = self.items[indexPath.row] as NSDictionary
        for (k,v) in vendedor {
            println("Indexpath.row: \(indexPath.row)")
            println("k: \(k)")
            println("v: \(v)")
            cell.codigoVendedorUILabelCell.text = k as? String
            cell.nombreVendedorUILabelCell.text = v as? String
        }
        
        cell.tag = indexPath.row
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        println("Indice : \(indexPath.row)")
        var nombre : NSDictionary = self.vendedorUITableView.dequeueReusableCellWithIdentifier("cell")?.objectAtIndex(indexPath.row) as NSDictionary
       // nombreVendedorUITableViewCell.text = "Hola"
        //codigoVendedorUITableViewCell.text = "Adios"
        
        println("Nombre: \(nombre)")
    }
    
}

