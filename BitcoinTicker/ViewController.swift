//
//  ViewController.swift
//  BitcoinTicker
//
//  Created by Angela Yu on 23/01/2016.
//  Copyright © 2016 London App Brewery. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class ViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
    let baseURL = "https://apiv2.bitcoinaverage.com/indices/global/ticker/BTC"
    let currencyArray = ["AUD", "BRL","CAD","CNY","EUR","GBP","HKD","IDR","ILS","INR","JPY","MXN","NOK","NZD","PLN","RON","RUB","SEK","SGD","USD","ZAR"]
    var finalURL = ""
    var bitcoinPrice: Double = 0

    //Pre-setup IBOutlets
    @IBOutlet weak var bitcoinPriceLabel: UILabel!
    @IBOutlet weak var currencyPicker: UIPickerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // need to show that this view will implement those delegate functions and receive data
        currencyPicker.delegate = self
        currencyPicker.dataSource = self
    }

    // Specifies the number of columns in the picker
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    // specifies the number of rows in the picker
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return currencyArray.count
    }
    
    // specifies the value of each row in the picker
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return currencyArray[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        print("selected a row! value is \(currencyArray[row])")
        finalURL = baseURL + "\(currencyArray[row])"
        getBitcoinPriceData(url: finalURL)
    }
    
    //MARK: - JSON Parsing
    /***************************************************************/
    
    func updateUIWithBitcoinPrice() {
        bitcoinPriceLabel.text = "\(bitcoinPrice)"
    }
    
    func updateBitcoinLabel(json : JSON) {
        if let bitcoinPriceData = json["ask"].double {
            bitcoinPrice = bitcoinPriceData
            updateUIWithBitcoinPrice()
        }
    }
    
    //MARK: - Networking
    /***************************************************************/
    
    func getBitcoinPriceData(url: String) {
        
        Alamofire.request(url)
            .responseJSON { response in
                if response.result.isSuccess {
                    print("Got bitcoin data! (Maybe)")
                    // exclamations force optionals to unwrap into their real values
                    // must check for existence of optional first!
                    let bitcoinJSON: JSON = JSON(response.result.value!)
                    self.updateBitcoinLabel(json: bitcoinJSON)
                } else {
                    print("Error in getting bitcoin data")
                    print(response.result.error!)
                }
        }
    }

}

