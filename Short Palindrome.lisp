(defconstant +alphabet-size+ #.(- (char-code #\z) (char-code #\a) -1) )
(defmacro ord (a) `(- (char-code ,a) #.(char-code #\a)))

(let ((data (read-line))
      (result 0)
      (freqs (make-array #.+alphabet-size+ :element-type 'fixnum :initial-element 0))
      (partial-freqs (make-array #.+alphabet-size+ :element-type 'fixnum :initial-element 0))
      (pairs (make-array `(,#.+alphabet-size+ ,#.+alphabet-size+) :element-type 'fixnum :initial-element 0)))
  (loop 
     for idx from 1
     for c of-type character across data 
     for code := (ord c)
     do (incf (aref freqs code)))
  (loop 
     for idx from 1
     for c of-type character across data 
     for code := (ord c)
     do (incf (aref partial-freqs code))
        (dotimes (other +alphabet-size+) 
            (incf result (* (aref pairs other code) 
                            (- (aref freqs other) (aref partial-freqs other))))
            (setf result (mod result 1000000007))
            (incf (aref pairs other code) (aref partial-freqs other))
            (when (= other code) (decf (aref pairs other code)))))
  (write result))
   

