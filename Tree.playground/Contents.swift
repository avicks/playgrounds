// Tree.playground
// Author: Alex Vickers
// Meant for experimentation with Tree data structures

import UIKit

// A TreeNode contains it's value of type T, 
//   a weak reference to it's parent TreeNode (if it exists), 
//   and an array of child TreeNodes
public class TreeNode<T> {
   public var value : T
   
   public weak var parent : TreeNode?
   public var children = [TreeNode<T>]()
   
   public init(value: T) {
      self.value = value
   }
   
   public func addChild(_ node : TreeNode<T>) {
      children.append(node)
      node.parent = self
   }
}

// extension to be able to print the values of a TreeNode
extension TreeNode: CustomStringConvertible {
   public var description: String {
      var s = "\(value)"
      if !children.isEmpty {
         s += " {" + children.map { $0.description }.joined(separator: ", ") + "}"
      }
      return s
   }
}

extension TreeNode where T: Equatable {
   
   // first compare value of node, then recursively check the children.
   //  finally, if nothing turns up, return nil
   func search(_ value: T) -> TreeNode? {
      if value == self.value {
         return self
      }
      for child in children {
         if let found = child.search(value) {
            return found
         }
      }
      return nil
   }
}

let tree = TreeNode<String>(value: "beverages")

let hotNode = TreeNode<String>(value: "hot")
let coldNode = TreeNode<String>(value: "cold")

let teaNode = TreeNode<String>(value: "tea")
let coffeeNode = TreeNode<String>(value: "coffee")
let chocolateNode = TreeNode<String>(value: "cocoa")

let blackTeaNode = TreeNode<String>(value: "black")
let greenTeaNode = TreeNode<String>(value: "green")
let chaiTeaNode = TreeNode<String>(value: "chai")

let sodaNode = TreeNode<String>(value: "soda")
let milkNode = TreeNode<String>(value: "milk")

let gingerAleNode = TreeNode<String>(value: "ginger ale")
let bitterLemonNode = TreeNode<String>(value: "bitter lemon")

tree.addChild(hotNode)
tree.addChild(coldNode)

hotNode.addChild(teaNode)
hotNode.addChild(coffeeNode)
hotNode.addChild(chocolateNode)

coldNode.addChild(sodaNode)
coldNode.addChild(milkNode)

teaNode.addChild(blackTeaNode)
teaNode.addChild(greenTeaNode)
teaNode.addChild(chaiTeaNode)

sodaNode.addChild(gingerAleNode)
sodaNode.addChild(bitterLemonNode)

print(tree)

tree.search("cocoa")    // returns the "cocoa" node
tree.search("chai")     // returns the "chai" node
tree.search("bubbly")   // nil

public class BinarySearchTree<T: Comparable> {
   private(set) public var value : T
   private(set) public var parent : BinarySearchTree?
   private(set) public var left : BinarySearchTree?
   private(set) public var right : BinarySearchTree?

   public init(value: T) {
      self.value = value
   }
   
   public var isRoot : Bool {
      return parent == nil
   }
   
   public var isLeaf: Bool {
      return left == nil && right == nil
   }
   
   public var isLeftChild: Bool {
      return parent?.left === self
   }
   
   public var isRightChild: Bool {
      return parent?.right === self
   }
   
   public var hasLeftChild : Bool {
      return left != nil
   }
   
   public var hasRightChild : Bool {
      return right != nil
   }
   
   public var hasAnyChild : Bool {
      return hasRightChild || hasLeftChild
   }
   
   public var hasBothChildren : Bool {
      return hasLeftChild && hasRightChild
   }
   
   public var count : Int {
      return (left?.count ?? 0) + 1 + (right?.count ?? 0)
   }
   
   public func insert(_ value: T) {
      if value < self.value {
         if let left = left {
            left.insert(value)
         } else {
            left = BinarySearchTree(value: value)
            left?.parent = self
         }
      } else {
         if let right = right {
            right.insert(value)
         } else {
            right = BinarySearchTree(value: value)
            right?.parent = self
         }
      }
   }
   
   public convenience init(array: [T]) {
      precondition(array.count > 0)
      self.init(value: array.first!)
      for v in array.dropFirst() {
         insert(v)
      }
   }
   
   public func search(value: T) -> BinarySearchTree? {
      if value < self.value {
         return self.left?.search(value: value)
      } else if value > self.value {
         return self.right?.search(value: value)
      } else {
         return self
      }
   }
   
   public func traverseInOrder(process: (T) -> Void) {
      left?.traverseInOrder(process: process)
      process(value)
      right?.traverseInOrder(process: process)
   }
   
   public func traversePreOrder(process: (T) -> Void) {
      process(value)
      left?.traversePreOrder(process: process)
      right?.traversePreOrder(process: process)
   }
   
   public func traversePostOrder(process: (T) -> Void) {
      left?.traversePostOrder(process: process)
      right?.traversePostOrder(process: process)
      process(value)
   }
   
   public func map(formula: (T) -> T) -> [T] {
      var a = [T]()
      if let left = left { a += left.map(formula: formula) }
      a.append(formula(value))
      if let right = right { a += right.map(formula: formula) }
      return a
   }
   
   public func filter(formula: (T) -> Bool) -> [T] {
      var a = [T]()
      if let left = left { a += left.filter(formula: formula) }
      
      if(formula(value)) {
         a.append(value)
      }
      if let right = right { a += right.filter(formula: formula) }
      return a
   }
   
   
   public func reduce(initialValue : T, formula: (T, T) -> T) -> T {
      var a = initialValue
      if let left = left { a = left.reduce(initialValue: a, formula: formula) }
      a = formula(a, self.value)
      if let right = right { a = right.reduce(initialValue: a, formula: formula) }
      return a
   }
   
   public func toArray() -> [T] {
      return map { $0 }
   }
   
   private func reconnectParentToNode(node: BinarySearchTree?) {
      if let parent = parent {
         if isLeftChild {
            parent.left = node
         } else {
            parent.right = node
         }
      }
      node?.parent = parent
   }
   
   public func minimum() -> BinarySearchTree {
      var node = self
      while case let next? = node.left {
         node = next
      }
      return node
   }
   
   public func maximum() -> BinarySearchTree {
      var node = self
      while case let next? = node.right {
         node = next
      }
      return node
   }

   
   public func delete() -> BinarySearchTree? {
      
   }
}

extension BinarySearchTree: CustomStringConvertible {
   public var description: String {
      var s = ""
      if let left = left {
         s += "(\(left.description)) <- "
      }
      s += "\(value)"
      if let right = right {
         s += " -> (\(right.description))"
      }
      return s
   }
}

let bTree = BinarySearchTree<Int>(value: 7)
bTree.insert(2)
bTree.insert(5)
bTree.insert(10)
bTree.insert(9)
bTree.insert(1)
bTree.insert(5)


bTree.search(value: 5)

bTree.toArray()

var newTree = bTree.filter() { $0 > 5 }
print(newTree)

var reduced = bTree.reduce(initialValue: 1) { $0 * $1 }
print(reduced)
