(ns advent-2021.polymer-two
  (:require [clojure.string :as str]))

(defn apply-rules
  [polymer rules]
  (->> polymer
       (mapcat (fn [[[left right] num]]
                 (if (zero? num)
                   []
                   (if-let [inserted (get rules [left right])]
                     [{[left inserted] num}
                      {[inserted right] num}]
                     [{[left right] num}]))))
       (apply merge-with +)))

(defn pair-frequency
  [template]
  (->> template
       (partition 2 1)
       (map (fn [[left right]] {[left right] 1}))
       (apply merge-with +)))

(defn max-min
  [freq]
  [(-> (apply max-key second freq) second (quot 2))
   (-> (apply min-key second freq) second (quot 2))])

(defn insert-pairs
  [input]
  (let [template (:template input)
        rules (into {} (:rules input))
        steps 40]
    (->> (range steps)
         (reduce (fn [polymer, _] (apply-rules polymer rules))
                 (pair-frequency template))
         (mapcat (fn [[[left right] num]] [{left num} {right num}]))
         (into [{(first template) 1} {(last template) 1}])
         (apply merge-with +)
         max-min
         (apply -))))

(defn read-input
  [stream]
  (let [lines (str/split-lines (slurp stream))]
    {:template (vec (first lines))
     :rules (mapv #(vector [(get % 0) (get % 1)] (get % 6)) (drop 2 lines))}))

(-> *in* read-input insert-pairs println)
