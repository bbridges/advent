(ns advent-2021.snailfish-two
  (:require
   [clojure.edn :as edn]
   [clojure.string :as str]
   [clojure.walk :as walk]
   [clojure.zip :as zip]))

(defn edit-dir
  [loc f forward backward]
  (let [[moved [found & _]] (->> (iterate forward loc)
                                 (drop 1)
                                 (take-while #(and (some? (zip/up %))
                                                   (not (zip/end? %))))
                                 (split-with (every-pred some? zip/branch?)))]
    (if (some? found)
      (nth (iterate backward (zip/edit found f))
           (inc (count moved)))
      loc)))

(defn edit-left [loc f] (edit-dir loc f zip/prev zip/next))

(defn edit-right [loc f] (edit-dir loc f zip/next zip/prev))

(defn explode-sf
  ([sf]
   (let [[updated changed] (explode-sf sf false 0)]
     (when changed updated)))
  ([sf changed level]
   (if (zip/branch? sf)
     (if (= 4 level)
       (-> sf
           zip/down
           (as-> l (edit-left l (partial + (zip/node l))))
           zip/right
           (as-> r (edit-right r (partial + (zip/node r))))
           zip/up
           (zip/replace 0)
           (vector true))
       (let [next-level (inc level)]
         (as-> [sf changed] [s c]
           [(zip/down s) c]
           (explode-sf s c next-level)
           [(zip/right s) c]
           (explode-sf s c next-level)
           [(zip/up s) c])))
     [sf changed])))

(defn split-sf
  [sf]
  (when-let [splittable (->> (iterate zip/next sf)
                             (take-while (complement zip/end?))
                             (remove zip/branch?)
                             (filter #(> (zip/node %) 9))
                             first)]
    (let [value (zip/node splittable)
          left-split (quot value 2)
          right-split (- value left-split)]
      (->> (zip/replace splittable [left-split right-split])
           (iterate zip/up)
           (take-while some?)
           last))))

(defn add-sf
  [sf right]
  (zip/vector-zip [(zip/node sf) right]))

(defn magnitude-sf
  [sf]
  (walk/postwalk (fn [value] (if (vector? value)
                               (+ (* 3 (first value)) (* 2 (second value)))
                               value))
                 (zip/node sf)))

(defn max-magnitude
  [input]
  (let [input-range (range (count input))]
    (->> input-range
         (mapcat #(map (partial vector %) input-range))
         (remove (partial apply =))
         (map (fn [[left right]]
                (->> (nth input right)
                     (add-sf (zip/vector-zip (nth input left)))
                     (iterate (fn [sf] (if-let [exploded (explode-sf sf)]
                                         (or (split-sf exploded) exploded)
                                         (split-sf sf))))
                     (take-while some?)
                     last
                     magnitude-sf)))
         (reduce max))))

(defn read-input
  [stream]
  (let [lines (str/split-lines (slurp stream))]
    (map edn/read-string lines)))

(-> *in* read-input max-magnitude println)
