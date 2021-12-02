(ns advent-2021.dive-two)

(defn final-pos
  [input]
  (let [[h v _]
        (reduce
          (fn [[h v aim] [dir x]]
            (cond
              (= dir 'forward) [(+ h x) (+ v (* aim x)) aim      ]
              (= dir 'up)      [h       v               (- aim x)]
              (= dir 'down)    [h       v               (+ aim x)]))
          [0 0 0]
          input)]
    [h v]))

(defn pos-product [[h v]] (* h v))

(defn read-input
  [stream]
  (->> (clojure.string/split-lines (slurp stream))
       (map #(clojure.string/split % #" "))
       (map (fn [[left right]] [(symbol left) (Integer/parseInt right)]))))

(-> *in* read-input final-pos pos-product println)
