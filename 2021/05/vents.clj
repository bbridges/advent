(ns advent-2021.vents
  (:require [clojure.string :as str]))

(defn points [x1 x2] (range (min x1 x2) (inc (max x1 x2))))

(defn overlaps
  [input]
  (->> input
       (reduce
        (fn [overlaps [x1 y1 x2 y2]]
          (cond
            (or (= x1 x2))
            (merge-with + overlaps (->> (points y1 y2)
                                        (map #(hash-map [x1 %] 1))
                                        (into {})))

            (or (= y1 y2))
            (merge-with + overlaps (->> (points x1 x2)
                                        (map #(hash-map [% y1] 1))
                                        (into {})))

            :else
            overlaps))
        {})
       (filter
        (fn [[_ num]] (>= num 2)))
       count))

(defn read-input
  [stream]
  (->> (slurp stream)
       str/split-lines
       (map (fn [line]
              (map #(Integer/parseInt %) (str/split line #",| -> "))))))

(-> *in* read-input overlaps println)
