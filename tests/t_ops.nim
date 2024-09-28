# lockfreequeues
# © Copyright 2020 Elijah Shaw-Rutschman
#
# See the file "LICENSE", included in this distribution for details about the
# copyright.

import unittest

import lockfreequeues/ops


when (NimMajor, NimMinor) < (1, 3):
  type AssertionDefect = AssertionError

suite "validateHeadAndTail(head, tail, 4)":

  test "valid":
    check(validateHeadAndTail(0, 0, 4) == true)
    check(validateHeadAndTail(0, 1, 4) == true)
    check(validateHeadAndTail(0, 2, 4) == true)
    check(validateHeadAndTail(0, 3, 4) == true)
    check(validateHeadAndTail(0, 4, 4) == true)
    check(validateHeadAndTail(1, 1, 4) == true)
    check(validateHeadAndTail(1, 2, 4) == true)
    check(validateHeadAndTail(1, 3, 4) == true)
    check(validateHeadAndTail(1, 4, 4) == true)
    check(validateHeadAndTail(1, 5, 4) == true)
    check(validateHeadAndTail(2, 2, 4) == true)
    check(validateHeadAndTail(2, 3, 4) == true)
    check(validateHeadAndTail(2, 4, 4) == true)
    check(validateHeadAndTail(2, 5, 4) == true)
    check(validateHeadAndTail(2, 6, 4) == true)
    check(validateHeadAndTail(3, 3, 4) == true)
    check(validateHeadAndTail(3, 4, 4) == true)
    check(validateHeadAndTail(3, 5, 4) == true)
    check(validateHeadAndTail(3, 6, 4) == true)
    check(validateHeadAndTail(3, 7, 4) == true)
    check(validateHeadAndTail(4, 0, 4) == true)
    check(validateHeadAndTail(4, 4, 4) == true)
    check(validateHeadAndTail(4, 5, 4) == true)
    check(validateHeadAndTail(4, 6, 4) == true)
    check(validateHeadAndTail(4, 7, 4) == true)
    check(validateHeadAndTail(5, 0, 4) == true)
    check(validateHeadAndTail(5, 1, 4) == true)
    check(validateHeadAndTail(5, 5, 4) == true)
    check(validateHeadAndTail(5, 6, 4) == true)
    check(validateHeadAndTail(5, 7, 4) == true)
    check(validateHeadAndTail(6, 0, 4) == true)
    check(validateHeadAndTail(6, 1, 4) == true)
    check(validateHeadAndTail(6, 2, 4) == true)
    check(validateHeadAndTail(6, 6, 4) == true)
    check(validateHeadAndTail(6, 7, 4) == true)
    check(validateHeadAndTail(7, 0, 4) == true)
    check(validateHeadAndTail(7, 1, 4) == true)
    check(validateHeadAndTail(7, 2, 4) == true)
    check(validateHeadAndTail(7, 3, 4) == true)
    check(validateHeadAndTail(7, 7, 4) == true)

  test "invalid":
    check(validateHeadAndTail(0, 5, 4) == false)
    check(validateHeadAndTail(0, 6, 4) == false)
    check(validateHeadAndTail(0, 7, 4) == false)
    check(validateHeadAndTail(1, 0, 4) == false)
    check(validateHeadAndTail(1, 6, 4) == false)
    check(validateHeadAndTail(1, 7, 4) == false)
    check(validateHeadAndTail(2, 0, 4) == false)
    check(validateHeadAndTail(2, 1, 4) == false)
    check(validateHeadAndTail(2, 7, 4) == false)
    check(validateHeadAndTail(3, 0, 4) == false)
    check(validateHeadAndTail(3, 1, 4) == false)
    check(validateHeadAndTail(3, 2, 4) == false)
    check(validateHeadAndTail(4, 1, 4) == false)
    check(validateHeadAndTail(4, 2, 4) == false)
    check(validateHeadAndTail(4, 3, 4) == false)
    check(validateHeadAndTail(5, 2, 4) == false)
    check(validateHeadAndTail(5, 3, 4) == false)
    check(validateHeadAndTail(5, 4, 4) == false)
    check(validateHeadAndTail(6, 3, 4) == false)
    check(validateHeadAndTail(6, 4, 4) == false)
    check(validateHeadAndTail(6, 5, 4) == false)
    check(validateHeadAndTail(7, 4, 4) == false)
    check(validateHeadAndTail(7, 5, 4) == false)
    check(validateHeadAndTail(7, 6, 4) == false)

suite "validateHeadOrTail(headOrTail, 4)":

  test "valid":
    check(validateHeadOrTail(0, 4) == true)
    check(validateHeadOrTail(1, 4) == true)
    check(validateHeadOrTail(2, 4) == true)
    check(validateHeadOrTail(3, 4) == true)
    check(validateHeadOrTail(4, 4) == true)
    check(validateHeadOrTail(5, 4) == true)
    check(validateHeadOrTail(6, 4) == true)
    check(validateHeadOrTail(7, 4) == true)

  test "invalid":
    check(validateHeadOrTail(-1, 4) == false)
    check(validateHeadOrTail(8, 4) == false)
    check(validateHeadOrTail(9, 4) == false)
    check(validateHeadOrTail(-2, 4) == false)

suite "index(value, 4)":

  test "all":
    check(index(0, 4) == 0)
    check(index(1, 4) == 1)
    check(index(2, 4) == 2)
    check(index(3, 4) == 3)
    check(index(4, 4) == 0)
    check(index(5, 4) == 1)
    check(index(6, 4) == 2)
    check(index(7, 4) == 3)

suite "incOrReset(original, amount, 4)":
  test "valid":
    check(incOrReset(0, 0, 4) == 0)
    check(incOrReset(0, 1, 4) == 1)
    check(incOrReset(0, 2, 4) == 2)
    check(incOrReset(0, 3, 4) == 3)
    check(incOrReset(0, 4, 4) == 4)
    check(incOrReset(1, 0, 4) == 1)
    check(incOrReset(1, 1, 4) == 2)
    check(incOrReset(1, 2, 4) == 3)
    check(incOrReset(1, 3, 4) == 4)
    check(incOrReset(1, 4, 4) == 5)
    check(incOrReset(2, 0, 4) == 2)
    check(incOrReset(2, 1, 4) == 3)
    check(incOrReset(2, 2, 4) == 4)
    check(incOrReset(2, 3, 4) == 5)
    check(incOrReset(2, 4, 4) == 6)
    check(incOrReset(3, 0, 4) == 3)
    check(incOrReset(3, 1, 4) == 4)
    check(incOrReset(3, 2, 4) == 5)
    check(incOrReset(3, 3, 4) == 6)
    check(incOrReset(3, 4, 4) == 7)
    check(incOrReset(4, 0, 4) == 4)
    check(incOrReset(4, 1, 4) == 5)
    check(incOrReset(4, 2, 4) == 6)
    check(incOrReset(4, 3, 4) == 7)
    check(incOrReset(4, 4, 4) == 0)
    check(incOrReset(5, 0, 4) == 5)
    check(incOrReset(5, 1, 4) == 6)
    check(incOrReset(5, 2, 4) == 7)
    check(incOrReset(5, 3, 4) == 0)
    check(incOrReset(5, 4, 4) == 1)
    check(incOrReset(6, 0, 4) == 6)
    check(incOrReset(6, 1, 4) == 7)
    check(incOrReset(6, 2, 4) == 0)
    check(incOrReset(6, 3, 4) == 1)
    check(incOrReset(6, 4, 4) == 2)
    check(incOrReset(7, 0, 4) == 7)
    check(incOrReset(7, 1, 4) == 0)
    check(incOrReset(7, 2, 4) == 1)
    check(incOrReset(7, 3, 4) == 2)
    check(incOrReset(7, 4, 4) == 3)

  test "invalid":
    expect(AssertionDefect):
      discard incOrReset(0, 5, 4)
    expect(AssertionDefect):
      discard incOrReset(0, 6, 4)
    expect(AssertionDefect):
      discard incOrReset(0, 7, 4)
    expect(AssertionDefect):
      discard incOrReset(1, 5, 4)
    expect(AssertionDefect):
      discard incOrReset(1, 6, 4)
    expect(AssertionDefect):
      discard incOrReset(1, 7, 4)
    expect(AssertionDefect):
      discard incOrReset(2, 5, 4)
    expect(AssertionDefect):
      discard incOrReset(2, 6, 4)
    expect(AssertionDefect):
      discard incOrReset(2, 7, 4)
    expect(AssertionDefect):
      discard incOrReset(3, 5, 4)
    expect(AssertionDefect):
      discard incOrReset(3, 6, 4)
    expect(AssertionDefect):
      discard incOrReset(3, 7, 4)
    expect(AssertionDefect):
      discard incOrReset(4, 5, 4)
    expect(AssertionDefect):
      discard incOrReset(4, 6, 4)
    expect(AssertionDefect):
      discard incOrReset(4, 7, 4)
    expect(AssertionDefect):
      discard incOrReset(5, 5, 4)
    expect(AssertionDefect):
      discard incOrReset(5, 6, 4)
    expect(AssertionDefect):
      discard incOrReset(5, 7, 4)
    expect(AssertionDefect):
      discard incOrReset(6, 5, 4)
    expect(AssertionDefect):
      discard incOrReset(6, 6, 4)
    expect(AssertionDefect):
      discard incOrReset(6, 7, 4)
    expect(AssertionDefect):
      discard incOrReset(7, 5, 4)
    expect(AssertionDefect):
      discard incOrReset(7, 6, 4)
    expect(AssertionDefect):
      discard incOrReset(7, 7, 4)


suite "used(head, tail, 4)":
  test "valid":
    check(used(0, 0, 4) == 0)
    check(used(0, 1, 4) == 1)
    check(used(0, 2, 4) == 2)
    check(used(0, 3, 4) == 3)
    check(used(0, 4, 4) == 4)
    check(used(1, 1, 4) == 0)
    check(used(1, 2, 4) == 1)
    check(used(1, 3, 4) == 2)
    check(used(1, 4, 4) == 3)
    check(used(1, 5, 4) == 4)
    check(used(2, 2, 4) == 0)
    check(used(2, 3, 4) == 1)
    check(used(2, 4, 4) == 2)
    check(used(2, 5, 4) == 3)
    check(used(2, 6, 4) == 4)
    check(used(3, 3, 4) == 0)
    check(used(3, 4, 4) == 1)
    check(used(3, 5, 4) == 2)
    check(used(3, 6, 4) == 3)
    check(used(3, 7, 4) == 4)
    check(used(4, 0, 4) == 4)
    check(used(4, 4, 4) == 0)
    check(used(4, 5, 4) == 1)
    check(used(4, 6, 4) == 2)
    check(used(4, 7, 4) == 3)
    check(used(5, 0, 4) == 3)
    check(used(5, 1, 4) == 4)
    check(used(5, 5, 4) == 0)
    check(used(5, 6, 4) == 1)
    check(used(5, 7, 4) == 2)
    check(used(6, 0, 4) == 2)
    check(used(6, 1, 4) == 3)
    check(used(6, 2, 4) == 4)
    check(used(6, 6, 4) == 0)
    check(used(6, 7, 4) == 1)
    check(used(7, 0, 4) == 1)
    check(used(7, 1, 4) == 2)
    check(used(7, 2, 4) == 3)
    check(used(7, 3, 4) == 4)
    check(used(7, 7, 4) == 0)

  test "invalid":
    expect(AssertionDefect):
      discard used(0, 5, 4)
    expect(AssertionDefect):
      discard used(0, 6, 4)
    expect(AssertionDefect):
      discard used(0, 7, 4)
    expect(AssertionDefect):
      discard used(1, 0, 4)
    expect(AssertionDefect):
      discard used(1, 6, 4)
    expect(AssertionDefect):
      discard used(1, 7, 4)
    expect(AssertionDefect):
      discard used(2, 0, 4)
    expect(AssertionDefect):
      discard used(2, 1, 4)
    expect(AssertionDefect):
      discard used(2, 7, 4)
    expect(AssertionDefect):
      discard used(3, 0, 4)
    expect(AssertionDefect):
      discard used(3, 1, 4)
    expect(AssertionDefect):
      discard used(3, 2, 4)
    expect(AssertionDefect):
      discard used(4, 1, 4)
    expect(AssertionDefect):
      discard used(4, 2, 4)
    expect(AssertionDefect):
      discard used(4, 3, 4)
    expect(AssertionDefect):
      discard used(5, 2, 4)
    expect(AssertionDefect):
      discard used(5, 3, 4)
    expect(AssertionDefect):
      discard used(5, 4, 4)
    expect(AssertionDefect):
      discard used(6, 3, 4)
    expect(AssertionDefect):
      discard used(6, 4, 4)
    expect(AssertionDefect):
      discard used(6, 5, 4)
    expect(AssertionDefect):
      discard used(7, 4, 4)
    expect(AssertionDefect):
      discard used(7, 5, 4)
    expect(AssertionDefect):
      discard used(7, 6, 4)

suite "available(head, tail, 4)":
  test "valid":
    check(available(0, 0, 4) == 4)
    check(available(0, 1, 4) == 3)
    check(available(0, 2, 4) == 2)
    check(available(0, 3, 4) == 1)
    check(available(0, 4, 4) == 0)
    check(available(1, 1, 4) == 4)
    check(available(1, 2, 4) == 3)
    check(available(1, 3, 4) == 2)
    check(available(1, 4, 4) == 1)
    check(available(1, 5, 4) == 0)
    check(available(2, 2, 4) == 4)
    check(available(2, 3, 4) == 3)
    check(available(2, 4, 4) == 2)
    check(available(2, 5, 4) == 1)
    check(available(2, 6, 4) == 0)
    check(available(3, 3, 4) == 4)
    check(available(3, 4, 4) == 3)
    check(available(3, 5, 4) == 2)
    check(available(3, 6, 4) == 1)
    check(available(3, 7, 4) == 0)
    check(available(4, 0, 4) == 0)
    check(available(4, 4, 4) == 4)
    check(available(4, 5, 4) == 3)
    check(available(4, 6, 4) == 2)
    check(available(4, 7, 4) == 1)
    check(available(5, 0, 4) == 1)
    check(available(5, 1, 4) == 0)
    check(available(5, 5, 4) == 4)
    check(available(5, 6, 4) == 3)
    check(available(5, 7, 4) == 2)
    check(available(6, 0, 4) == 2)
    check(available(6, 1, 4) == 1)
    check(available(6, 2, 4) == 0)
    check(available(6, 6, 4) == 4)
    check(available(6, 7, 4) == 3)
    check(available(7, 0, 4) == 3)
    check(available(7, 1, 4) == 2)
    check(available(7, 2, 4) == 1)
    check(available(7, 3, 4) == 0)
    check(available(7, 7, 4) == 4)

  test "invalid":
    expect(AssertionDefect):
      discard available(0, 5, 4)
    expect(AssertionDefect):
      discard available(0, 6, 4)
    expect(AssertionDefect):
      discard available(0, 7, 4)
    expect(AssertionDefect):
      discard available(1, 0, 4)
    expect(AssertionDefect):
      discard available(1, 6, 4)
    expect(AssertionDefect):
      discard available(1, 7, 4)
    expect(AssertionDefect):
      discard available(2, 0, 4)
    expect(AssertionDefect):
      discard available(2, 1, 4)
    expect(AssertionDefect):
      discard available(2, 7, 4)
    expect(AssertionDefect):
      discard available(3, 0, 4)
    expect(AssertionDefect):
      discard available(3, 1, 4)
    expect(AssertionDefect):
      discard available(3, 2, 4)
    expect(AssertionDefect):
      discard available(4, 1, 4)
    expect(AssertionDefect):
      discard available(4, 2, 4)
    expect(AssertionDefect):
      discard available(4, 3, 4)
    expect(AssertionDefect):
      discard available(5, 2, 4)
    expect(AssertionDefect):
      discard available(5, 3, 4)
    expect(AssertionDefect):
      discard available(5, 4, 4)
    expect(AssertionDefect):
      discard available(6, 3, 4)
    expect(AssertionDefect):
      discard available(6, 4, 4)
    expect(AssertionDefect):
      discard available(6, 5, 4)
    expect(AssertionDefect):
      discard available(7, 4, 4)
    expect(AssertionDefect):
      discard available(7, 5, 4)
    expect(AssertionDefect):
      discard available(7, 6, 4)

suite "full(head, tail, 4)":
  test "valid":
    check(full(0, 0, 4) == false)
    check(full(0, 1, 4) == false)
    check(full(0, 2, 4) == false)
    check(full(0, 3, 4) == false)
    check(full(0, 4, 4) == true)
    check(full(1, 1, 4) == false)
    check(full(1, 2, 4) == false)
    check(full(1, 3, 4) == false)
    check(full(1, 4, 4) == false)
    check(full(1, 5, 4) == true)
    check(full(2, 2, 4) == false)
    check(full(2, 3, 4) == false)
    check(full(2, 4, 4) == false)
    check(full(2, 5, 4) == false)
    check(full(2, 6, 4) == true)
    check(full(3, 3, 4) == false)
    check(full(3, 4, 4) == false)
    check(full(3, 5, 4) == false)
    check(full(3, 6, 4) == false)
    check(full(3, 7, 4) == true)
    check(full(4, 0, 4) == true)
    check(full(4, 4, 4) == false)
    check(full(4, 5, 4) == false)
    check(full(4, 6, 4) == false)
    check(full(4, 7, 4) == false)
    check(full(5, 0, 4) == false)
    check(full(5, 1, 4) == true)
    check(full(5, 5, 4) == false)
    check(full(5, 6, 4) == false)
    check(full(5, 7, 4) == false)
    check(full(6, 0, 4) == false)
    check(full(6, 1, 4) == false)
    check(full(6, 2, 4) == true)
    check(full(6, 6, 4) == false)
    check(full(6, 7, 4) == false)
    check(full(7, 0, 4) == false)
    check(full(7, 1, 4) == false)
    check(full(7, 2, 4) == false)
    check(full(7, 3, 4) == true)
    check(full(7, 7, 4) == false)

  test "invalid":
    expect(AssertionDefect):
      discard full(0, 5, 4)
    expect(AssertionDefect):
      discard full(0, 6, 4)
    expect(AssertionDefect):
      discard full(0, 7, 4)
    expect(AssertionDefect):
      discard full(1, 0, 4)
    expect(AssertionDefect):
      discard full(1, 6, 4)
    expect(AssertionDefect):
      discard full(1, 7, 4)
    expect(AssertionDefect):
      discard full(2, 0, 4)
    expect(AssertionDefect):
      discard full(2, 1, 4)
    expect(AssertionDefect):
      discard full(2, 7, 4)
    expect(AssertionDefect):
      discard full(3, 0, 4)
    expect(AssertionDefect):
      discard full(3, 1, 4)
    expect(AssertionDefect):
      discard full(3, 2, 4)
    expect(AssertionDefect):
      discard full(4, 1, 4)
    expect(AssertionDefect):
      discard full(4, 2, 4)
    expect(AssertionDefect):
      discard full(4, 3, 4)
    expect(AssertionDefect):
      discard full(5, 2, 4)
    expect(AssertionDefect):
      discard full(5, 3, 4)
    expect(AssertionDefect):
      discard full(5, 4, 4)
    expect(AssertionDefect):
      discard full(6, 3, 4)
    expect(AssertionDefect):
      discard full(6, 4, 4)
    expect(AssertionDefect):
      discard full(6, 5, 4)
    expect(AssertionDefect):
      discard full(7, 4, 4)
    expect(AssertionDefect):
      discard full(7, 5, 4)
    expect(AssertionDefect):
      discard full(7, 6, 4)

suite "empty(head, tail, 4)":
  test "valid":
    check(empty(0, 0, 4) == true)
    check(empty(0, 1, 4) == false)
    check(empty(0, 2, 4) == false)
    check(empty(0, 3, 4) == false)
    check(empty(0, 4, 4) == false)
    check(empty(1, 1, 4) == true)
    check(empty(1, 2, 4) == false)
    check(empty(1, 3, 4) == false)
    check(empty(1, 4, 4) == false)
    check(empty(1, 5, 4) == false)
    check(empty(2, 2, 4) == true)
    check(empty(2, 3, 4) == false)
    check(empty(2, 4, 4) == false)
    check(empty(2, 5, 4) == false)
    check(empty(2, 6, 4) == false)
    check(empty(3, 3, 4) == true)
    check(empty(3, 4, 4) == false)
    check(empty(3, 5, 4) == false)
    check(empty(3, 6, 4) == false)
    check(empty(3, 7, 4) == false)
    check(empty(4, 0, 4) == false)
    check(empty(4, 4, 4) == true)
    check(empty(4, 5, 4) == false)
    check(empty(4, 6, 4) == false)
    check(empty(4, 7, 4) == false)
    check(empty(5, 0, 4) == false)
    check(empty(5, 1, 4) == false)
    check(empty(5, 5, 4) == true)
    check(empty(5, 6, 4) == false)
    check(empty(5, 7, 4) == false)
    check(empty(6, 0, 4) == false)
    check(empty(6, 1, 4) == false)
    check(empty(6, 2, 4) == false)
    check(empty(6, 6, 4) == true)
    check(empty(6, 7, 4) == false)
    check(empty(7, 0, 4) == false)
    check(empty(7, 1, 4) == false)
    check(empty(7, 2, 4) == false)
    check(empty(7, 3, 4) == false)
    check(empty(7, 7, 4) == true)

  test "invalid":
    expect(AssertionDefect):
      discard empty(0, 5, 4)
    expect(AssertionDefect):
      discard empty(0, 6, 4)
    expect(AssertionDefect):
      discard empty(0, 7, 4)
    expect(AssertionDefect):
      discard empty(1, 0, 4)
    expect(AssertionDefect):
      discard empty(1, 6, 4)
    expect(AssertionDefect):
      discard empty(1, 7, 4)
    expect(AssertionDefect):
      discard empty(2, 0, 4)
    expect(AssertionDefect):
      discard empty(2, 1, 4)
    expect(AssertionDefect):
      discard empty(2, 7, 4)
    expect(AssertionDefect):
      discard empty(3, 0, 4)
    expect(AssertionDefect):
      discard empty(3, 1, 4)
    expect(AssertionDefect):
      discard empty(3, 2, 4)
    expect(AssertionDefect):
      discard empty(4, 1, 4)
    expect(AssertionDefect):
      discard empty(4, 2, 4)
    expect(AssertionDefect):
      discard empty(4, 3, 4)
    expect(AssertionDefect):
      discard empty(5, 2, 4)
    expect(AssertionDefect):
      discard empty(5, 3, 4)
    expect(AssertionDefect):
      discard empty(5, 4, 4)
    expect(AssertionDefect):
      discard empty(6, 3, 4)
    expect(AssertionDefect):
      discard empty(6, 4, 4)
    expect(AssertionDefect):
      discard empty(6, 5, 4)
    expect(AssertionDefect):
      discard empty(7, 4, 4)
    expect(AssertionDefect):
      discard empty(7, 5, 4)
    expect(AssertionDefect):
      discard empty(7, 6, 4)
