//: [Previous](@previous)

import UIKit
import PlaygroundSupport

// Quality Of Service

// C
var pthread = pthread_t(bitPattern: 0)
var atrtribute = pthread_attr_t()
pthread_attr_init(&atrtribute)

pthread_attr_set_qos_class_np(&atrtribute, QOS_CLASS_USER_INITIATED, 0)

pthread_create(&pthread, &atrtribute, { pointer in
    print("Thread with QOS_CLASS_USER_INITIATED")
    pthread_set_qos_class_self_np(QOS_CLASS_BACKGROUND, 0)
    print("Thread go to QOS_CLASS_BACKGROUND")
    return nil
}, nil)


// Obj-C

var nsthread = Thread {
    print("Test QOS on Obj-C")
    print(qos_class_self())
}
nsthread.qualityOfService = .userInteractive
nsthread.start()

print(qos_class_main())


//: [Next](@next)
