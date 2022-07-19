//: [Previous](@previous)

import Foundation

// MARK: Synchronization & Mutex


// C mutex function
class SaveThread {
    private var mutex = pthread_mutex_t()
    
    init() {
        pthread_mutex_init(&mutex, nil)
    }
    
    func someMethod(completion: () -> ()) {
        pthread_mutex_lock(&mutex) // locking access
        completion() // do somthing what we want
        do { // to garantee that our thread will be unlocked
            pthread_mutex_unlock(&mutex) // unlocking access
        }
    }
}

var array: [String] = []
let saveThread = SaveThread()

saveThread.someMethod {
    print("Test mutex in C")
    array.append("First Thread")
}

array.append("Second Thread")
print(array)

// Obj-C mutex function
class SaveThreadObjC {
    private let lockMutex = NSLock()
    
    func anotherMethod(completion: () -> ()) {
        lockMutex.lock()
        completion()
        do {
            lockMutex.unlock()
        }
    }
}

var objCArray: [String] = []
let saveThreadObjC = SaveThreadObjC()

saveThreadObjC.anotherMethod {
    print("Test mutex in Obj-C")
    objCArray.append("First Data")
}

objCArray.append("Second Data")
print(objCArray)
//: [Next](@next)
