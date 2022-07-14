//: [Previous](@previous)

import Foundation

// NSRecursiveLock & MutexRecursiveLock - to avoid Recoursive problem


let recurciveLock = NSRecursiveLock() // If here is NSLock it will be Starvation problem


// C
class RecurciveMutexTest {
    private var mutex = pthread_mutex_t()
    private var attribute = pthread_mutexattr_t()
    
    init() {
        pthread_mutexattr_init(&attribute)
        pthread_mutexattr_settype(&attribute, PTHREAD_MUTEX_RECURSIVE)
        pthread_mutex_init(&mutex, &attribute)
    }
    
    func firstMethod() {
        pthread_mutex_lock(&mutex)
        secondMethod()
        print("Finished firstMethod")
        do {
            pthread_mutex_unlock(&mutex)
        }
    }
    
    private func secondMethod() {
        pthread_mutex_lock(&mutex)
        print("Finished secondMethod")
        do {
            pthread_mutex_unlock(&mutex)
        }
    }
}

let recursiveC = RecurciveMutexTest()
recursiveC.firstMethod()


// Obj-C
class RecursiveThread: Thread {
    override func main() {
        recurciveLock.lock()
        print("Was locked")
        anotherTask()
        do {
            recurciveLock.unlock()
        }
        print("Was unlocked and exit main()")
    }
    
    func anotherTask() {
        recurciveLock.lock()
        print("Was locked to do another task")
        do {
            recurciveLock.unlock()
        }
        print("Finished another task")
    }
}

let thread = RecursiveThread()
thread.start()
//: [Next](@next)
