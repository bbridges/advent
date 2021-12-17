(ns advent-2021.probe-two)

(defn vel-times
  [low high update out in t-max]
  (->> (range low (inc high))
       (map (fn [v-i]
              (->> (if t-max (range 1 (inc t-max)) (drop 1 (range)))
                   (reductions (fn [[x v _] t]
                                 (vector (+ x v) (update v) t))
                               (vector 0 v-i 0))
                   (drop-while (fn [[x _ _]] (out x)))
                   (take-while (fn [[x _ _]] (in x)))
                   (mapcat (fn [[_ _ t]] (vector t [v-i])))
                   (apply hash-map))))
       (apply merge-with into)))

(defn distinct-vel
  [input]
  (let [[x1 x2 y1 y2] input
        vert (vel-times y1 (- y1) #(dec %) #(> % y2) #(>= % y1) nil)
        t-max (apply max (keys vert))
        horiz (vel-times 0 x2 #(max 0 (dec %)) #(< % x1) #(<= % x2) t-max)]
    (->> (range (inc t-max))
         (mapcat (fn [t] (for [v (get vert t [])
                               h (get horiz t [])]
                           (vector v h))))
         distinct
         count)))

(defn read-input
  [stream]
  (->> (slurp stream)
       (re-matches #"target area: x=(.+)\.\.(.+), y=(.+)\.\.(.+)")
       rest
       (mapv #(Integer/parseInt %))))

(-> *in* read-input distinct-vel println)
