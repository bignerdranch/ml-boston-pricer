//
//  ViewController.swift
//  PricePredicter
//
//  Created by Matthew Mathias on 6/6/17.
//  Copyright © 2017 BigNerdRanch. All rights reserved.
//

import UIKit
import CoreML

class ViewController: UIViewController {
    
    let model = BostonPricer()
    let roomsDataSource = RoomsDataSource()
    let crimeDataSource = CrimeDataSource()
    
    let priceFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.maximumFractionDigits = 2
        formatter.usesGroupingSeparator = true
        formatter.locale = Locale(identifier: "en_US")
        return formatter
    }()
    
    @IBOutlet var picker: UIPickerView! {
        didSet {
            picker.selectRow(4, inComponent: Predictor.crime.rawValue, animated: false)
            picker.selectRow(3, inComponent: Predictor.rooms.rawValue, animated: false)
        }
    }
    
    @IBOutlet var priceLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        generatePrediction()
    }
    
    fileprivate func generatePrediction() {
        let selectedCrimeRow = picker.selectedRow(inComponent: Predictor.crime.rawValue)
        guard let crime = crimeDataSource.value(for: selectedCrimeRow) else {
            return
        }
        
        let selectedRoomRow = picker.selectedRow(inComponent: Predictor.rooms.rawValue)
        guard let rooms = roomsDataSource.value(for: selectedRoomRow) else {
            return
        }
        
        guard let modelOutput = try? model.prediction(crime: crime, rooms: rooms) else {
            fatalError("Something went wrong with generating the model output.")
        }
        
        // Estimated price is in $1k increments (Data is from 1970s...)
        priceLabel.text = priceFormatter.string(for: modelOutput.price)
    }
    
}

extension ViewController: UIPickerViewDelegate {
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        generatePrediction()
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        guard let predictor = Predictor(rawValue: component) else {
            fatalError("Could not find predictor for component.")
        }
        
        switch predictor {
        case .crime:
            return crimeDataSource.title(for: row)
        case .rooms:
            return roomsDataSource.title(for: row)
        }
    }
    
}

extension ViewController: UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        guard let predictor = Predictor(rawValue: component) else {
            fatalError("Could not find predictor for component.")
        }
        
        switch predictor {
        case .crime:
            return crimeDataSource.count
        case .rooms:
            return roomsDataSource.count
        }
    }
    
}

enum Predictor: Int {
    case crime = 0
    case rooms
}
