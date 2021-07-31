(ns connected-cells
  (:import (java.util Scanner)))

(defn get-neighbors [[i j]]
  (for [f [identity dec inc]
        g [identity dec inc]
        :when (not= f g identity)]
    [(f i)
     (g j)]))

(defn lookup [arr t1 t2]
  (= (get-in arr t1)
     (get-in arr t2)))

(defn flood-fill
  ([arr target]
   (loop [q (conj (clojure.lang.PersistentQueue/EMPTY) target)
          visited #{}]
     (if (empty? q)
       visited
       (let [c   (peek q)
             unv (->> c
                      get-neighbors
                      (remove visited)
                      (filter #(lookup arr target %)))]
         (recur (pop (into q unv))
                (conj visited c)))))))

(defn find-max-region
  ([arr m n]
   (reduce (fn [[mx visited] t]
             (if (or (not= (get-in arr t) 1) (visited t))
               [mx visited]
               (let [v (flood-fill arr t)]
                 [(max mx (count v))
                  (into visited v)])))
           [0 #{}]
           (for [i (range m)
                 j (range n)]
             [i j])))
  ([arr]
   (find-max-region arr (count arr) (count (arr 0)))))

(defn -main []
  (let [scan (Scanner. *in*)
        m (.nextInt scan)
        n (.nextInt scan)
        vv (doall (mapv (fn [_] (mapv
                                 (fn [_] (.nextInt scan))
                                 (range n)))
                        (range m)))]
    (println (first (find-max-region vv)))))

(-main)
