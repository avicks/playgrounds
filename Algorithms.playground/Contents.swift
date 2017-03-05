//: Playground - noun: a place where people can play

import UIKit

// Linear Search
func linearSearch<T: Equatable>(array: [T], _ object: T) -> Int? {
   for (index, obj) in array.enumerated() where obj == object {
      return index
   }
   return nil
}

let array = [5, 2, 4, 7]
linearSearch(array: array, 2)