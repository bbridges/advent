(ns advent-2021.binary
  (:require [clojure.string :as str]))

(defn calc-rates
  [input]
  (let [input-count (count input)
        common (->> input
                    (apply mapv vector)
                    (map #(filter (partial = \1) %))
                    (map #(>= (count %) (/ input-count 2))))]
    [(Integer/parseInt (str/join (map #(if % \1 \0) common)) 2)
     (Integer/parseInt (str/join (map #(if % \0 \1) common)) 2)]))

(defn power-consumption [[gamma epsilon]] (* gamma epsilon))

(defn read-input
  [stream]
  (let [raw (str/trim (slurp stream))]
    (str/split-lines raw)))

(-> *in* read-input calc-rates power-consumption println)
