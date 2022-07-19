//: [Previous](@previous)

import Foundation

// MARK: NSCondition

// C
var available = false

var condition = pthread_cond_t()
var mutex = pthread_mutex_t()

class ConditionCPrint: Thread {
    
    override init() {
        pthread_cond_init(&condition, nil)
        pthread_mutex_init(&mutex, nil)
    }
    
    override func main() {
        printMethod()
    }
    
    private func printMethod() {
        pthread_mutex_lock(&mutex)
        print("Enter to print")
        while !available {
            print("Start print")
            pthread_cond_wait(&condition, &mutex)
            print("Finish print")
        }
        available = false
        print("Condition is false")
        
        do {
            pthread_mutex_unlock(&mutex)
        }
        print("Exit from print")
    }
}


class ConditionCWrite: Thread {
    override init() {
        pthread_cond_init(&condition, nil)
        pthread_mutex_init(&mutex, nil)
    }
    
    override func main() {
        writeMethod()
    }
    
    private func writeMethod() {
        pthread_mutex_lock(&mutex)
        print("Enter to write")
        
        available = true
        print("Condition is true")
        
        pthread_cond_signal(&condition) // Give the signal to wait()
        print("Send the signal")
        
        do {
            pthread_mutex_unlock(&mutex)
        }
        print("Exit from write")
    }
}

let conditionCPrint = ConditionCPrint()
let conditionCWrite = ConditionCWrite()

conditionCPrint.start()
conditionCWrite.start()

//  NSCondition

let nsCondition = NSCondition()
var isAvailable = false

class NSPrint: Thread {
    override func main() {
        nsCondition.lock()
        print("NS Enter to print")
        
        while !isAvailable {
            print("NS Start print")
            nsCondition.wait()
            print("NS Finish print")
        }
        
        isAvailable = false
        print("NS Condition is false")
        
        do {
            nsCondition.unlock()
        }
        print("NS Exit from print")
    }
}

class NSWrite: Thread {
    override func main() {
        nsCondition.lock()
        print("NS Enter to write")
        
        isAvailable = true
        print("NS Condition is true")
        
        nsCondition.signal()
        print("NS Send the signal")
        
        
        do {
            print("NS Exit from write")
            nsCondition.unlock()
        }
        
    }
}

let nsPrint = NSPrint()
let nsWrite = NSWrite()

nsPrint.start()
nsWrite.start()

//: [Next](@next)
