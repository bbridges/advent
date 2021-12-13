(ns advent-2021.origami-two
  (:require
   [clojure.string :as str]))

(defn fold-paper
  [dots [axis line]]
  (let [fold #(- line (Math/abs (- % line)))]
    (set (map #(update % axis fold) dots))))

(defn render
  [dots]
  (let [x-dots (map first dots)
        y-dots (map second dots)
        x-range (range (apply min x-dots) (inc (apply max x-dots)))
        y-range (range (apply min y-dots) (inc (apply max y-dots)))]
    (->> (map (fn [y] (map (fn [x] (if (contains? dots [x y]) "\u2588" " "))
                           x-range))
              y-range)
         (mapv str/join)
         (str/join "\n"))))

(defn show-page
  [input]
  (render (reduce fold-paper
                  (set (:dots input))
                  (:folds input))))

(defn read-input
  [stream]
  (let [lines (str/split-lines (slurp stream))
        [top-lines, bottom-lines] (split-with not-empty lines)
        dots (mapv (fn [line] (mapv #(Integer/parseInt %)
                                    (str/split line #",")))
                   top-lines)
        folds (mapv (fn [line] [(case (subs line 11 12)
                                  "x" 0
                                  "y" 1)
                                (Integer/parseInt (subs line 13))])
                    (drop 1 bottom-lines)) ]
    {:dots dots, :folds folds}))

(-> *in* read-input show-page println)
