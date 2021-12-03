(ns advent-2021.binary-two
  (:require [clojure.string :as str]))

(defn calc-rate
  [input place fun]
  (if (= 1 (count input))
    (Integer/parseInt (first input) 2)
    (let [{zeros \0, ones \1} (group-by #(nth % place) input)]
      (if (fun (count ones) (count zeros))
        (recur ones (inc place) fun)
        (recur zeros (inc place) fun)))))

(defn calc-rates
  [input]
  (let [{zeros \0 ones \1} (group-by first input)]
    [(calc-rate ones 1 >=)
     (calc-rate zeros 1 <)]))

(defn life-support-rating [[oxygen co2]] (* oxygen co2))

(defn read-input
  [stream]
  (let [raw (str/trim (slurp stream))]
    (str/split-lines raw)))

(-> *in* read-input calc-rates life-support-rating println)
