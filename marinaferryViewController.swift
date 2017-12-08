//
//  marinaferryViewController.swift
//  LosBarkitosIpad
//
//  Created by Jesús Valladolid Rebollar on 8/12/17.
//  Copyright © 2017 Jesus Valladolid Rebollar. All rights reserved.
//

import UIKit

class marinaferryViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let alertaNOInternet = UIAlertController(title: "SIN CONEXIÓN!!!", message: "No hay conexión y no se ha incluido el ticket en el listado. Llama al Chus lo antes posible!!!", preferredStyle: UIAlertControllerStyle.alert)
        
        let OkAction = UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil)
        
        alertaNOInternet.addAction(OkAction)
        
        self.present(alertaNOInternet, animated: true, completion: nil)

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
