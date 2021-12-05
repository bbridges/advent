(ns advent-2021.vents-two
  (:require [clojure.string :as str]))

(defn classify
  [x1 y1 x2 y2]
  (cond
    (= x1 x2)                      'vert
    (= y1 y2)                      'horiz
    (pos? (/ (- y2 y1) (- x2 x1))) 'pos_diag
    :else                          'neg_diag))

(defn points
  ([x1 x2]
   (range (min x1 x2) (inc (max x1 x2))))
  ([x1 y1 x2 y2]
   (case (classify x1 y1 x2 y2)
     vert     (map #(vector x1 %) (points y1 y2))
     horiz    (map #(vector % y1) (points x1 x2))
     pos_diag (map vector (points x1 x2) (points y1 y2))
     neg_diag (map vector (reverse (points x1 x2)) (points y1 y2)))))

(defn overlaps
  [input]
  (->> input
       (reduce
        (fn [overlaps [x1 y1 x2 y2]]
          (merge-with + overlaps (->> (points x1 y1 x2 y2)
                                      (map #(hash-map % 1))
                                      (into {}))))
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
