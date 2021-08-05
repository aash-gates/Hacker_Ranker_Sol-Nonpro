import java.io.*
import java.math.*
import java.security.*
import java.text.*
import java.util.*
import java.util.concurrent.*
import java.util.function.*
import java.util.regex.*
import java.util.stream.*
import kotlin.collections.*
import kotlin.comparisons.*
import kotlin.io.*
import kotlin.jvm.*
import kotlin.jvm.functions.*
import kotlin.jvm.internal.*
import kotlin.ranges.*
import kotlin.sequences.*
import kotlin.text.*
    
class Circle(val c: Int, val n: Int) {
    private val pairs = ArrayList<Pair>(n)

    private val oneFourth = c / 4
    private val twoFifth = 2 * c / 5

    private var mapOfAs = IntArray(c) { 0 }
    private var mapOfBs = IntArray(c) { 0 }

    private val avgA = Avg(oneFourth)
    private val avgB = Avg(3 * c / 4)

    private fun add(pair: Pair) {
        pairs.add(pair)
        mapOfAs[pair.a]++; mapOfBs[pair.b]++
        avgA += pair.a; avgB += pair.b
    }

    private fun Array<Int>.indexOfMin(): Int {
        var r = -1
        var m = c
        for (i in this.indices) {
            if (this[i] < m) m = this[i]; r = i
        }
        return r
    }

    fun add(first: Int, second: Int) {
        val a = avgA.avg
        val b = avgB.avg
        arrayOf(dist(first, a), dist(first, b), dist(second, a), dist(second, b))
            .indexOfMin()
            .let {
                if (it == 1 || it == 2)
                    add(Pair(second, first))
                else
                    add(Pair(first, second))
            }
    }

    fun dist(first: Int, second: Int): Int = kotlin.math.abs(second - first).let { minOf(it, c - it) }

    fun dist(first: Pair, second: Pair): Int =
        arrayOf(first.a, first.b, second.a, second.b)
            .apply { sort() }
            .let { points ->
                var min = c
                for (i in 1..3) min = minOf(min, points[i] - points[i - 1])
                minOf(min, points[0] + c - points[3])
            }

    fun distantPairs(): Int {
        var rangeOfAs = Range(mapOfAs)
        var rangeOfBs = Range(mapOfBs)

        val minRange = minOf(rangeOfAs.range, rangeOfBs.range)

        if (minRange <= oneFourth) {
            if (rangeOfBs.range < rangeOfAs.range) {
                rangeOfAs = rangeOfBs.also { rangeOfBs = rangeOfAs }
                mapOfAs = mapOfBs.also { mapOfBs = mapOfAs }
                for (pair in pairs) {
                    pair.invert()
                    pair.rotate(-rangeOfAs.left)
                }
            } else {
                for (pair in pairs) pair.rotate(-rangeOfAs.left)
            }
            return solveLocalized()
        } else {
            return solveDispersed()
        }
    }

    private infix fun Int.fmod(other: Int): Int = (this % other).let { if (it < 0) it + other else it }

    private fun solveDispersed(): Int {
        pairs.sortByDescending { it.bestHope }

        val target = oneFourth

        var currentBest = dist(pairs[0], pairs[1])
        val mapOfPairs = Array<MutableSet<Circle.Pair>>(c) { mutableSetOf() }

        fun add(pair: Circle.Pair) {
            mapOfPairs[pair.a].add(pair)
            mapOfPairs[pair.b].add(pair)
        }

        add(pairs[0])
        add(pairs[1])

        for (j in 2 until pairs.size) {
            val currentPair = pairs[j]

            if (currentPair.bestHope <= currentBest) break

            val pool = mutableSetOf<Circle.Pair>()

            val a = currentPair.a
            val b = currentPair.b

            val ranges = arrayOf(
                (a + currentBest + 1)..(a + target),
                (a - target)..(a - currentBest - 1),
                (b + currentBest + 1)..(b + target),
                (b - target)..(b - currentBest - 1)
            )

            for (range in ranges)
                for (i in range)
                    pool.addAll(mapOfPairs[i fmod c])
            for (pair in pool) currentBest = maxOf(currentBest, dist(pair, currentPair))

            add(currentPair)
        }

        return currentBest
    }

    private fun solveLocalized(): Int {
        pairs.sortBy { it.a }

        var currentBest = dist(pairs.first(), pairs.last())
        val mapOfPairs = Array<MutableSet<Circle.Pair>>(c) { mutableSetOf() }

        fun add(pair: Circle.Pair) {
            mapOfPairs[pair.a].add(pair)
            mapOfPairs[pair.b].add(pair)
        }

        add(pairs.first())
        add(pairs.last())

        var flicker = true
        var left = 1
        var right = pairs.size - 2

        for (j in 1 until pairs.size - 1) {
            val currentPair = if (flicker) pairs[left++] else pairs[right--]
            val target = maxOf(
                currentPair.a - pairs.first().a,
                pairs.last().a - currentPair.a
            )
            flicker = !flicker

            if (currentBest >= target) break

            if (currentPair.bestHope <= currentBest) continue

            val pool = mutableSetOf<Circle.Pair>()

            val a = currentPair.a
            val b = currentPair.b

            val ranges = arrayOf(
                (a + currentBest + 1)..(a + target),
                (a - target)..(a - currentBest - 1),
                (b + currentBest + 1)..(b + target),
                (b - target)..(b - currentBest - 1)
            )

            for (range in ranges)
                for (i in range)
                    pool.addAll(mapOfPairs[i fmod c])
            for (pair in pool) currentBest = maxOf(currentBest, dist(pair, currentPair))

            add(currentPair)
        }

        return currentBest
    }

    inner class Pair(first: Int, second: Int) {
        val a get() = internalA
        val b get() = internalB
        private var internalA = first
        private var internalB = second

        fun invert() { internalA = internalB.also { internalB = internalA } }

        fun rotate(angle: Int) {
            internalA = (internalA + angle) fmod c
            internalB = (internalB + angle) fmod c
        }

        val dist = dist(internalA, internalB)
        val bestHope = if (dist > oneFourth) {
            if (dist <= twoFifth) (c - dist) / 3 else dist / 2
        } else dist
    }

    private class Avg(private val default: Int) {
        private var sum = 0
        private var count = 0
        val avg: Int
            get() = try {
                sum / count
            } catch (e: ArithmeticException) {
                default
            }
        operator fun plusAssign(other: Int) {
            sum += other; count++
        }
    }

    private class Range(map: IntArray) {
        val left: Int
        val right: Int
        val range: Int

        init {
            var firstStart = 0
            while (map[firstStart] == 0) ++firstStart
            var maxSpan = 1
            var maxSpanEnd = firstStart
            var lastStart = firstStart
            for (i in firstStart + 1 until map.size) {
                if (map[i] != 0) {
                    val span = i - lastStart
                    if (span > maxSpan) {
                        maxSpan = span
                        maxSpanEnd = i
                    }
                    lastStart = i
                }
            }
            val span = map.size - lastStart + firstStart
            if (span > maxSpan) {
                this.left = firstStart
                this.right = lastStart
                this.range = map.size - span
            } else {
                val dist = map.size - maxSpan
                this.left = maxSpanEnd
                this.right = (maxSpanEnd + dist).rem(map.size)
                this.range = dist
            }
        }
    }
}
    
fun main(args: Array<String>) {
    val scan = Scanner(System.`in`)
    val nc = scan.nextLine().trim().split(" ")
    val circle = Circle(
        nc[1].toInt(),
        nc[0].toInt()
    )

    repeat(circle.n) { _ ->
        scan
            .nextLine()
            .trim()
            .split(" ")
            .map { it.toInt() }
            .let { circle.add(it[0], it[1]) }
    }

    println(circle.distantPairs())
}
