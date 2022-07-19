//: [Previous](@previous)

import Foundation

// MARK: ReadWriteLock (only C), SpinLock, UnfairLock, Synchronized (Obj-C)

// ReadWriteLock

class ReadWriteLock {
    private var lock = pthread_rwlock_t()
    private var attribute = pthread_rwlockattr_t()
    
    private var globalProperty: Int = 0
    
    init() {
        pthread_rwlock_init(&lock, &attribute)
    }
    
    var workProperty: Int {
        get {
            pthread_rwlock_wrlock(&lock)
            
            let temp = globalProperty
            
            pthread_rwlock_unlock(&lock)
            
            return temp
        }
        set {
            pthread_rwlock_wrlock(&lock)
            globalProperty = newValue
            pthread_rwlock_unlock(&lock)
        }
    }
}

// SpinLock

class SpinLock {
    private var lock = OS_SPINLOCK_INIT
    
    func someFunc() {
        OSSpinLockLock(&lock)
        // do something
        OSSpinLockUnlock(&lock)
    }
}

// UnfairLock

class UnfairLock {
    private var lock = os_unfair_lock_s()
    
    var array = [Int]()
    
    func some() {
        os_unfair_lock_lock(&lock)
        array.append(1)
        os_unfair_lock_unlock(&lock)
    }
}

// Synchronized

class Synchronized {
    private let lock = NSObject()
    
    var array: [Int] = []
    
    func some() {
        objc_sync_enter(lock)
        array.append(5)
        objc_sync_exit(lock)
    }
}
//: [Next](@next)
