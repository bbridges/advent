(ns advent-2021.dive)

(defn final-pos
  [input]
  (reduce
    (fn [[h v] [dir x]]
      (cond
        (= dir 'forward) [(+ h x) v      ]
        (= dir 'up)      [h       (- v x)]
        (= dir 'down)    [h       (+ v x)]))
    [0 0]
    input))

(defn pos-product [[h v]] (* h v))

(defn read-input
  [stream]
  (->> (clojure.string/split-lines (slurp stream))
       (map #(clojure.string/split % #" "))
       (map (fn [[left right]] [(symbol left) (Integer/parseInt right)]))))

(-> *in* read-input final-pos pos-product println)
