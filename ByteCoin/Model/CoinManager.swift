
import Foundation



protocol CoinManagerDelegate {
    func didUpdatePrice(price: String, currency: String)
    func didFailWithError(error: Error)
}







struct CoinManager {
    
    var delegate: CoinManagerDelegate?
    
    
    
    let baseURL = "https://rest.coinapi.io/v1/exchangerate/BTC"
    let apiKey = "Your API key comes here"
    
    let currencyArray = ["AUD", "BRL","CAD","CNY","EUR","GBP","HKD","IDR","ILS","INR","JPY","MXN","NOK","NZD","PLN","RON","RUB","SEK","SGD","USD","ZAR"]

    
    func getCoinPrice(for currency: String){
     let urlString = "\(baseURL)/\(currency)?apikey=\(apiKey)"

        //MARK: - 1. Creating a URL
        if let url = URL(string: urlString) {
            //MARK: - 2. Creating a URLSession
            let session = URLSession(configuration: .default)//The thing that perform networking
           
            //MARK: - 3. Give URLSession a task
            let task = session.dataTask(with: url) { (data, response, error) in
               //MARK: - handleing the errors, Encoding the data, making it readable
                if error != nil {
                    self.delegate?.didFailWithError(error: error!)
                    return // exit this func dont continue
                }
              
              
                if let safeData = data {
                    if let bitcoinPrice = self.parseJSON(safeData) {
                        let priceString = String(format: "%.2f", bitcoinPrice)
                            self.delegate?.didUpdatePrice(price: priceString, currency: currency)
                    }
                }
            }
            
            //MARK: - Start the task
            task.resume()
            
        }
 
    }
    
    //MARK: - parse jason method
    func parseJSON(_ coinData: Data) -> Double?{
        //MARK: - 1. inform our compiler how data is structured
        let decoder = JSONDecoder()
        
        do{
        
            let decodedData = try decoder.decode(CoinData.self, from: coinData)
            print(decodedData.rate)
            
            
            let lastPrice = decodedData.rate
            print(lastPrice)
            return lastPrice
        
        }catch{
            
            delegate?.didFailWithError(error: error)
            return nil
        }
        
    }
  
    
}
