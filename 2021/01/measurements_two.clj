(ns advent-2021.measurements-two)

(defn window-sums
  [input]
  (map #(reduce + %) (partition 3 1 input)))

(defn count-increases
  [input]
  (->> input
       (partition 2 1)
       (filter (fn [[left right]] (> right left)))
       count))

(defn read-input
  [stream]
  (let [raw (clojure.string/trim (slurp stream))]
       (map #(Integer/parseInt %) (clojure.string/split-lines raw))))

(-> *in* read-input window-sums count-increases println)
