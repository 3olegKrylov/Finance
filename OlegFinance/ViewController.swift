//
//  ViewController.swift
//  OlegFinance
//
//  Created by 3oleg_krylov on 01.02.2020.
//  Copyright © 2020 3oleg_krylov. All rights reserved.
//

import UIKit
import SwiftCharts

func dateFromString (dateStr: String) -> NSDate? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let date = dateFormatter.date(from: dateStr)
        return date as NSDate?
    }

func stringFromDate(_ date: Date) -> String {
    let formatter = DateFormatter()
    formatter.dateFormat = "dd MMM yyyy"
    return formatter.string(from: date)
}

class Company {
    var symbol: String
    var finalArray = [momentDoubleOfDate]()
    init(symbol: String,finalArray: [momentDoubleOfDate] ){
        self.symbol = symbol
        self.finalArray = finalArray
    }
    
}




class ViewController: UIViewController {
    var chartView: BarsChart!
   
    @IBOutlet weak var chartButton: UIButton!
    @IBOutlet weak var findingTextField: UITextField!
    @IBOutlet weak var valueLabel: UILabel!
    @IBOutlet weak var tickerLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var listedCompanies = [Company]()
    var arrangeDate = [momentOfDate]()
    var sortedArray = [momentOfDate]()
    var chartViewIsOpen = false
    
   
 //MARK: ActionOfChartButton
     @IBAction func showChartButton(_ sender: Any) {
        if chartViewIsOpen == false{
        chartViewIsOpen = true
        
        var maxVal:Double = 0
        var chartArray = [(String, Double)]()
               for val in 0...sortedArray.count-1 {
                
                let coast = Double(sortedArray[val].close)
                if maxVal < coast!{
                    maxVal = coast!
                }
                   let newElement:(String, Double)
                
                   if (val == 0 || val == sortedArray.count-1){
                    newElement = (stringFromDate(sortedArray[val].key as Date), Double(sortedArray[val].close)) as! (String, Double)
                   }
                   else{
                    newElement = ("", Double(sortedArray[val].close)) as! (String, Double)
                   }
                chartArray.append(newElement)
                
               }

        let chartConfig = BarsChartConfig(
            valsAxisConfig: ChartAxisConfig(from: 0,to:maxVal+10, by:((maxVal+10) / 10) )
        )

        let frame = CGRect(x: 0, y: self.view.frame.height - (self.view.frame.height/2+50), width: self.view.frame.width-20, height: self.view.frame.height/2)

        let chart = BarsChart(
            frame: frame, chartConfig: chartConfig, xTitle: "Day", yTitle: "Value", bars: chartArray, color: UIColor.yellow, barWidth: 15

        )

        self.view.addSubview(chart.view)
        self.chartView = chart
        }

       }
    
    //MARK: ButtonOfFindingResult
    @IBAction func showResultOfFindingButton(_ sender: Any) {
        
        
        chartButton.alpha = 0
        print("button was put")
        let company: String = findingTextField.text!
        if company != ""{
        var symbols = ""
            
            activityIndicator.hidesWhenStopped = true
            activityIndicator.color = UIColor.yellow
            activityIndicator.startAnimating()
            
            UIView.animate(withDuration: 0, delay: 3, options: .curveEaseIn, animations: {self.chartButton.alpha = 1}) { (finished) in self.activityIndicator.stopAnimating()
                self.chartButton.isHidden = false
            }
            
        if chartViewIsOpen{
            view.subviews[view.subviews.count - 1].removeFromSuperview()
        }
            
            chartViewIsOpen = false
        
          let jsonUrlStringPrice = "https://www.alphavantage.co/query?function=TIME_SERIES_DAILY&symbol=ASX:"+company+"&outputsize=100&apikey=HJAY85FTIZHCS5OO"
          
             let url = URL(string: jsonUrlStringPrice)!

            URLSession.shared.dataTask(with: url){ (data, response, err) in
                        guard let data = data else {return}

                        do{
                            let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as AnyObject
                            if let information = json["Meta Data"] as? NSDictionary{
                                print(information)
                                if let symbol = information["2. Symbol"]{
                                    symbols = symbol as! String
                                    
                                }
                            }
                            
                            if let prices = json["Time Series (Daily)"] as? NSDictionary{
                                guard let priceArray = prices as? [String: AnyObject] else {return}
                                for (key, value) in priceArray{
                                    guard let open = value["1. open"] as? String else {return}
                                    guard let high = value["2. high"] as? String else {return}
                                    guard let low = value["3. low"] as? String else {return}
                                    guard let close = value["4. close"] as? String else {return}
                                    guard let volume = value["5. volume"] as? String else {return}
                                    guard let dateKey = dateFromString(dateStr: key) else {return}
                                    
                                    let thisMomet: momentOfDate = momentOfDate(key: dateKey, open: open, high: high, low: low, close: close, volume: volume)

                                    self.arrangeDate.append(thisMomet)
                                }
                            }
                            
                            self.sortedArray = self.arrangeDate.sorted(by: {left, right in
                                let leftDate = left.key
                                let rightDate = right.key
                                return leftDate.compare(rightDate as Date) == .orderedAscending
                            })
                            DispatchQueue.main.async { // Correct
                            self.nameLabel.text = symbols
                            self.tickerLabel.text = company
                            self.valueLabel.text = self.sortedArray[self.sortedArray.count - 1].close
                            }
                            
                       } catch let err{
                            print(err)
                       }
                       }.resume()
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        chartButton.isHidden = true

    }
    
   

}


