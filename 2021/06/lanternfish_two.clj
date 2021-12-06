(ns advent-2021.lanternfish-two
  (:require [clojure.string :as str]))

(defn simulate-fish
  [input]
  (let [init (reduce
              (fn [fish days] (update fish days inc))
              (vec (replicate 9 0))
              input)
        total-days 256]
    (->> (range total-days)
         (reduce
          (fn [fish _] (-> (into (subvec fish 1) (subvec fish 0 1))
                           (update 6 (partial + (first fish)))))
          init)
         (reduce + 0))))

(defn read-input
  [stream]
  (let [raw (str/trim (slurp stream))]
    (map #(Integer/parseInt %) (str/split raw #","))))

(-> *in* read-input simulate-fish println)
