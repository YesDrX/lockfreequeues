# lockfreequeues
# © Copyright 2020 Elijah Shaw-Rutschman
#
# See the file "LICENSE", included in this distribution for details about the
# copyright.

## A multi-producer, single-consumer bounded queue implemented as a ring buffer.

import atomics
import options
import sugar

import ./ops
import ./sipsic


const NoProducerIdx* = -1


type NoProducersAvailableDefect* = object of Defect
type InvalidCallDefect* = object of Defect


type
  Mupsic*[N, P: static int, T] = object of Sipsic[N, T]
    ## A multi-producer, single-consumer bounded queue implemented as a ring
    ## buffer.
    ##
    ## * `N` is the capacity of the queue.
    ## * `P` is the number of producer threads.
    ## * `T` is the type of data the queue will hold.

    prevProducerIdx*: Atomic[int] ## The ID (index) of the most recent producer
    producerTails*: array[P, Atomic[int]] ## Array of producer tails
    producerThreadIds*: array[P, Atomic[int]] ## \
      ## Array of producer thread IDs by index

  Producer*[N, P: static int, T] = object
    idx*: int
    queue*: ptr Mupsic[N, P, T]


proc clear[N, P: static int, T](
  self: var Mupsic[N, P, T]
) =
  self.head.release(0)
  self.tail.release(0)

  for n in 0..<N:
    self.storage[n].reset()

  self.prevProducerIdx.release(NoProducerIdx)
  for p in 0..<P:
    self.producerTails[p].release(0)
    self.producerThreadIds[p].release(0)


proc initMupsic*[N, P: static int, T](): Mupsic[N, P, T] =
  ## Initialize a new Mupsic queue.
  result.clear()


proc getProducer*[N, P: static int, T](
  self: var Mupsic[N, P, T],
  idx: int = NoProducerIdx,
): Producer[N, P, T]
  {.raises: [NoProducersAvailableDefect].} =
  result.queue = addr(self)

  if idx >= 0:
    result.idx = idx
    return

  let threadId = getThreadId()

  # Try to find existing mapping of threadId -> producerIdx
  for idx in 0..<P:
    if self.producerThreadIds[idx].relaxed == threadId:
      result.idx = idx
      return

  # Try to create new mapping of threadId -> producerIdx
  for idx in 0..<P:
    var expected = 0
    if self.producerThreadIds[idx].compareExchangeWeak(
      expected,
      threadId,
      moRelease,
      moRelaxed,
    ):
      result.idx = idx
      return

  # Producers are all spoken for by another thread
  raise newException(
    NoProducersAvailableDefect,
    "All producers have been assigned")


proc push*[N, P: static int, T](
  self: Producer[N, P, T],
  item: T,
): bool =
  ## Append a single item to the queue.
  ## If the queue is full, `false` is returned.
  ## If `item` is appended, `true` is returned.

  var prevTail: int
  var newTail: int
  var prevProducerIdx: int
  var isFirstProduction: bool

  # spin until reservation is acquired
  while true:
    prevProducerIdx = self.queue.prevProducerIdx.acquire
    isFirstProduction = prevProducerIdx == NoProducerIdx
    var head = self.queue.head.acquire
    prevTail =
      if isFirstProduction:
        0
      else:
        self.queue.producerTails[prevProducerIdx].acquire

    if unlikely(full(head, prevTail, N)):
      return false

    newTail = incOrReset(prevTail, 1, N)
    self.queue.producerTails[self.idx].release(newTail)

    if self.queue.prevProducerIdx.compareExchangeWeak(
      prevProducerIdx,
      self.idx,
      moAcquire,
      moRelaxed,
    ):
      break
    cpuRelax()

  result = true

  self.queue.storage[index(prevTail, N)] = item

  # Wait for prev producer to update tail, then update tail
  if not isFirstProduction:
    while true:
      var expectedTail = prevTail
      if self.queue.tail.compareExchangeWeak(
        expectedTail,
        newTail,
        moAcquire,
        moRelaxed,
      ):
        break
      cpuRelax()
  else:
    self.queue.tail.release(newTail)


proc push*[N, P: static int, T](
  self: Producer[N, P, T],
  items: openArray[T],
): Option[HSlice[int, int]] =
  ## Append multiple items to the queue.
  ## If the queue is already full or is filled by this call, `some(unpushed)`
  ## is returned, where `unpushed` is an `HSlice` corresponding to the
  ## chunk of items which could not be pushed.
  ## If all items are appended, `none(HSlice[int, int])` is returned.
  if unlikely(items.len == 0):
    # items is empty, nothing unpushed
    return NoSlice

  var count: int
  var avail: int
  var prevTail: int
  var newTail: int
  var prevProducerIdx: int
  var isFirstProduction: bool

  # spin until reservation is acquired
  while true:
    prevProducerIdx = self.queue.prevProducerIdx.acquire
    isFirstProduction = prevProducerIdx == NoProducerIdx
    var head = self.queue.head.acquire
    prevTail =
      if isFirstProduction:
        0
      else:
        self.queue.producerTails[prevProducerIdx].acquire

    avail = available(head, prevTail, N)
    if likely(avail >= items.len):
      # enough room to push all items
      count = items.len
    else:
      if avail == 0:
        # Queue is full, return
        return some(0..items.len - 1)
      else:
        # not enough room to push all items
        count = avail

    newTail = incOrReset(prevTail, count, N)
    self.queue.producerTails[self.idx].release(newTail)

    if self.queue.prevProducerIdx.compareExchangeWeak(
      prevProducerIdx,
      self.idx,
      moAcquire,
      moRelaxed,
    ):
      break
    cpuRelax()

  if count < items.len:
    # give back remainder
    result = some(avail..items.len - 1)
  else:
    result = NoSlice

  let start = index(prevTail, N)
  var stop = index((prevTail + count) - 1, N)

  if start > stop:
    # data may wrap
    let pivot = (N-1) - start
    self.queue.storage[start..start+pivot] = items[0..pivot]
    if stop > 0:
      # data wraps
      self.queue.storage[0..stop] = items[pivot+1..pivot+1+stop]
  else:
    # data does not wrap
    self.queue.storage[start..stop] = items[0..stop-start]

  # Wait for prev producer to update tail, then update tail
  if not isFirstProduction:
    while true:
      var expectedTail = prevTail
      if self.queue.tail.compareExchangeWeak(
        expectedTail,
        newTail,
        moAcquire,
        moRelaxed,
      ):
        break
      cpuRelax()

  elif isFirstProduction:
    self.queue.tail.release(newTail)


proc push*[N, P: static int, T](
  self: var Mupsic[N, P, T],
  item: T,
): bool
  {.raises: [InvalidCallDefect].} =
  # Overload Sipsic.push() to ensure pushes go through a producer.
  raise newException(InvalidCallDefect, "Use Producer.push()")


proc push*[N, P: static int, T](
  self: var Mupsic[N, P, T],
  items: openArray[T],
): Option[HSlice[int, int]]
  {.raises: [InvalidCallDefect].} =
  # Overload Sipsic.push() to ensure pushes go through a producer.
  raise newException(InvalidCallDefect, "Use Producer.push()")


proc capacity*[N, P: static int, T](
  self: var Mupsic[N, P, T],
): int
  {.inline.} =
  ## Returns the queue's storage capacity (`N`).
  result = N


proc producerCount*[N, P: static int, T](
  self: var Mupsic[N, P, T],
): int
  {.inline.} =
  ## Returns the queue's number of producers (`P`).
  result = P

when defined(testing):
  from unittest import check

  proc reset*[N, P: static int, T](
    self: var Mupsic[N, P, T]
  ) =
    ## Resets the queue to its default state.
    ## Probably only useful in single-threaded unit tests.
    self.clear()

  proc checkState*[N, P: static int, T](
    self: var Mupsic[N, P, T],
    prevProducerIdx: int,
    producerTails: seq[int],
  ) =
    let tails = collect(newSeq):
      for p in 0..<P:
        self.producerTails[p].acquire
    check(self.prevProducerIdx.acquire == prevProducerIdx)
    check(tails == producerTails)
