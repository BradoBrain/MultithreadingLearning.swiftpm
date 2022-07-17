//: [Previous](@previous)

import Foundation

// GCD, Concurrent_Serial, sync_async

class customQueue {
    private let serialQueue = DispatchQueue(label: "serial") // example own serial queue
    private let concurrentQueue = DispatchQueue(label: "concurrent", attributes: .concurrent) // example own concurrent queue
}

class systemQueue {
    private let globalQueue = DispatchQueue.global() // example system queue
    private let mainQueue = DispatchQueue.main
    
    
    // Grand Central Dispatch
    
}


//: [Next](@next)
