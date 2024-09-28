import atomics
import options
import unittest

import lockfreequeues

suite "wraparound":

  test "basic":
    var q = initSipsic[2, string]()
    check q.head.load == 0
    check q.tail.load == 0
    check not full(q.head.load, q.tail.load, q.capacity)
    check empty(q.head.load, q.tail.load, q.capacity)

    discard q.push "a"
    check q.head.load == 0
    check q.tail.load == 1
    check not full(q.head.load, q.tail.load, q.capacity)
    check not empty(q.head.load, q.tail.load, q.capacity)

    discard q.push "b"
    check q.head.load == 0
    check q.tail.load == 2
    check full(q.head.load, q.tail.load, q.capacity)
    check not empty(q.head.load, q.tail.load, q.capacity)

    check q.pop.get == "a"
    check q.head.load == 1
    check q.tail.load == 2
    check not full(q.head.load, q.tail.load, q.capacity)
    check not empty(q.head.load, q.tail.load, q.capacity)

    check q.pop.get == "b"
    check q.head.load == 2
    check q.tail.load == 2
    check not full(q.head.load, q.tail.load, q.capacity)
    check empty(q.head.load, q.tail.load, q.capacity)

    discard q.push "c"
    check q.head.load == 2
    check q.tail.load == 3
    check not full(q.head.load, q.tail.load, q.capacity)
    check not empty(q.head.load, q.tail.load, q.capacity)

    discard q.push "d"
    check q.head.load == 2
    check q.tail.load == 0
    check full(q.head.load, q.tail.load, q.capacity)
    check not empty(q.head.load, q.tail.load, q.capacity)

    check q.pop.get == "c"
    check q.head.load == 3
    check q.tail.load == 0
    check not full(q.head.load, q.tail.load, q.capacity)
    check not empty(q.head.load, q.tail.load, q.capacity)

    check q.pop.get == "d"
    check q.head.load == 0
    check q.tail.load == 0

    check not full(q.head.load, q.tail.load, q.capacity)
    check empty(q.head.load, q.tail.load, q.capacity)
