//: [Previous](@previous)

import Foundation
import PlaygroundSupport
import UIKit

PlaygroundPage.current.needsIndefiniteExecution = true

// MARK: GCD, Concurrent_Serial, sync_async

class customQueue {
    private let serialQueue = DispatchQueue(label: "serial") // example own serial queue
    private let concurrentQueue = DispatchQueue(label: "concurrent", attributes: .concurrent) // example own concurrent queue
}

class systemQueue {
    private let globalQueue = DispatchQueue.global() // example system queue
    private let mainQueue = DispatchQueue.main
}


// MARK: GCD
// First step: Set a thread DispatchQueue.global(), DispatchQueue.main
// Second step:
// Hight priority   DispatchQueue.global(qos: .userInteractive), (qos: .userInitiated), (qos: .utility)
// Low priority     DispatchQueue.global(qos: .background)
// Default          DispatchQueue.global()
// Third Step: .sync/.async

class FirstViewController: UIViewController {
    
    var button = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "VC 1"
        view.backgroundColor = UIColor.white
        button.addTarget(self, action: #selector(press), for: .touchUpInside)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        initButton()
    }
    
    @objc func press() {
        print("Pressed")
        let vc = SecondViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func initButton() {
        button.frame = CGRect(x: 0, y: 0, width: 200, height: 50)
        button.center = view.center
        button.setTitle("Push me", for: .normal)
        button.backgroundColor = UIColor.green
        button.layer.cornerRadius = 20
        button.setTitleColor(UIColor.white, for: .normal)
        view.addSubview(button)
    }
}

class SecondViewController: UIViewController {
    
    var image = UIImageView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "VC 2"
        view.backgroundColor = UIColor.white
        
        
        getPhoto()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        initImage()
    }
    
    func initImage() {
        image.frame = CGRect(x: 0, y: 0, width: 200, height: 200)
        image.center = view.center
        view.addSubview(image)
    }
    
    func getPhoto() {
        let imageURL = URL(string: "https://i.ytimg.com/vi/1Ne1hqOXKKI/maxresdefault.jpg")!
        DispatchQueue.global(qos: .utility).async {
            if let data = try? Data(contentsOf: imageURL) {
                DispatchQueue.main.async {
                    self.image.image = UIImage(data: data)
                }
            }
        }
    }
}


let vc = FirstViewController()
let navBar = UINavigationController(rootViewController: vc)
navBar.view.frame = CGRect(x: 10, y: 10, width: 300, height: 500)

PlaygroundPage.current.liveView = navBar

// Also look at GSD7_2

// MARK: WorkItem in GCD

class DispatchWorkItemOne {
    private let queue = DispatchQueue(label: "DispatchWorkItemOne", attributes: .concurrent)
    
    func create() {
        let workItem = DispatchWorkItem {
            print(Thread.current)
            print("Start task")
        }
        
        workItem.notify(queue: .main) {
            print(Thread.current)
            print("Finish task")
        }
        
        queue.async(execute: workItem)
    }
}

let dispatchWorkItemOne = DispatchWorkItemOne()
dispatchWorkItemOne.create()

class DispatchWorkItemTwo {
    private let queue = DispatchQueue(label: "DispatchWorkItemTwo") // Default attribute value is .serial
    
    func create() {
        queue.async {
            sleep(3)
            print("Task 1")
        }
        
        queue.async {
            sleep(5)
            print("Task 2")
        }
        
        let workItem = DispatchWorkItem {
            print(Thread.current)
            print("Start workItem's task")
        }
        
        queue.async(execute: workItem)
        
        
        workItem.cancel() // it cancel workItem block if it is not started
    }
}

let dispatchWorkItemTwo = DispatchWorkItemTwo()
dispatchWorkItemTwo.create()

// Also look at GCD7_3

// MARK: Semaphore

let cuncurrentQueue = DispatchQueue(label: "Semaphore Thread", attributes: .concurrent)

let semaphore = DispatchSemaphore(value: 1)
cuncurrentQueue.async {
    semaphore.wait() // it make value: 2 - 1
    sleep(3)
    print("Perform a method 1")
    semaphore.signal()
}

cuncurrentQueue.async {
    semaphore.wait()
    sleep(3)
    print("Perform a method 2")
    semaphore.signal()
}

cuncurrentQueue.async {
    semaphore.wait()
    sleep(3)
    print("Perform a method 3")
    semaphore.signal()
}

let anotherSemaphore = DispatchSemaphore(value: 1)

DispatchQueue.concurrentPerform(iterations: 11) { (num: Int) in
    anotherSemaphore.wait(timeout: .distantFuture)
    sleep(2)
    print("Iteration number is \(num)")
    anotherSemaphore.signal()
}



class SemaphorClass {
    private let semaphoreClass = DispatchSemaphore(value: 2)
    private var array = [Int]()

    private func semaphoreMethod(id: Int) {
        semaphoreClass.wait()
        
        array.append(id)
        print(array.count)
        Thread.sleep(forTimeInterval: 3)
        semaphoreClass.signal()
    }
    
    func startAllThread() {
        DispatchQueue.global().async {
            self.semaphoreMethod(id: 222)
            print(Thread.current)
        }
        
        DispatchQueue.global().async {
            self.semaphoreMethod(id: 555)
            print(Thread.current)
        }
        
        DispatchQueue.global().async {
            self.semaphoreMethod(id: 777)
            print(Thread.current)
        }
    }
}

let semaphoreClass = SemaphorClass()
semaphoreClass.startAllThread()

// MARK: DispatchGroup

class DispatchGroupTestSerial {
    private let queue = DispatchQueue(label: "Serial Queue")
    
    private let redGroup = DispatchGroup()
    
    func groupMethod() {
        queue.async(group: redGroup) {
            sleep(2)
            print("Serial Group Task 1")
        }
        
        queue.async(group: redGroup) {
            sleep(2)
            print("Serial Group Task 2")
        }
        
        redGroup.notify(queue: .main) {
            print("Serial Group is finished the work")
        }
    }
}

let dispatchGroupTest = DispatchGroupTestSerial()
dispatchGroupTest.groupMethod()

class DispatchGroupTestConcurrent {
    private let queue = DispatchQueue(label: "Serial Queue", attributes: .concurrent)
    
    private let greenGroup = DispatchGroup()
    
    func groupMethod() {
 
        greenGroup.enter()
        queue.async {
            sleep(1)
            print("Concurrent Group Task 1")
            self.greenGroup.leave()
        }
        
        greenGroup.enter()
        queue.async {
            sleep(1)
            print("Concurrent Group Task 2")
            self.greenGroup.leave()
        }
        
        greenGroup.wait()
        
        print("All was finished")
        
        greenGroup.notify(queue: .main) {
            print("Concurrent Group is finished")
        }
    }
}

let dispatchGroupTestConcurrent = DispatchGroupTestConcurrent()
dispatchGroupTestConcurrent.groupMethod()

// Also look at GCD7_4



//: [Next](@next)
