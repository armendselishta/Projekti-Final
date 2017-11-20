//
//  FavoritetController.swift
//  Coin Tracker
//
//  Created by Rinor Bytyci on 11/13/17.
//  Copyright © 2017 Appbites. All rights reserved.
//

import UIKit
import CoreData

//Klasa permbane tabele kshtuqe duhet te kete
//edhe protocolet per tabela
class FavoritetController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    var cells:[CoinCellModel] = [CoinCellModel]()
    var selectedCoin:CoinCellModel!
    
    @IBOutlet weak var tableView: UITableView!
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib.init(nibName: "CoinCell", bundle: nil), forCellReuseIdentifier: "coinCell")
        
        
        let appdelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appdelegate.persistentContainer.viewContext
         let request = NSFetchRequest<NSFetchRequestResult>(entityName: "RUJ")
        do {
            
            let rezultati = try context.fetch(request)
            
            
            for elementi in rezultati as! [NSManagedObject]{
               let coin = CoinCellModel(coinName: elementi.value(forKey: "coinName")as! String , coinSymbol: elementi.value(forKey: "coinSymbol")as! String , coinAlgo: elementi.value(forKey: "coinAlgo")as! String , totalSuppy: elementi.value(forKey: "totalSuppy")as! String , imagePath: elementi.value(forKey: "imagePath")as! String )
                cells.append(coin)
            
              
            }
           
        tableView.reloadData()
           
            
        } catch {
            print("Gabim gjate Leximit")
        }
        
        
        
        //Lexo nga CoreData te dhenat dhe ruaj me nje varg
        //qe duhet deklaruar mbi funksionin UIViewController
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "coinCell") as! CoinCell
        cell.lblEmri.text = cells[indexPath.row].coinName
        cell.lblAlgoritmi.text = cells[indexPath.row].coinAlgo
        cell.lblTotali.text = cells[indexPath.row].totalSuppy
        cell.lblSymboli.text = cells[indexPath.row].coinSymbol
        cell.imgFotoja.af_setImage(withURL: URL(string: cells[indexPath.row].coinImage())!)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cells.count
    }
    
    @IBAction func kthehu(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
}
