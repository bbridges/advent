(ns advent-2021.dice-two
  (:require [clojure.string :as str]))

(def num-freq [[3 1]
               [4 3]
               [5 6]
               [6 7]
               [7 6]
               [8 3]
               [9 1]])

(defn update-pos
  [pos num]
  (-> pos (+ num) dec (mod 10) inc))

(defn update-states
  [states num freq turn]
  (reduce (fn [states [[pos score] existing]]
            (let [new-pos (update pos turn #(update-pos % num))
                  new-score (update score turn (partial + (get new-pos turn)))]
              (assoc states [new-pos new-score] (* existing freq))))
          {}
          states))

(defn get-win-count
  [input]
  (loop [states {[input [0 0]] 1}
         turn 0
         wins [0 0]]
    (if (empty? states)
      (apply max wins)
      (let [{winners true, active false}
            (->> num-freq
                 (map (fn [[num freq]] (update-states states num freq turn)))
                 (apply merge-with +)
                 (group-by (comp (partial <= 21) #(get-in % [1 turn]) key)))]
        (recur active
               (-> turn inc (mod 2))
               (update wins turn (partial + (reduce + (map val winners)))))))))

(defn read-input
  [stream]
  (let [lines (str/split-lines (slurp stream))]
    [(Integer/parseInt (last (str/split (first lines) #" ")))
     (Integer/parseInt (last (str/split (second lines) #" ")))]))

(-> *in* read-input get-win-count println)
