(ns advent-2021.probe)

(defn highest-point
  [input]
  (let [[_ _ bottom top] input]
    (->> (range (- bottom) (- bottom 1) -1)
         (filter (fn [v-yi] (loop [y 0
                                   v-y v-yi]
                              (cond
                                (< y bottom) false
                                (<= y top)   true
                                :else        (recur (+ y v-y) (- v-y 1))))))
         first
         ((fn [v-yi] (max 0 (quot (* v-yi (+ v-yi 1)) 2)))))))

(defn read-input
  [stream]
  (->> (slurp stream)
       (re-matches #"target area: x=(.+)\.\.(.+), y=(.+)\.\.(.+)")
       rest
       (mapv #(Integer/parseInt %))))

(-> *in* read-input highest-point println)
