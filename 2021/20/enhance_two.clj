(ns advent-2021.enhance-two
  (:require [clojure.string :as str]))

(defn enhance
  [[x y] image algo]
  (let [pixels [[(inc x) (inc y)]
                [(inc x)      y]
                [(inc x) (dec y)]
                [x       (inc y)]
                [x            y]
                [x       (dec y)]
                [(dec x) (inc y)]
                [(dec x)      y]
                [(dec x) (dec y)]]]
    (->> pixels
         (map-indexed (fn [i p] (if (get-in image p) (bit-shift-left 1 i) 0)))
         (reduce bit-or)
         (get algo))))

(defn pad-image
  [image value]
  (let [width (count (first image))
        horiz-bar (vec (repeat (+ width 4) value))]
    (-> [horiz-bar horiz-bar]
        (into (mapv #(-> [value value] (into %) (into [value value])) image))
        (into [horiz-bar horiz-bar]))))

(defn count-lit
  [input]
  (let [algo (:algo input)
        flip-flop (and (first algo)
                       (not (last algo)))]
    (->> (range 50)
         (reduce
          (fn [image i]
            (let [height (count image)
                  width (count (first image))]
              (-> (mapv (fn [x] (mapv (fn [y] (enhance [x y] image algo))
                                      (range 1 (dec width))))
                        (range 1 (dec height)))
                  (pad-image (and flip-flop
                                  (zero? (mod i 2)))))))
          (-> input :image (pad-image false)))
         (mapcat (partial filter true?))
         count)))

(defn read-input
  [stream]
  (let [lines (str/split-lines (slurp stream))
        light-pixel? (partial = \#)]
    {:algo (mapv light-pixel? (first lines))
     :image (mapv (partial mapv light-pixel?) (drop 2 lines))}))


(-> *in* read-input count-lit println)
