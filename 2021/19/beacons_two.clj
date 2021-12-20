(ns advent-2021.beacons-two
  (:require [clojure.string :as str]))

(def rotations [#(vector    %3     %2  (- %1))
                #(vector    %3     %1     %2)
                #(vector    %3  (- %1) (- %2))
                #(vector    %3  (- %2)    %1)
                #(vector    %2     %3     %1)
                #(vector    %2     %1  (- %3))
                #(vector    %2  (- %1)    %3)
                #(vector    %2  (- %3) (- %1))
                #(vector    %1     %3  (- %2))
                #(vector    %1     %2     %3)
                #(vector    %1  (- %2) (- %3))
                #(vector    %1  (- %3)    %2)
                #(vector (- %1)    %3     %2)
                #(vector (- %1)    %2  (- %3))
                #(vector (- %1) (- %2)    %3)
                #(vector (- %1) (- %3) (- %2))
                #(vector (- %2)    %3  (- %1))
                #(vector (- %2)    %1     %3)
                #(vector (- %2) (- %1) (- %3))
                #(vector (- %2) (- %3)    %1)
                #(vector (- %3)    %2     %1)
                #(vector (- %3)    %1  (- %2))
                #(vector (- %3) (- %1)    %2)
                #(vector (- %3) (- %2) (- %1))])

(defn normalize
  [reference variant]
  (when-let [[offset _] (->> (for [[x1 y1 z1] reference
                                   [x2 y2 z2] variant]
                               [(- x1 x2) (- y1 y2) (- z1 z2)])
                             frequencies
                             (filter (comp (partial <= 12) val))
                             first)]
    [offset
     (let [[x1 y1 z1] offset]
       (mapv (fn [[x2 y2 z2]] [(+ x1 x2) (+ y1 y2) (+ z1 z2)])
             variant))]))

(defn match-scanner-pair
  [positions normalized scanners]
  (loop [idx 0]
    (let [readings (get scanners idx)
          variants (map (fn [r] (map #(apply r %) readings)) rotations)]
      (if-let [[offset match] (->> (for [v variants n normalized]
                                     (normalize n v))
                                   (filter some?)
                                   first)]
        [(conj positions offset)
         (conj normalized match)
         (into (subvec scanners 0 idx) (subvec scanners (inc idx)))]
        (recur (inc idx))))))

(defn max-scanner-distance
  [input]
  (let [positions (->> [[[0 0 0]] (subvec input 0 1) (subvec input 1)]
                       (iterate (partial apply match-scanner-pair))
                       (filter (comp empty? last))
                       ffirst)]
    (apply max (for [[x1 y1 z1] positions
                     [x2 y2 z2] positions]
                 (+ (Math/abs (- x1 x2))
                    (Math/abs (- y1 y2))
                    (Math/abs (- z1 z2)))))))

(defn read-input
  [stream]
  (->> (slurp stream)
       str/split-lines
       (partition-by empty?)
       (remove (comp (partial = 1) count))
       (mapv (fn [line]
               (->> (rest line)
                    (mapv #(str/split % #","))
                    (mapv (partial mapv #(Integer/parseInt %))))))))

(-> *in* read-input max-scanner-distance println)
