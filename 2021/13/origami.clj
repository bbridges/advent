(ns advent-2021.origami
  (:require
   [clojure.string :as str]))

(defn fold-paper
  [dots [axis line]]
  (let [fold #(- line (Math/abs (- % line)))]
    (set (map #(update % axis fold) dots))))

(defn count-dots
  [input]
  (count (fold-paper (set (:dots input))
                     (first (:folds input)))))

(defn read-input
  [stream]
  (let [lines (str/split-lines (slurp stream))
        [top-lines, bottom-lines] (split-with not-empty lines)
        dots (mapv (fn [line] (mapv #(Integer/parseInt %)
                                    (str/split line #",")))
                   top-lines)
        folds (mapv (fn [line] [(case (subs line 11 12)
                                  "x" 0
                                  "y" 1)
                                (Integer/parseInt (subs line 13))])
                    (drop 1 bottom-lines))]
    {:dots dots, :folds folds}))

(-> *in* read-input count-dots println)
