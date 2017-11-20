//
//  ViewController.swift
//  Coin Tracker
//
//  Created by Rinor Bytyci on 11/12/17.
//  Copyright © 2017 Appbites. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage
import SwiftyJSON
import CoreData


class DetailsController: UIViewController {

    //selectedCoin deklaruar me poshte mbushet me te dhena nga
    //controlleri qe e thrret kete screen (Shiko ListaController.swift)
    var selectedCoin:CoinCellModel!
    
    
    //IBOutlsets jane deklaruar me poshte
    @IBOutlet weak var imgFotoja: UIImageView!
    @IBOutlet weak var lblDitaOpen: UILabel!
    @IBOutlet weak var lblDitaHigh: UILabel!
    @IBOutlet weak var lblDitaLow: UILabel!
    @IBOutlet weak var lbl24OreOpen: UILabel!
    @IBOutlet weak var lbl24OreHigh: UILabel!
    @IBOutlet weak var lbl24OreLow: UILabel!
    @IBOutlet weak var lblMarketCap: UILabel!
    @IBOutlet weak var lblCmimiBTC: UILabel!
    @IBOutlet weak var lblCmimiEUR: UILabel!
    @IBOutlet weak var lblCmimiUSD: UILabel!
    @IBOutlet weak var lblCoinName: UILabel!
    
    //APIURL per te marre te dhenat te detajume per coin
    //shiko: https://www.cryptocompare.com/api/ per detaje
    let APIURL = "https://min-api.cryptocompare.com/data/pricemultifull"
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
    imgFotoja.af_setImage(withURL: URL(string: selectedCoin.coinImage())!)
        
        
        //brenda ketij funksioni, vendosja foton imgFotoja Outletit
        //duke perdorur AlamoFireImage dhe funksionin:
        //af_setImage(withURL:URL)
        //psh: imageFotoja.af_setImage(withURL: URL(string: selectedCoin.imagePath)!)
        //Te dhenat gjenerale per coin te mirren nga objeti selectedCoin
        
        var params : [String:String] = ["fsyms": selectedCoin.coinSymbol, "tsyms": "BTC,USD,EUR"]
        
        getDetails(params: params)
        
        //Krijo nje dictionary params[String:String] per ta thirrur API-ne
        //parametrat qe duhet te jene ne kete params:
        //fsyms - Simboli i Coinit (merre nga selectedCoin.coinSymbol)
        //tsyms - llojet e parave qe na duhen: ""BTC,USD,EUR""
        
        //Thirr funksionin getDetails me parametrat me siper
    }

    func getDetails(params:[String:String]){
        Alamofire.request(APIURL, method: .get, parameters: params).responseData { (data) in
            if data.result.isSuccess{
                let coinsJson = JSON(data.result.value!)
                let coin = CoinDetailsModel(marketCap: coinsJson["DISPLAY"][self.selectedCoin.coinSymbol]["USD"]["MKTCAP"].stringValue, hourHigh: coinsJson["DISPLAY"][self.selectedCoin.coinSymbol]["USD"]["HIGHT24HOUR"].stringValue, hourLow: coinsJson["DISPLAY"][self.selectedCoin.coinSymbol]["USD"]["LOW24HOUR"].stringValue, hourOpen: coinsJson["DISPLAY"][self.selectedCoin.coinSymbol]["USD"]["OPEN24HOUR"].stringValue, dayHigh: coinsJson["DISPLAY"][self.selectedCoin.coinSymbol]["USD"]["HIGHDAY"].stringValue, dayLow: coinsJson["DISPLAY"][self.selectedCoin.coinSymbol]["USD"]["LOWDAY"].stringValue, dayOpen: coinsJson["DISPLAY"][self.selectedCoin.coinSymbol]["USD"]["OPENDAY"].stringValue, priceEUR: coinsJson["DISPLAY"][self.selectedCoin.coinSymbol]["EUR"]["PRICE"].stringValue, priceUSD: coinsJson["DISPLAY"][self.selectedCoin.coinSymbol]["USD"]["PRICE"].stringValue , priceBTC: coinsJson["DISPLAY"][self.selectedCoin.coinSymbol]["BTC"]["PRICE"].stringValue)
                
        print(coinsJson["DISPLAY"][self.selectedCoin.coinSymbol]["USD"]["MKTCAP"].stringValue)
                
                
                
                self.updateUI(coin: coin)
            }
        }
        

        
        
        
        
        
        //Thrret Alamofire me parametrat qe i jan jap funksionit
        //dhe te dhenat qe kthehen nga API te mbushin labelat
        //dhe pjeset tjera te view
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    //IBAction mbylle - per butonin te gjitha qe mbyll ekranin
    @IBAction func mbylle(_ sender: Any) {
        dismiss(animated: true, completion: nil )
    }
    
    func updateUI(coin: CoinDetailsModel){
        lblDitaLow.text = coin.dayLow
        lbl24OreLow.text = coin.hourLow
        lblCmimiBTC.text = coin.priceBTC
        lblCmimiEUR.text = coin.priceEUR
        lblCmimiUSD.text = coin.priceUSD
        lblDitaHigh.text = coin.dayHigh
        lblDitaOpen.text = coin.dayOpen
        lbl24OreHigh.text = coin.hourHigh
        lbl24OreOpen.text = coin.hourOpen
        lblMarketCap.text = coin.marketCap
        
    }
    
    
    
    @IBAction func ruaje(_ sender: Any) {
        
         let appdelegate = UIApplication.shared.delegate as! AppDelegate
        
          let context = appdelegate.persistentContainer.viewContext
        
        let RUJ = NSEntityDescription.insertNewObject(forEntityName: "RUJ", into: context)
        print(selectedCoin.imagePath)
        RUJ.setValue(selectedCoin.coinAlgo, forKey: "coinAlgo")
        RUJ.setValue(selectedCoin.coinName, forKey: "coinName")
        RUJ.setValue(selectedCoin.totalSuppy, forKey: "totalSuppy")
        RUJ.setValue(selectedCoin.imagePath, forKey: "imagePath")
        RUJ.setValue(selectedCoin.coinSymbol, forKey: "coinSymbol")
     
        do{
                try context.save()
        }catch{
            print("Kosova")
        }
    }
    
    
}

