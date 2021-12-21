(ns advent-2021.dice
  (:require [clojure.string :as str]))

(defn get-product
  [input]
  (loop [die (cycle (range 1 101))
         rolls 0
         curr-pos (first input)
         curr-score 0
         other-pos (second input)
         other-score 0]
    (let [[nums new-die] (split-at 3 die)
          new-rolls (+ rolls 3)
          new-pos (-> curr-pos
                      (+ (reduce + nums))
                      dec
                      (mod 10)
                      inc)
          new-score (+ curr-score new-pos)]
      (if (>= new-score 1000)
        (* other-score new-rolls)
        (recur new-die
               new-rolls
               other-pos
               other-score
               new-pos
               new-score)))))

(defn read-input
  [stream]
  (let [lines (str/split-lines (slurp stream))]
    [(Integer/parseInt (last (str/split (first lines) #" ")))
     (Integer/parseInt (last (str/split (second lines) #" ")))]))

(-> *in* read-input get-product println)
