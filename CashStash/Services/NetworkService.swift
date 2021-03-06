//
//  NetworkService.swift
//  CashStash
//
//  Created by Dmitry Kononov on 1.04.22.
//

import Foundation

class NetworkService {
    
    private let host = "https://api.getgeoapi.com/v2/currency/convert"
    private let key = "?api_key=eeb545b0fdd02a95387e2e3a547f62762b74b0d3"
    private func exchange(from currency: String) -> String {
       return "&from=\(currency)"
    }
    private func exchange(to currency: String) -> String {
        return "&to=\(currency)"
    }
    private func exchange(amount: Double) -> String {
        return "&amount=\(String(amount))"
    }

    private func excangeCurrency(from: String, to: String, amount: Double) -> String {
        let urlStr = host + key + exchange(from: from) + exchange(to: to) + exchange(amount: amount) + "&format=json"
        return urlStr
    }


    func getRateToUSD(to: String, complition: @escaping (Double) -> Void) {
        guard let url = URL(string: excangeCurrency(from: CurrencyList.USD.rawValue, to: to, amount: 1)) else {return}
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        URLSession.shared.dataTask(with: request) { data, responce, error in
            if let error = error {
                print(error.localizedDescription)
                if let rate: Double = UserDefaults.standard.object(forKey: to) as? Double {
                    complition(rate)
                }
            } else if let data = data {
                if let exchange = try? JSONDecoder().decode(ExcangeModel.self, from: data) {
                    if let rate =  exchange.rates[to]?.rate.double() {
                        DispatchQueue.main.async {
                            UserDefaults.standard.set(rate, forKey: to)
                            complition(rate)
                        }
                    }
                }
            }
        }.resume()
    }
    
    func getRate(_ top: String, to bot: String, complition: @escaping (Double) -> Void) {
        guard let url = URL(string: excangeCurrency(from: top, to: bot, amount: 1)) else {return}
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        URLSession.shared.dataTask(with: request) { data, responce, error in
            if let error = error {
                print(error.localizedDescription)
                if let rate: Double = UserDefaults.standard.object(forKey: top + bot) as? Double {
                    complition(rate)
                }
            } else if let data = data {
                if let result = try? JSONDecoder().decode(ExcangeModel.self, from: data) {
                   if  let rate = result.rates[bot]?.rate.double() {
                       DispatchQueue.main.async {
                           UserDefaults.standard.set(rate, forKey: top + bot)
                           complition(rate)
                       }
                    }
                }
            }

            
        }.resume()
    }
    
    
}


