(ns advent-2021.fuel-two
  (:require [clojure.string :as str]))

(defn sum-series [n] (quot (* n (+ n 1)) 2))

(defn calc-fuel
  [input]
  (->> (range (inc (- (apply max input) (apply min input))))
       (reductions (fn [acc _] (map dec acc)) input)
       (map (fn [acc] (reduce + (map #(sum-series (Math/abs %)) acc))))
       (#(apply min %))))

(defn read-input
  [stream]
  (let [raw (str/trim (slurp stream))]
    (map #(Integer/parseInt %) (str/split raw #","))))

(-> *in* read-input calc-fuel println)
