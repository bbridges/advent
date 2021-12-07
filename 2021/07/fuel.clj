(ns advent-2021.fuel
  (:require [clojure.string :as str]))

(defn calc-fuel
  [input]
  (->> (range (inc (- (apply max input) (apply min input))))
       (reductions (fn [acc _] (map dec acc)) input)
       (map (fn [acc] (reduce + (map #(Math/abs %) acc))))
       (#(apply min %))))

(defn read-input
  [stream]
  (let [raw (str/trim (slurp stream))]
    (map #(Integer/parseInt %) (str/split raw #","))))

(-> *in* read-input calc-fuel println)
