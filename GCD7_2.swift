//
//  File.swift
//  MultithreadingLearning
//
//  Created by Artem Vinogradov on 19.07.2022.
//

import Foundation
import SwiftUI

struct MainView: View {
    @State var isSecondView = false
    
    var body: some View {
        NavigationView {
            VStack {
                
                Button(action: {
                    afterBlock(seconds: 5, queue: .global()) {
                        print("Hello")
                        print(Thread.current)
                    }
                    
                    isSecondView = true
                    
                }, label: {
                    Text("Go to another View")
                        .padding()
                        .foregroundColor(.white)
                        .background(
                            RoundedRectangle(cornerRadius: 20)
                                .foregroundColor(.blue))
                })
                
                NavigationLink("", destination: SecondView(), isActive: $isSecondView)
            }
            .navigationTitle("Main View")
        }
    }
    
    func afterBlock(seconds: Int, queue: DispatchQueue = DispatchQueue.global(), completion: @escaping () -> ()) {
        queue.asyncAfter(deadline: .now() + .seconds(seconds)) {
            completion()
        }
    }
    
}


struct SecondView: View {
    
    
    var body: some View {
        VStack {
            Text("Welcome to Second View")
            
            Button("How to manage threads") { inactiveQueue() }
        }
        .navigationTitle("Second View")
        .navigationBarTitleDisplayMode(.inline)
    }
    
    func inactiveQueue() {
        let inactiveQ = DispatchQueue(label: "Custom Queue", attributes: [.concurrent, .initiallyInactive])
        // .initiallyInactive get us to manage our tasks
        
        inactiveQ.async {
            print("Done")
        }
        print("Not started yet...")
        inactiveQ.activate()
        print("It is activated")
        inactiveQ.suspend()
        print("It's got sleep/pause")
        inactiveQ.resume() // our async block will start
        
    }
}
