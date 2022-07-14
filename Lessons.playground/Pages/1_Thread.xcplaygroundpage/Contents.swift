import UIKit
import PlaygroundSupport

// Thread

// UNIX (POSIX) thread in C

var thread = pthread_t(bitPattern: 0) // creating a thread
var attribute = pthread_attr_t()

pthread_attr_init(&attribute) // init our attribute
pthread_create(&thread, &attribute, { pointer -> UnsafeMutableRawPointer? in
    print("Test C thread")
    return nil
}, nil)

// Obj-C
var nsthead = Thread { // Block
    print("Test NSThread") // Within we have the C code
}
Thread.setThreadPriority(2)
nsthead.isFinished
nsthead.start()
nsthead.isFinished

