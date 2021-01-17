//
//  ContentView.swift
//  Shared
//
//  Created by Benoit on 17/01/2021.
//

import SwiftUI
import AVKit

struct ContentView: View {
    
    @State var bpi: Bpi? = nil
    @State private var isRotated = false
    
    static var player: AVAudioPlayer!

    var animation: Animation {
        Animation.easeOut
    }
    
    var body: some View {
        VStack {
            Image("bitcoin")
                .resizable()
                .frame(width: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/, height: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                .rotationEffect(Angle.degrees(isRotated ? 360 : 0))
                .animation(animation)
            
            
            if let _ = self.bpi {
                Text("$\((bpi?.usd.rateFloat)!, specifier: "%.2f")")
                    .padding()
            } else {
                Text("Loading...")
                    .padding()
            }
            
            Button(action: {
                self.loadData()
            }) {
                Text("Refresh me")
            }
        }
        .onAppear {
            self.loadData()
        }
    }
    
    func loadData() {
        let request = URLRequest(url: URL(string: "https://api.coindesk.com/v1/bpi/currentprice.json")!)
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data {
                let str = String(decoding: data, as: UTF8.self)
                print(str)
                
                do {
                    let decoded = try JSONDecoder().decode(Response.self, from: data)
                    print(decoded)
                } catch {
                    print(error)
                }
                
                if let decodedResponse = try? JSONDecoder().decode(Response.self, from: data) {
                    DispatchQueue.main.async {
                        self.bpi = decodedResponse.bpi
                        
                        self.playSound()
                        self.rotateBitcoinImage()
                    }
                    
                    return
                }
            }
            
            print("Fetch failed: \(error?.localizedDescription ?? "Unknown error")")
        }.resume()
        
    }
    
    func playSound() {
        guard let url = Bundle.main.url(forResource: "money", withExtension: "wav") else { return
        }

        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)
            
            ContentView.player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.wav.rawValue)
            
            guard let player = ContentView.player else {
                return
            }
            player.prepareToPlay()
            player.play()
            
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    func rotateBitcoinImage() {
        self.isRotated.toggle()
    }
    
}

struct ContentView_Previews: PreviewProvider {
    
    static var previews: some View {
        let dollars = Eur(code: "USD", symbol: "&#36;", rate: "35,735.9533", eurDescription: "United States Dollar", rateFloat: 35735.9533)
        
        let britishPounds = Eur(code: "GBP", symbol: "&pound;", rate: "26,298.6598", eurDescription: "British Pound Sterling", rateFloat: 26298.6598)
        
        let euros = Eur(code: "EUR", symbol: "&euro;", rate: "29,583.9732", eurDescription: "Euro", rateFloat: 29583.9732)
        
        ContentView(bpi: Bpi(usd: dollars, gbp: britishPounds, eur: euros))
    }
}
