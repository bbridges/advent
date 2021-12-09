(ns advent-2021.basin-two
  (:require [clojure.string :as str]))

(defn basin-points
  [[field count] i j]
  (if-not (= (get-in field [i j] 9) 9)
    (-> [(assoc-in field [i j] 9) (inc count)]
        (basin-points (inc i) j)
        (basin-points i (inc j))
        (basin-points (dec i) j)
        (basin-points i (dec j)))
    [field count]))

(defn sum-top-basins
  [input]
  (->> (for [i (range (count input)) j (range (count (first input)))] [i j])
       (reduce (fn [[field basins] [i j]]
                 (let [[updated basin] (basin-points [field 0] i j)]
                   [updated (if (zero? basin) basins (conj basins basin))]))
               [input []])
       second
       (sort >)
       (take 3)
       (reduce *)))

(defn read-input
  [stream]
  (let [lines (str/split-lines (slurp stream))]
    (mapv
     (fn [line] (->> (str/split line #"")
                     (mapv #(Integer/parseInt %))))
     lines)))

(-> *in* read-input sum-top-basins println)
