(ns advent-2021.basin
  (:require [clojure.string :as str]))

(defn sum-risk
  [input]
  (let [height (count input)
        width (count (first input))]
    (->> input
         (map-indexed (fn [i line]
                        (map-indexed (fn [j val] (vector i j val)) line)))
         (reduce #(into %1 %2))
         (filter (fn [[i j val]]
                   (and (or (= i 0)
                            (< val (get-in input [(dec i) j])))
                        (or (= j 0)
                            (< val (get-in input [i (dec j)])))
                        (or (= i (dec height))
                            (< val (get-in input [(inc i) j])))
                        (or (= j (dec width))
                            (< val (get-in input [i (inc j)]))))))
         (map #(inc (get % 2)))
         (reduce +))))

(defn read-input
  [stream]
  (let [lines (str/split-lines (slurp stream))]
    (mapv
     (fn [line] (->> (str/split line #"")
                     (mapv #(Integer/parseInt %))))
     lines)))

(-> *in* read-input sum-risk println)
