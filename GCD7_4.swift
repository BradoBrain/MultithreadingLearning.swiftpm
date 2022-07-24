//
//  File.swift
//  MultithreadingLearning
//
//  Created by Artem Vinogradov on 24.07.2022.
//

import Foundation
import SwiftUI

struct FourPicView: View {
    @State private var columns: [GridItem] = [
        GridItem(.fixed(150), spacing: 20, alignment: .center),
        GridItem(.fixed(150), spacing: 20, alignment: .center)
    ]
    @State private var imageURLs = [
        "https://nypost.com/wp-content/uploads/sites/2/2022/06/reddit-cats-judging-looks-12.jpg",
        "https://nypost.com/wp-content/uploads/sites/2/2022/06/reddit-cats-judging-looks-17.jpg",
        "https://nypost.com/wp-content/uploads/sites/2/2022/06/reddit-cats-judging-looks-14.jpg",
        "https://nypost.com/wp-content/uploads/sites/2/2022/06/reddit-cats-judging-looks-1.jpg"
    ]
    @State var picContainer = [UIImage]()
    
    
    var body: some View {
        VStack {
            LazyVGrid(columns: columns, alignment: .center, spacing: 15) {
                ForEach(picContainer, id: \.self) {
                    Image(uiImage: $0)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                }
            }
            
            Button("Get photos") { asyncGroup() }
        }
    }
    
    func asyncLoadPic(imageURL: URL, queue: DispatchQueue, completionQueue: DispatchQueue, completion: @escaping (UIImage?, Error?) -> ()) {
        queue.async {
            do {
                let data = try Data(contentsOf: imageURL)
                completionQueue.async {
                    completion(UIImage(data: data), nil)
                }
            } catch let error {
                completionQueue.async {
                    completion(nil, error)
                }
            }
        }
    }
    
    func asyncGroup() {
        let group = DispatchGroup()
        
        for pic in 0...3 {
            group.enter()
            asyncLoadPic(imageURL: URL(string: imageURLs[pic])!, queue: .global(qos: .utility), completionQueue: .main) { result, error in
                guard let image = result else { return }
                picContainer.append(image)
                
                group.leave()
            }
        }
    }
}

