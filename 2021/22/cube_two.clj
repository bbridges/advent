(ns advent-2021.cube-two
  (:require [clojure.string :as str]))

(defn remove-cuboid
  [off on]
  (let [[[off-x1 off-x2] [off-y1 off-y2] [off-z1 off-z2]] off
        [[on-x1 on-x2] [on-y1 on-y2] [on-z1 on-z2]] on]
    (if (and (>= off-x2 on-x1)
             (<= off-x1 on-x2)
             (>= off-y2 on-y1)
             (<= off-y1 on-y2)
             (>= off-z2 on-z1)
             (<= off-z1 on-z2))
      (cond-> []
        (> off-x1 on-x1) (conj [[on-x1              (dec off-x1)]
                                [on-y1              on-y2]
                                [on-z1              on-z2]])
        (< off-x2 on-x2) (conj [[(inc off-x2)       on-x2]
                                [on-y1              on-y2]
                                [on-z1              on-z2]])
        (> off-y1 on-y1) (conj [[(max off-x1 on-x1) (min off-x2 on-x2)]
                                [on-y1              (dec off-y1)]
                                [on-z1              on-z2]])
        (< off-y2 on-y2) (conj [[(max off-x1 on-x1) (min off-x2 on-x2)]
                                [(inc off-y2)       on-y2]
                                [on-z1              on-z2]])
        (> off-z1 on-z1) (conj [[(max off-x1 on-x1) (min off-x2 on-x2)]
                                [(max off-y1 on-y1) (min off-y2 on-y2)]
                                [on-z1              (dec off-z1)]])
        (< off-z2 on-z2) (conj [[(max off-x1 on-x1) (min off-x2 on-x2)]
                                [(max off-y1 on-y1) (min off-y2 on-y2)]
                                [(inc off-z2)       on-z2]]))
      [on])))

(defn merge-cuboid
  [existing [state & cuboid]]
  (if state
    (loop [[off & more] existing
           on-cuboids [(vec cuboid)]]
      (cond
        (empty? on-cuboids) existing
        (nil? off)          (into existing on-cuboids)
        :else               (recur more
                                   (mapcat (partial remove-cuboid off)
                                           on-cuboids))))
    (mapcat (partial remove-cuboid (vec cuboid)) existing)))

(defn cuboid-size
  [[[x1 x2] [y1 y2] [z1 z2]]]
  (* (- (inc x2) x1) (- (inc y2) y1) (- (inc z2) z1)))

(defn count-cubes
  [input]
  (->> input
       (reduce merge-cuboid [])
       (map cuboid-size)
       (reduce +)))

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
