(ns advent-2021.chiton-two
  (:require
   [clojure.data.priority-map :refer [priority-map]]
   [clojure.string :as str]))

(defn inc-risk [risk i j] (inc (mod (dec (+ risk i j)) 9)))

(defn full-cave
  [input]
  (let [height (count input)
        width (count (first input))
        risk (fn [i j] (-> input
                           (get-in [(mod i height) (mod j width)])
                           (inc-risk (quot i height) (quot j width))))]
    (mapv (fn [i] (mapv (fn [j] (risk i j)) (range (* 5 width))))
          (range (* 5 height)))))

(defn distance
  [[x1 y1] [x2 y2]]
  (+ (Math/abs (- x2 x1)) (Math/abs (- y2 y1))))

(defn lowest-risk
  [input]
  (let [cave (full-cave input)
        start [0 0]
        goal [(dec (count cave))
              (dec (count (first cave)))]]
    (loop [open-set (priority-map start (distance start goal))
           risks (hash-map start 0)]
      (let [[pos _] (peek open-set)
            risk (get risks pos)]
        (if (= pos goal)
          risk
          (let [update (fn [[open-set risks] n]
                         (if-let [weight (get-in cave n)]
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
