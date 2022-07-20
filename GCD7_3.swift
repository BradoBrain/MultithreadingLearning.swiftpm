//
//  File.swift
//  MultithreadingLearning
//
//  Created by Artem Vinogradov on 20.07.2022.
//

import Foundation
import SwiftUI

struct WorkItemView: View {
    @State var image = UIImage()
    
    let imageURL = URL(string: "https://i.ytimg.com/vi/1Ne1hqOXKKI/maxresdefault.jpg")!
    
    var body: some View {
        ZStack {
            Color.teal.ignoresSafeArea()
            
            VStack {
                Spacer()
                
// One of the ways to get photo from URL  AsyncImage(url: imageURL) { $0.image?.resizable().aspectRatio(contentMode: .fit) }
                
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                
                Spacer()
                
                Button("Fetch Image") {
                    //                    fetchImageClassic()
                    //                    fetchImageWorkItem()
                    fetchImageURLSession()
                } .foregroundColor(.white)
            }
        }
    }
    // classic way
    func fetchImageClassic() {
        let queue = DispatchQueue.global(qos: .utility)
        
        queue.async {
            if let data = try? Data(contentsOf: imageURL) {
                DispatchQueue.main.async {
                    image = UIImage(data: data)!
                }
            }
        }
    }
    
    // workItem way
    func fetchImageWorkItem() {
        var data: Data?
        let queue = DispatchQueue.global(qos: .utility)
        
        let workItem = DispatchWorkItem(qos: .userInteractive) {
            data = try? Data(contentsOf: imageURL)
            print(Thread.current)
        }
        
        queue.async(execute: workItem)
        
        workItem.notify(queue: .main) {
            if let imageData = data {
                image = UIImage(data: imageData)!
            }
        }
    }
    
    // URLSession way
    func fetchImageURLSession() {
        URLSession.shared.dataTask(with: imageURL) { data, res, err in
            print(Thread.current)
            
            if let imageData = data {
                DispatchQueue.main.async {
                    image = UIImage(data: imageData)!
                }
            }
        }
        .resume()
    }
}
