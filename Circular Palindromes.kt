import java.io.*
import java.math.*
import java.text.*
import java.util.*
import java.util.regex.*
import kotlin.math.min



/**
 * for each index, try expanding and find the palindrome centered at that (Manachers)
 *
 * let c be the center, R the right edge of the palindrome found
 *
 * for the next index within the right edge, find the mirror left of center
 *
 * p[i] is Min of P[mirror], distance to right edge
 * only need to expand from current index beyond p[i]
 *
 * Returns the max size palindromes of each rotated strings
 *
 * (modifieid manachers) -- first compress the input
 * rotate using the compressed input
 */
fun getPalindromSizes(input: String): Array<Int> {
    val inputLength = input.length
    val rotatedSizes = Array(input.length) { 0 }

    //compress the repeated chars
    val compressedSizes = ArrayList<Int>()
    val compressedInput = ArrayList<Char>()
    val paddedString = StringBuilder()


    var first = 0
    compressedSizes.add(0)
    paddedString.append('#')
    while (first < input.length) {
        var second = first + 1
        while (second < input.length && input[first] == input[second]) {
            second++
        }
        compressedInput.add(input[first])
        paddedString.append(input[first])
        compressedSizes.add(second - first)

        paddedString.append('#')
        compressedSizes.add(0)
        first = second
    }
    val fold = input.length > 1000 && compressedInput.size > input.length / 4

    //for each rotation, find the max
    var rotationIndex = 0
    while (rotationIndex < rotatedSizes.size) {

        var center = 0
        var right = 0
        var index = 1
        var max = 0
        var palindromeExistAtEnd = false
        var originalIndex = 0
        var maxStartIndex = 0

        val palindromSizes = Array(paddedString.length) { 0 }

        while (index < paddedString.length) {

            //find the mirror of this index
            val mirror = center - (index - center)

            //if index is less than the right edge, pSize of this index is min of mirror or distance to right
            if (index < right) {
                palindromSizes[index] = min(palindromSizes[mirror], right - index)
            }


            //expand beyond the above pSize for this index
            while ((index + palindromSizes[index]) < palindromSizes.size - 1
                && (index - palindromSizes[index] - 1) >= 0
                && paddedString[index + palindromSizes[index] + 1] == paddedString[index - palindromSizes[index] - 1]
            ) {
                if (compressedSizes[index + palindromSizes[index] + 1] != compressedSizes[index - palindromSizes[index] - 1]) {
                    palindromSizes[index]++
                    break
                } else {
                    palindromSizes[index]++
                }
            }


            //move center and right of pSize moved beyond current right
            if (index + palindromSizes[index] > right) {
                center = index
                right = palindromSizes[index]
            }

            var score = compressedSizes[index]
            for (range in 1..palindromSizes[index]) {
                score += (2 * Math.min(compressedSizes[index + range], compressedSizes[index - range]))
            }

            if (max < score) {
                max = score
                maxStartIndex = originalIndex - (max - compressedSizes[index]) / 2
            }

            if (compressedSizes[index] > 0) {
                originalIndex += compressedSizes[index]
            }
            val endIndex = originalIndex + (score - compressedSizes[index]) / 2

            if (!palindromeExistAtEnd && score > 1 && endIndex == inputLength) {
                palindromeExistAtEnd = true
            }

            index++
        }

        rotatedSizes[rotationIndex] = max

        if (rotationIndex < rotatedSizes.size - 1) {

            var charsToRotate = 1

            if (fold) {
                val firstChar = paddedString[1]
                val secondChar = if (inputLength > 1) {
                    if (compressedSizes[1] == 1)
                        firstChar else paddedString[1]
                } else '.'
                val lastChar = paddedString[paddedString.length - 2]
                val secondLastChar = if (inputLength > 1) {
                    if (compressedSizes[paddedString.length - 2] == 1)
                        lastChar else paddedString[paddedString.length - 4]
                } else '_'

                if (palindromeExistAtEnd || firstChar == lastChar || firstChar == secondLastChar || secondChar == secondLastChar) {
                    charsToRotate = 1
                } else if (maxStartIndex > 0) {
                    charsToRotate = maxStartIndex

                    for (skipIndex in 1..maxStartIndex) {
                        if (rotationIndex + skipIndex >= rotatedSizes.size) {
                            break
                        } else {
                            rotatedSizes[rotationIndex + skipIndex] = max
                        }
                    }
                    rotationIndex += maxStartIndex

                    if (rotationIndex >= rotatedSizes.size) {
                        break
                    }
                    compressedInput.clear()
                    compressedSizes.clear()
                    paddedString.clear()


                    var skipIndex = maxStartIndex
                    var skipTotal = 0
                    compressedSizes.add(0)
                    paddedString.append('#')
                    while (skipTotal < inputLength) {
                        var second = skipIndex + 1
                        while (skipTotal < skipTotal++ && input[skipIndex % inputLength] == input[second % inputLength]) {
                            second++
                            skipTotal++
                        }
                        compressedInput.add(input[skipIndex % inputLength])
                        paddedString.append(input[skipIndex % inputLength])
                        compressedSizes.add(second - skipIndex)

                        paddedString.append('#')
                        compressedSizes.add(0)
                        skipIndex = second
                    }

                } else {
                    charsToRotate = 1
                }

            } else {
                charsToRotate = 1
            }

            if (charsToRotate == 1) {
                rotationIndex++
                val firstChar = paddedString[1]
                val lastChar = paddedString[paddedString.length - 2]

                //if first is repeated, just reduce the count
                if (compressedSizes[1] > 1) {
                    compressedSizes[1]--
                } else {
                    //if not remove
                    compressedSizes.removeAt(0)
                    compressedSizes.removeAt(0)

                    //paddedString = StringBuilder(paddedString.removeRange(0, 2))
                    paddedString.delete(0, 2)
                }

                //if last is same as first, just increase count
                if (lastChar == firstChar) {
                    compressedSizes[compressedSizes.size - 2]++
                } else {
                    //if not add
                    compressedSizes.add(1)
                    compressedSizes.add(0)
                    paddedString.append(firstChar)
                    paddedString.append("#")
                }
            }
        } else {
            rotationIndex++
        }

    }

    return rotatedSizes

}


/**
 * Returns array of max palindromes after each rotation
 */
fun circularPalindromes(input: String): Array<Int> {
    return getPalindromSizes(input)
}


fun main(args: Array<String>) {
    val scan = Scanner(System.`in`)

    val n = scan.nextLine().trim().toInt()

    val s = scan.nextLine()

    val result = circularPalindromes(s)

    println(result.joinToString("\n"))
}
