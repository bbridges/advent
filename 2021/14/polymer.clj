(ns advent-2021.polymer
  (:require [clojure.string :as str]))

(defn apply-rules
  [polymer rules]
  (conj (mapcat (fn [[prev, ch]]
                  (if-let [inserted (get rules [prev, ch])]
                    [inserted ch]
                    [ch]))
                (partition 2 1 polymer))
        (first polymer)))

(defn insert-pairs
  [input]
  (let [template (:template input)
        rules (into {} (:rules input))
        steps 10
        polymer (reduce (fn [polymer, _] (apply-rules polymer rules))
                        template
                        (range steps))
        freq (frequencies polymer)]
    (- (second (apply max-key second freq))
       (second (apply min-key second freq)))))

(defn read-input
  [stream]
  (let [lines (str/split-lines (slurp stream))]
    {:template (vec (first lines))
     :rules (mapv #(vector [(get % 0) (get % 1)] (get % 6)) (drop 2 lines))}))

(-> *in* read-input insert-pairs println)
