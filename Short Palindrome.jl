const BP = 1_000_000_007
function rpfs!(A)
    a = 0
    for i in endof(A):-1:1
        x = A[i]
        A[i] = a
        a = (a + x) % BP
    end
    A
end
function rduples(A, k, m)
    B = similar(A, Int32)
    a = 0
    for i in endof(A):-1:1
        x = A[i]
        B[i] = ifelse(x == m, a, 0)
        if x == k
            a += 1
        end
    end
    B
end
rests(A, k, m) = rpfs!(rduples(A, k, m))
function pals(A, k, m)
    a = 0
    s = 0
    for (i, y) in enumerate(rests(A, k, m))
        x = A[i]
        s = (s + ifelse(x == m, Int(a) * y, 0)) % BP
        x == k && (a += 1)
    end
    s
end
function pals(A)
    s = 0
    for x in UInt8('a'):UInt8('z')
        for y in UInt8('a'):UInt8('z')
             s = (s + pals(A, x, y)) % BP
        end
    end
    s
end

chomp!(A) = A.data[end] == UInt8('\n') ? deleteat!(A.data, endof(A.data)) : A.data
println(pals(chomp!(readline())))