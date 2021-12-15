(ns advent-2021.chiton
  (:require
   [clojure.data.priority-map :refer [priority-map]]
   [clojure.string :as str]))

(defn distance
  [[x1 y1] [x2 y2]]
  (+ (Math/abs (- x2 x1)) (Math/abs (- y2 y1))))

(defn lowest-risk
  [input]
  (let [start [0 0]
        goal [(dec (count input))
              (dec (count (first input)))]]
    (loop [open-set (priority-map start (distance start goal))
           risks (hash-map start 0)]
      (let [[pos _] (peek open-set)
            risk (get risks pos)]
        (if (= pos goal)
          risk
          (let [update (fn [[open-set risks] n]
                         (if-let [weight (get-in input n)]
                           (let [next (+ risk weight)]
                             (if (< next
                                    (get risks n Long/MAX_VALUE))
                               [(assoc open-set n (+ next (distance n goal)))
                                (assoc risks n next)]
                               [open-set risks]))
                           [open-set risks]))
                [i j] pos
                [open-set risks] (-> [(pop open-set) risks]
                                     (update [(inc i) j])
                                     (update [(dec i) j])
                                     (update [i (inc j)])
                                     (update [i (dec j)]))]
            (recur open-set risks)))))))

(defn read-input
  [stream]
  (mapv (fn [line] (mapv (fn [ch] (- (int ch) 48)) line))
        (str/split-lines (slurp stream))))

(-> *in* read-input lowest-risk println)
