//
//  ListaController.swift
//  Coin Tracker
//
//  Created by Rinor Bytyci on 11/12/17.
//  Copyright © 2017 Appbites. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage
import SwiftyJSON

//Duhet te jete conform protocoleve per tabele
class ListaController: UIViewController, UITableViewDelegate, UITableViewDataSource{

    @IBOutlet weak var tableView: UITableView!


    
    var cells:[CoinCellModel] = [CoinCellModel]()

    var selectedCoin:CoinCellModel!
   
    
    //Krijo IBOutlet tableView nga View
    //Krijo nje varg qe mban te dhena te tipit CoinCellModel
    //Krijo nje variable slectedCoin te tipit CoinCellModel!
    //kjo perdoret per tja derguar Controllerit "DetailsController"
    //me poshte, kur ndodh kalimi nga screen ne screen (prepare for segue)
    
    
    //URL per API qe ka listen me te gjithe coins
    //per me shume detaje : https://www.cryptocompare.com/api/
    let APIURL = "https://min-api.cryptocompare.com/data/all/coinlist"
    
    override func viewDidLoad() {
        super.viewDidLoad()

       tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib.init(nibName: "CoinCell", bundle: nil), forCellReuseIdentifier: "coinCell")
        
        
        //regjistro delegate dhe datasource per tableview
        //regjistro custom cell qe eshte krijuar me NIB name dhe
        //reuse identifier
        
        //Thirr funksionin getDataFromAPI()
        getDataFromAPI()
    }
    
    //Funksioni getDataFromAPI()
    //Perdor alamofire per te thirre APIURL dhe ruan te dhenat
    //ne listen vargun me CoinCellModel
    //Si perfundim, thrret tableView.reloadData()
    func getDataFromAPI(){
  
        Alamofire.request(APIURL).responseData { (data) in
            
            if data.result.isSuccess{
                let coinsJson = JSON(data.result.value!)
                for(key, value):(String, JSON) in coinsJson["Data"]{
                    let coin = CoinCellModel(coinName: value["CoinName"].stringValue, coinSymbol: value["Name"].stringValue, coinAlgo: value["Algorithm"].stringValue, totalSuppy: value["TotalCoinSupply"].stringValue, imagePath: value["ImageUrl"].stringValue)
                    
                    self.cells.append(coin)
                }
                self.tableView.reloadData()
            }
            
        }
        
        
    tableView.reloadData()
        
    
        
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cells.count
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
    
    
    
    
    //Shkruaj dy funksionet e tabeles ketu
    //cellforrowat indexpath dhe numberofrowsinsection
    
    
    //Funksioni didSelectRowAt indexPath merr parane qe eshte klikuar
    //Ruaj Coinin e klikuar tek selectedCoin variabla e deklarurar ne fillim
    //dhe e hap screenin tjeter duke perdore funksionin
    //performSegue(withIdentifier: "EmriILidhjes", sender, self)
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    selectedCoin = cells[indexPath.row]
        performSegue(withIdentifier: "shfaqDetajet", sender: self)
    }
    
    //Beje override funksionin prepare(for segue...)
    //nese identifier eshte emri i lidhjes ne Storyboard.
    //controllerit tjeter ja vendosim si selectedCoin, coinin
    //qe e kemi ruajtur me siper

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "shfaqDetajet"{
            let detail = segue.destination as! DetailsController
            detail.selectedCoin = selectedCoin
        }
        
    }

}
