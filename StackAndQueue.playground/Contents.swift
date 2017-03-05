//: Playground - noun: a place where people can play

import UIKit

// Stack
public struct Stack<T> {
   fileprivate var array = [T]()
   
   public var isEmpty : Bool {
      return array.isEmpty
   }
   
   public var count : Int {
      return array.count
   }
   
   public mutating func push(_ element: T) {
      array.append(element)
   }
   
   public mutating func pop() -> T? {
      return array.popLast()
   }
   
   public var top: T? {
      return array.last
   }
}

var stack = Stack<Int>()
stack.push(10)
stack.isEmpty
stack.top
stack.pop()
stack.isEmpty


// QUEUE
public struct Queue<T> {
   fileprivate var array = [T?]()
   fileprivate var head = 0
   
   public var isEmpty : Bool {
      return count == 0
   }
   
   public var count : Int {
      return array.count - head
   }
   
   public mutating func enqueue(_ element: T) {
      array.append(element)
   }
   
   public mutating func dequeue() -> T? {
      guard head < array.count, let element = array[head] else { return nil }
      
      array[head] = nil
      head += 1
      
      let percentage = Double(head)/Double(array.count)
      if array.count > 50 && percentage > 0.25 {
         array.removeFirst(head)
         head = 0
      }
      
      return element
   }
   
   public var front: T? {
      if isEmpty {
         return nil
      } else {
         return array[head]
      }
   }
}



