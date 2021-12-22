(ns advent-2021.cube
  (:require [clojure.string :as str]))

(defn cube-range [[low high]] (range (max -50 low) (min 51 (inc high))))

(defn count-cubes
  [input]
  (loop [on-cubes #{}
         cuboids input]
    (if-let [[state xs ys zs] (first cuboids)]
      (let [cubes (for [x (cube-range xs)
                        y (cube-range ys)
                        z (cube-range zs)] [x y z])]
        (recur (if state
                 (into on-cubes cubes)
                 (apply disj on-cubes cubes))
               (rest cuboids)))
      (count on-cubes))))

(def line-pattern #"(on|off) x=(.+)\.\.(.+),y=(.+)\.\.(.+),z=(.+)\.\.(.+)")

(defn read-input
  [stream]
  (let [lines (str/split-lines (slurp stream))]
    (mapv (fn [line]
            (let [[_ state & nums] (re-matches line-pattern line)]
              (into [(= state "on")]
                    (->> nums
                         (mapv #(Integer/parseInt %))
                         (partition 2)
                         (mapv vec)))))
          lines)))

(-> *in* read-input count-cubes println)
