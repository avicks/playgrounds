// Author: Alex Vickers
//  A playground to experiment with creating a LinkedList class
import UIKit

// LINKED LIST
public class LinkedListNode<T> {
   var value: T
   var next: LinkedListNode?
   weak var previous: LinkedListNode?
   
   public init(value: T) {
      self.value = value
   }
}

public class LinkedList<T> {
   public typealias Node = LinkedListNode<T>
   
   public var head: Node?
   public var tail: Node?
   
   public var isEmpty: Bool {
      return head == nil
   }
   
   public var first: Node? {
      return head
   }
   
   // we keep track of this manually..so keep that in mind !!!
   public var count: Int = 0
   
   public var last: Node? {
      
      // if we don't keep a tail pointer, we must loop to the end O(n)
      
      /*
       if var node = head {
       while case let next? = node.next {
       node = next
       }
       return node
       } else {
       return nil
       }
       */
      
      return tail
   }
   
   public func append(_ value: T) {
      let newNode = Node(value: value)
      count += 1
      
      // if there are previously existing elements, set pointers
      if let lastNode = last {
         newNode.previous = lastNode
         lastNode.next = newNode
         tail = newNode
      } else {
         // otherwise, we had an empty list. newNode is now head.
         head = newNode
         tail = newNode
      }
   }
   
   public func nodeAt(_ index: Int) -> Node? {
      
      // if index is less than 0, return nil
      if index >= 0 {
         
         
         let mid = Int(floor(Double(count/2)))
         
         // if index falls between mid point and last node, start from tail and go backwards
         if index > mid {
            
            var node = tail
            var i = count - 1
            
            while i != mid {
               if i == index { return node }
               i -= 1
               node = node!.previous
            }
         } else {
            
            var node = head
            var i = index
            
            while node != nil {
               if i == 0 {
                  return node }
               i -= 1
               node = node!.next
            }
         }
      }
      
      //print(iCount)
      return nil
   }
   
   public subscript(index: Int) -> T {
      let node = nodeAt(index)
      print(index)
      assert(node != nil)
      return node!.value
   }
   
   private func nodesBeforeAndAfter(_ index: Int) -> (Node?, Node?) {
      assert(index >= 0)
      assert(index < count)
      
      let next: Node? = nodeAt(index)
      let prev: Node?
      
      if(index == 0) {
         prev = nil
      } else {
         prev = next?.previous
      }
      
      return (prev, next)
   }
   
   public func insert(value: T, atIndex index: Int) {
      
      // get our nodes
      let (prev, next) = nodesBeforeAndAfter(index)
      
      let newNode = Node(value: value)
      newNode.previous = prev
      newNode.next = next
      prev?.next = newNode
      next?.previous = newNode
      
      if prev == nil {
         head = newNode
      }
      
      if next == nil {
         tail = newNode
      }
      
      count += 1
   }
   
   public func removeAll() {
      head = nil
      tail = nil
      count = 0
   }
   
   public func remove(node: Node) -> T {
      let prev = node.previous
      let next = node.next
      
      if let prev = prev {
         prev.next = next
      } else {
         head = next
      }
      
      if let next = next {
         next.previous = prev
      } else {
         tail = prev
      }
      
      node.previous = nil
      node.next = nil
      count -= 1
      return node.value
   }
   
   public func removeAt(_ index: Int) -> T {
      let node = nodeAt(index)
      assert(node != nil)
      return remove(node: node!)
   }
   
   public func reverse() {
      var node = head
      while let currentNode = node {
         node = currentNode.next
         swap(&currentNode.next, &currentNode.previous)
         head = currentNode
      }
   }
   
   public func map<U>(transform: (T) -> U) -> LinkedList<U> {
      let result = LinkedList<U>()
      var node = head
      while node != nil {
         result.append(transform(node!.value))
         node = node!.next
      }
      return result
   }
   
   public func filter(predicate: (T) -> Bool) -> LinkedList<T> {
      let result = LinkedList<T>()
      var node = head
      while node != nil {
         if predicate(node!.value) {
            result.append(node!.value)
         }
         node = node!.next
      }
      return result
   }
}

extension LinkedList: CustomStringConvertible {
   public var description: String {
      var s = "["
      var node = head
      while node != nil {
         s += "\(node!.value)"
         node = node!.next
         if node != nil { s += ", " }
      }
      return s + "]"
   }
}

// a queue based off of the LinkedList, which makes dequeueing a O(1) operation, instead of O(n) w/ an array
//   yes there are ways around this when using an array, but I find using LinkedLists to be simpler overall..
public struct Queue<T> {
   fileprivate var list = LinkedList<T>()
   
   public var isEmpty : Bool {
      return list.isEmpty
   }
   
   public var count : Int {
      return list.count
   }
   
   // append an element to the queue
   public mutating func enqueue(_ element : T) {
      list.append(element)
   }
   
   // return the first element in the queue, removing it from the queue
   public mutating func dequeue() -> T? {
      if isEmpty {
         return nil
      } else {
         return list.removeAt(0)
      }
   }
   
   // just take a peek at the first element, don't remove
   public func peek() -> T? {
      if isEmpty {
         return nil
      } else {
         return list[0]
      }
   }
}

// a stack based on LinkedList implementation.
public struct Stack<T> {
   fileprivate var list = LinkedList<T>()
   
   public var isEmpty : Bool {
      return list.isEmpty
   }
   
   public var count : Int {
      return list.count
   }
   
   // append element to end of stack
   public mutating func push(_ element: T) {
      list.append(element)
   }
   
   // return and remove the last element of the list
   public mutating func pop() -> T? {
      if isEmpty {
         return nil
      } else {
         return list.removeAt(count-1)
      }
   }
   
}

let list = LinkedList<String>()
list.isEmpty   // true
list.first     // nil

list.append("Hello")


list.append("World")


list.append("Yes")
list.append("No")
list.append("Hi")

list.insert(value: "Temporary", atIndex: 0)
list.insert(value: "Complex", atIndex: 4)
list.count

list.removeAt(0)

print(list)
list.reverse()
print(list)
list.reverse()
print(list)

let m = list.map { s in s.characters.count }
print(m)

let f = list.filter { s in s.characters.count > 5 }
print(f)
